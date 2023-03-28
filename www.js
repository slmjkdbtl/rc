// helpers for the world wide web with Bun

import { Database } from "bun:sqlite"
import * as fs from "fs"

export function createServer() {

	const handlers = []
	const handle = (handler) => handlers.push(handler)

	let handleError = (req, err) => {
		if (Bun.env["DEV"]) {
			throw err
		} else {
			const url = new URL(req.url)
			console.error(`Time: ${new Date()}`)
			console.error(`Request: ${req.method} ${url.pathname}`)
			console.error("")
			console.error(err)
			return new Response("Internal server error", { status: 500 })
		}
	}

	let handleNotFound = () => new Response("404", { status: 404 })

	function handleMatch(req, pat, handler) {
		const url = new URL(req.url)
		const match = matchUrl(pat, url.pathname)
		if (match) return handler(req, match)
	}

	function genMethodHandler(method) {
		return (pat, handler) => {
			handlers.push((req) => {
				if (req.method !== method) return
				return handleMatch(req, pat, handler)
			})
		}
	}

	async function fetch(req) {
		// TODO: better async?
		for (const handle of handlers) {
			try {
				const res = handle(req)
				if (res instanceof Promise) {
					const awaitedRes = await res
					if (awaitedRes) return awaitedRes
				} else {
					if (res) return res
				}
			} catch (e) {
				return handleError(req, e)
			}
		}
		return handleNotFound(req)
	}

	return {
		handle: handle,
		error: (action) => handleError = action,
		notFound: (action) => handleNotFound = action,
		files: (route = "", root = "") => {
			handle((req) => {
				const url = new URL(req.url)
				route = trimSlashes(route)
				root = trimSlashes(root)
				const dir = "./" + root + (root ? "/" : "")
				if (!url.pathname.startsWith("/" + route)) return
				const path = dir + url.pathname.replace(new RegExp(`^/${route}/?`), "")
				return res.file(path)
			})
		},
		match: (pat, cb) => handle((req) => handleMatch(req, pat, handler)),
		get: genMethodHandler("GET"),
		post: genMethodHandler("POST"),
		put: genMethodHandler("PUT"),
		delete: genMethodHandler("DELETE"),
		patch: genMethodHandler("PATCH"),
		start: (port, hostname) => {
			return Bun.serve({
				port: port,
				hostname: hostname,
				fetch: fetch,
			})
		},
		fetch: fetch,
	}
}

