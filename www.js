// helpers for the world wide web with Bun

import { statSync, readdirSync } from "fs"

export function createServer() {

	const handlers = []
	const handle = (handler) => handlers.push(handler)

	let handleError = (req, e) => {
		console.error("Error:", e)
		return new Response("Internal server error", { status: 500 })
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
		del: genMethodHandler("DEL"),
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
		return statSync(path).isFile()
	} catch {
		return false
	}
}

const isDir = (path) => {
	try {
		return statSync(path).isDirectory()
	} catch {
		return false
	}
}

const getExt = (path) => path.split(".").pop()

export const res = {
	text: (content, status = 200) => new Response(content, {
		status: status,
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
		},
	}),
	html: (content, status = 200) => new Response(content, {
		status: status,
		headers: {
			"Content-Type": "text/html; charset=utf-8",
		},
	}),
	redirect: (link, status = 307) => new Response(null, {
		status: status,
		headers: {
			"Location": link,
		},
	}),
	file: (path) => {
		if (!isFile(path)) return
		const file = Bun.file(path)
		if (file.size === 0) return
		return new Response(file)
	},
	dir: (path) => {
		if (!isDir(path)) return
		const entries = readdirSync(path)
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
		]))
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
				html += ` ${k}="${v}"`
				break
			case "number":
				html += ` ${k}=${v}`
				break
			case "object":
				if (Array.isArray(v)) {
					html += ` ${k}="${v.join(" ")}"`
				} else {
					html += ` ${k}="${style(v)}"`
				}
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

// TODO: caching
export function createQueryRunner(db) {

	const queries = {}

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

	return {

		select: (table, opts = {}) => {
			if (!table) {
				throw new Error("Cannot SELECT from database without table")
			}
			const vars = {}
			const sql = `
SELECT${opts.distinct ? " DISTINCT" : ""} ${!opts.columns || opts.columns === "*" ? "*" : opts.columns.join(", ")}
FROM ${table}
${opts.where ? where(opts.where, vars) : ""}
${opts.order ? order(opts.order, vars) : ""}
${opts.limit ? limit(opts.limit, vars) : ""}
			`.trim()
			if (!queries[sql]) {
				queries[sql] = db.query(sql)
			}
			return queries[sql].all(vars) ?? []
		},

		insert: (table, data) => {
			if (!table || !data) {
				throw new Error("Cannot INSERT into database without table / data")
			}
			const keys = Object.keys(data)
			const vars = {}
			const sql = `
INSERT INTO ${table} (${keys.join(", ")})
${values(data, vars)}
			`.trim()
			if (!queries[sql]) {
				queries[sql] = db.query(sql)
			}
			queries[sql].run(vars)
		},

		update: (table, data, cond) => {
			if (!table || !data || !where) {
				throw new Error("Cannot UPDATE database without table / data / where")
			}
			const vars = {}
			const keys = Object.keys(data)
			const sql = `
UPDATE ${table}
${set(data, vars)}
${where(cond, vars)}
			`.trim()
			if (!queries[sql]) {
				queries[sql] = db.query(sql)
			}
			queries[sql].run(vars)
		},

		delete: (table, cond) => {
			if (!table || !cond) {
				throw new Error("Cannot DELETE from database without table / where")
			}
			const vars = {}
			const sql = `
DELETE FROM ${table}
${where(cond, vars)}
			`.trim()
			if (!queries[sql]) {
				queries[sql] = db.query(sql)
			}
			queries[sql].run(vars)
		},

	}

}