export function createDatabase(dbname) {

	const doInit = !fs.existsSync(dbname)
	const bdb = new Database(dbname)
	const queries = {}
	let migrationLock = true

	function compile(sql) {
		sql = sql.trim()
		if (!queries[sql]) {
			queries[sql] = bdb.query(sql)
		}
		return queries[sql]
	}

	// TODO: support OR
	function where(cond, vars) {
		for (const k in cond) {
			vars[`$where_${k}`] = typeof cond[k] === "object" ? cond[k].value : cond[k]
		}
		return `WHERE ${Object.keys(cond).map((k) => {
			if (typeof cond[k] === "object") {
				return `${k} ${cond[k].op} $where_${k}`
			} else {
				return `${k} = $where_${k}`
			}
		}).join(" AND ")}`
	}

	function order(cond) {
		return `ORDER BY ${cond.columns.join(", ")}${cond.desc ? " DESC" : ""}`
	}

	function limit(cond, vars) {
		vars["$limit"] = cond
		return `LIMIT $limit`
	}

	function values(data, vars) {
		for (const key in data) {
			vars[`$value_${key}`] = data[key]
		}
		return `VALUES (${Object.keys(data).map((k) => `$value_${k}`).join(", ")})`
	}

	function set(data, vars) {
		for (const key in data) {
			vars[`$set_${key}`] = data[key]
		}
		return `SET ${Object.keys(data).map((k) => `${k} = $set_${k}`).join(", ")}`
	}

	function column(name, opts) {
		let code = name + " " + opts.type
		if (opts.primaryKey) code += " PRIMARY KEY"
		if (opts.autoIncrement) code += " AUTOINCREMENT"
		if (!opts.allowNull) code += " NOT NULL"
		if (opts.unique) code += " UNIQUE"
		// TODO: interpolate js value
		if (opts.default !== undefined) code += ` DEFAULT ${opts.default}`
		return code
	}

	function columns(cols) {
		let code = ""
		let pcode = ""
		for (const name in cols) {
			const opts = cols[name]
			code += column(name, opts)
			if (opts.reference) {
				pcode += `FOREIGN KEY(${name}) REFERENCES ${opts.reference.table}(${opts.reference.column}),\n`
			}
			code += ",\n"
		}
		return (code + pcode).slice(0, -2)
	}

	// TODO: support immediate / exclusive
	function transaction(action) {
		bdb.transaction(action)()
	}

	function init(action) {
		if (doInit) {
			migrationLock = false
			transaction(action)
			migrationLock = true
		}
	}

	function migration(name, action) {
		const done = new Set(select("migration").map((mig) => mig.name))
		if (!done.has(name)) {
			migrationLock = false
			transaction(action)
			migrationLock = true
		}
	}

	function select(table, opts = {}) {
		if (!table) {
			throw new Error("Cannot SELECT from database without table")
		}
		const vars = {}
		return compile(`
SELECT${opts.distinct ? " DISTINCT" : ""} ${!opts.columns || opts.columns === "*" ? "*" : opts.columns.join(", ")}
FROM ${table}
${opts.where ? where(opts.where, vars) : ""}
${opts.order ? order(opts.order, vars) : ""}
${opts.limit ? limit(opts.limit, vars) : ""}
		`).all(vars) ?? []
	}

	function insert(table, data) {
		if (!table || !data) {
			throw new Error("Cannot INSERT into database without table / data")
		}
		const vars = {}
		compile(`
INSERT INTO ${table} (${Object.keys(data).join(", ")})
${values(data, vars)}
		`).run(vars)
	}

	function update(table, data, cond) {
		if (!table || !data || !where) {
			throw new Error("Cannot UPDATE database without table / data / where")
		}
		const vars = {}
		const keys = Object.keys(data)
		compile(`
UPDATE ${table}
${set(data, vars)}
${where(cond, vars)}
		`).run(vars)
	}

	function remove(table, cond) {
		if (!table || !cond) {
			throw new Error("Cannot DELETE from database without table / where")
		}
		const vars = {}
		compile(`
DELETE FROM ${table}
${where(cond, vars)}
		`).run(vars)
	}

	function create(table, cols) {
		if (migrationLock)
			throw new Error("Must only alter tables in init() or migration()")
		bdb.run(`
CREATE TABLE ${table} (
${columns({
...cols,
"time_created": { type: "TEXT", notNull: true, default: "CURRENT_TIMESTAMP" },
"time_updated": { type: "TEXT", notNull: true, default: "CURRENT_TIMESTAMP" },
})}
)
		`)
		const pks = []
		for (const name in cols) {
			const config = cols[name]
			if (config.primaryKey) {
				pks.push(name)
			}
			if (config.index) {
				bdb.run(`
CREATE INDEX idx_${table}_${name} ON ${table}(${name})
				`)
			}
		}
		// TODO: composite pk?
		if (pks.length === 1) {
			const pk = pks[0]
			bdb.run(`
CREATE TRIGGER trigger_${table}_time_updated
AFTER UPDATE ON ${table}
BEGIN
UPDATE ${table} SET time_updated = CURRENT_TIMESTAMP WHERE ${pk} = NEW.${pk};
END
			`)
		}
	}

	function drop(table) {
		if (migrationLock)
			throw new Error("Must only alter tables in init() or migration()")
		bdb.run(`
DROP TABLE ${table}
		`)
	}

	function addColumn(table, name, opts) {
		if (migrationLock)
			throw new Error("Must only alter tables in init() or migration()")
		bdb.run(`
ALTER TABLE ${table}
ADD ${column(name, opts)}}
		`)
	}

	function dropColumn(table, name) {
		if (migrationLock)
			throw new Error("Must only alter tables in init() or migration()")
		bdb.run(`
ALTER TABLE ${table}
DROP COLUMN ${name}}
		`)
	}

	function renameColumn(table, from, to) {
		if (migrationLock)
			throw new Error("Must only alter tables in init() or migration()")
		bdb.run(`
ALTER TABLE ${table}
RENAME COLUMN ${from} TO ${to}}
		`)
	}

	if (doInit) {
		migrationLock = false
		create("migration", {
			"name": { type: "TEXT", primaryKey: true },
		})
		migrationLock = true
	}

	return {
		init,
		migration,
		create,
		select,
		insert,
		update,
		delete: remove,
		drop,
		addColumn,
		dropColumn,
		renameColumn,
		transaction,
		run: bdb.run,
		close: bdb.close,
		serialize: bdb.serialize,
	}

}

export function matchUrl(pat, url) {

	pat = pat.replace(/\/$/, "")
	url = url.replace(/\/$/, "")

	if (pat === url) return {}

	const vars = pat.match(/:[^\/]+/g) || []
	let regStr = pat

	for (const v of vars) {
		const name = v.substring(1)
		regStr = regStr.replace(v, `(?<${name}>[^\/]+)`)
	}

	regStr = "^" + regStr + "$"

	const reg = new RegExp(regStr)
	const matches = reg.exec(url)

	if (matches) {
		return { ...matches.groups }
	} else {
		return null
	}

}

const trimSlashes = (str) => str.replace(/\/*$/, "").replace(/^\/*/, "")

const isFile = (path) => {
	try {
		return fs.statSync(path).isFile()
	} catch {
		return false
	}
}

const isDir = (path) => {
	try {
		return fs.statSync(path).isDirectory()
	} catch {
		return false
	}
}

const getExt = (path) => path.split(".").pop()

export const res = {
	text: (content, opts = {}) => new Response(content, {
		status: opts.status ?? 200,
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
			...(opts.headers ?? {}),
		},
	}),
	html: (content, opts = {}) => new Response(content, {
		status: opts.status ?? 200,
		headers: {
			"Content-Type": "text/html; charset=utf-8",
			...(opts.headers ?? {}),
		},
	}),
	redirect: (link, opts = {}) => new Response(null, {
		status: opts.status ?? 302,
		headers: {
			"Location": link,
			...(opts.headers ?? {}),
		},
	}),
	// TODO: accept opts?
	file: (path) => {
		if (!isFile(path)) return
		const file = Bun.file(path)
		if (file.size === 0) return
		return new Response(file)
	},
	dir: (path, opts = {}) => {
		if (!isDir(path)) return
		const entries = fs.readdirSync(path)
			.filter((entry) => !entry.startsWith("."))
			.sort((a, b) => a > b ? -1 : 1)
			.sort((a, b) => getExt(a) > getExt(b) ? 1 : -1)
		const files = []
		const dirs = []
		for (const entry of entries) {
			if (isDir(entry)) {
				dirs.push(entry)
			} else {
				files.push(entry)
			}
		}
		return res.html("<!DOCTYPE html>" + h("html", { lang: "en" }, [
			h("head", {}, [
				h("title", {}, path),
				h("style", {}, css({
					"*": {
						"margin": "0",
						"padding": "0",
						"box-sizing": "border-box",
					},
					"body": {
						"padding": "16px",
						"font-size": "16px",
						"font-family": "Monospace",
					},
					"li": {
						"list-style": "none",
					},
					"a": {
						"color": "blue",
						"text-decoration": "none",
						":hover": {
							"background": "blue",
							"color": "white",
						},
					},
				})),
			]),
			h("body", {}, [
				h("ul", {}, [
					...dirs.map((dir) => h("li", {}, [
						h("a", { href: dir, }, dir + "/"),
					])),
					...files.map((file) => h("li", {}, [
						h("a", { href: file, }, file),
					])),
				]),
			]),
		]), opts)
	},
}

export function getCookies(req) {
	const str = req.headers.get("Cookie")
	if (!str) return {}
	const cookies = {}
	for (const c of str.split(";")) {
		const [k, v] = c.split("=")
		cookies[k.trim()] = v.trim()
	}
	return cookies
}

// html text builder
export function h(tagname, attrs, children) {

	let html = `<${tagname}`

	for (const k in attrs) {
		let v = attrs[k]
		switch (typeof v) {
			case "boolean":
				if (v === true) {
					html += ` ${k}`
				}
				break
			case "string":
				html += ` ${k}="${escapeHTML(v)}"`
				break
			case "number":
				html += ` ${k}=${v}`
				break
			case "object":
				const value = Array.isArray(v) ? v.join(" ") : style(v)
				html += ` ${k}="${escapeHTML(value)}"`
				break
		}
	}

	html += ">"

	if (typeof(children) === "string" || typeof(children) === "number") {
		html += children
	} else if (Array.isArray(children)) {
		for (const child of children) {
			if (!child) continue
			if (Array.isArray(child)) {
				html += h("div", {}, child)
			} else {
				html += child
			}
		}
	}

	if (children !== undefined && children !== null) {
		html += `</${tagname}>`
	}

	return html

}

const camelToKababCase = (str) =>
	str.replace(/[A-Z]/g, (c) => `-${c.toLowerCase()}`)

export function style(sheet) {
	let style = ""
	for (const prop in sheet) {
		style += `${prop}: ${sheet[prop]};`
	}
	return style
}

// TODO: @font-face
// sass-like css preprocessor
export function css(list) {

	let text = ""

	function handleSheet(s) {
		let t = "{"
		for (const k in s) {
			t += camelToKababCase(k) + ":" + s[k] + ";"
		}
		t += "}"
		return t
	}

	function handleSheetEx(sel, sheet) {
		let t = sel + " {"
		let post = ""
		for (const key in sheet) {
			const val = sheet[key]
			// media
			if (key === "@media") {
				for (const cond in val) {
					post += "@media " + cond + "{" + sel + handleSheet(val[cond]) + "}"
				}
			// pseudo class
			} else if (key[0] === ":") {
				post += handleSheetEx(sel + key, val)
			// self
			} else if (key[0] === "&") {
				post += handleSheetEx(sel + key.substring(1), val)
			// nesting child
			} else if (typeof(val) === "object") {
				post += handleSheetEx(sel + " " + key, val)
			} else {
				t += camelToKababCase(key) + ":" + val + ";"
			}
		}
		t += "}" + post
		return t
	}

	for (const sel in list) {
		const sheet = list[sel]
		if (sel === "@keyframes") {
			for (const name in sheet) {
				const map = sheet[name]
				text += "@keyframes " + name + "{"
				for (const time in map) {
					text += time + handleSheet(map[time])
				}
				text += "}"
			}
		} else {
			text += handleSheetEx(sel, sheet)
		}
	}

	return text

}

export function escapeHTML(unsafe) {
	return unsafe
		.replace(/&/g, "&amp")
		.replace(/</g, "&lt")
		.replace(/>/g, "&gt")
		.replace(/"/g, "&quot")
		.replace(/'/g, "&#039")
}

function mapKeys(obj, mapFn) {
	return Object.keys(obj).reduce((result, key) => {
		result[mapFn(key)] = obj[key]
		return result
	}, {})
}

// TODO: a way to only generate used classes, record in h()?
// TODO: deal with pseudos like :hover
export function csslib(opt = {}) {

	// tailwind-like css helpers
	const base = {
		".vstack": { "display": "flex", "flex-direction": "column" },
		".hstack": { "display": "flex", "flex-direction": "row" },
		".vstack-reverse": { "display": "flex", "flex-direction": "column-reverse" },
		".hstack-reverse": { "display": "flex", "flex-direction": "row-reverse" },
		".stretch-x": { "width": "100%" },
		".stretch-y": { "height": "100%" },
		".bold": { "font-weight": "bold" },
		".italic": { "font-style": "italic" },
		".underline": { "font-decoration": "underline" },
		".center": { "align-items": "center", "justify-content": "center" },
		".align-start": { "align-items": "flex-start" },
		".align-end": { "align-items": "flex-end" },
		".align-center": { "align-items": "center" },
		".align-stretch": { "align-items": "stretch" },
		".align-baseline": { "align-items": "baseline" },
		".justify-start": { "justify-content": "flex-start" },
		".justify-end": { "justify-content": "flex-end" },
		".justify-center": { "justify-content": "center" },
		".justify-between": { "justify-content": "space-between" },
		".justify-around": { "justify-content": "space-around" },
		".justify-evenly": { "justify-content": "space-evenly" },
		".align-self-start": { "align-items": "flex-start" },
		".align-self-end": { "align-self": "flex-end" },
		".align-self-center": { "align-self": "center" },
		".align-self-stretch": { "align-self": "stretch" },
		".align-self-baseline": { "align-self": "baseline" },
		".text-center": { "text-align": "center" },
		".text-left": { "text-align": "left" },
		".text-right": { "text-align": "right" },
		".wrap": { "flex-wrap": "wrap" },
		".wrap-reverse": { "flex-wrap": "wrap-reverse" },
		".nowrap": { "flex-wrap": "no-wrap" },
	}

	for (let i = 1; i <= 8; i++) {
		base[`.grow-${i}}`] = { "flex-grow": i }
		base[`.shrink-${i}}`] = { "flex-shrink": i }
		base[`.flex-${i}}`] = { "flex-grow": i, "flex-shrink": i }
	}

	const spaces = [2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96, 128]

	for (const s of spaces) {
		base[`.g${s}`] = { "gap": `${s}px` }
		base[`.p${s}`] = { "padding": `${s}px` }
		base[`.px${s}`] = { "padding-left": `${s}px`, "padding-right": `${s}px` }
		base[`.py${s}`] = { "padding-top": `${s}px`, "padding-bottom": `${s}px` }
		base[`.m${s}`] = { "margin": `${s}px` }
		base[`.mx${s}`] = { "margin-left": `${s}px`, "margin-right": `${s}px` }
		base[`.my${s}`] = { "margin-top": `${s}px`, "margin-bottom": `${s}px` }
		base[`.f${s}`] = { "font-size": `${s}px` }
		base[`.r${s}`] = { "border-radius": `${s}px` }
	}

	const compileStyles = (sheet) => {
		let css = ""
		for (const sel in sheet) {
			css += `${sel} { ${style(sheet[sel])} } `
		}
		return css
	}

	let css = compileStyles(base)
	const breakpoints = opt.breakpoints ?? {}

	for (const bp in breakpoints) {
		csslib += `@media (max-width: ${breakpoints[bp]}px) {`
		csslib += compileStyles(mapKeys(base, (sel) => `.${bp}:${sel.substring(1)}`))
		csslib += `}`
	}

	return css

}

const cmds = {
	dev: () => {
		Bun.spawnSync(["bun", "--hot", "main.js"], {
			env: { ...process.env, "DEV": 1 },
			stdin: "inherit",
			stdout: "inherit",
			stderr: "inherit",
		})
	},
	deploy: (host, dir, job) => {
		if (!host || !dir || !job) {
console.error("Missing arguments!")
			console.log("")
			console.log(`
USAGE
    # Copy project to server and restart systemd job
    $ deploy <host> <dir> <job>
			`.trim())
			return
		}
		Bun.spawnSync([
			"rsync",
			"-av",
			"--delete",
			"--exclude", ".DS_Store",
			"--exclude", ".git",
			"--exclude", "data",
			".",
			`${host}:${dir}`,
		], {
			stdin: "inherit",
			stdout: "inherit",
			stderr: "inherit",
		})
		Bun.spawnSync([
			"ssh",
			"-t",
			host,
			"sudo",
			"systemctl",
			"restart",
			job,
		], {
			stdin: "inherit",
			stdout: "inherit",
			stderr: "inherit",
		})
	},
}

const cmd = process.argv[2]

if (cmd) {
	if (cmds[cmd]) {
		cmds[cmd](...process.argv.slice(3))
	} else {
		console.error(`Command not found: ${cmd}`)
		console.log("")
		console.log(`
USAGE
    # Start dev server
    $ bun www.js dev

    # Copy files to server and restart systemd job
    $ bun www.js deploy <host> <dir> <job>
		`.trim())
	}
}
