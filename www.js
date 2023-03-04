// helpers for the world wide web with Bun

function createServer() {
	const handlers = []
	let handleError = () => {
		return new Response("Internal server error", {
			status: 500,
		})
	}
	let handleNotFound = () => {
		return new Response("404", {
			status: 404,
		})
	}
	const handleMatch = (req, pat, handler) => {
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

	function handle(handler) {
		handlers.push(handler)
	}

	function fetch(req) {
		for (const handle of handlers) {
			try {
				const res = handle(req)
				if (res) return res
			} catch (e) {
				console.log(e)
				return handleError(req, e)
			}
		}
		return handleNotFound(req)
	}

	return {
		handle: handle,
		error: (action) => handleError = action,
		notFound: (action) => handleNotFound = action,
		files: (route, root) => {
			handle((req) => {
				const url = new URL(req.url)
				route = route.replace(/\/*$/, "")
				if (!url.pathname.startsWith(route)) return
				const path = "./" + root + url.pathname.replace(new RegExp(`^${route}`), "")
				const file = Bun.file(path)
				if (file.size === 0) return
				return new Response(file.stream())
			})
		},
		match: (pat, cb) => {
			handle((req) => handleMatch(req, pat, handler))
		},
		get: genMethodHandler("GET"),
		post: genMethodHandler("POST"),
		put: genMethodHandler("PUT"),
		del: genMethodHandler("DEL"),
		start: (port, hostname) => {
			Bun.serve({
				port: port,
				hostname: hostname,
				fetch: fetch,
			})
		},
		fetch: fetch,
	}
}

function matchUrl(pat, url) {

	pat = pat.replace(/\/$/, "")
	url = url.replace(/\/$/, "")

	if (pat === url) {
		return {}
	}

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

function html(content, props) {
	return new Response(content, {
		headers: {
			"Content-Type": "text/html; charset=utf-8",
		},
	})
}

const nl = process.env.NODE_ENV === "development" ? "\n" : ""

// html builder
function tag(tagname, attrs, children) {

	let html = `<${tagname}`

	for (const k in attrs) {
		let v = attrs[k]
		switch (typeof(v)) {
			case "boolean":
				if (v === true) {
					html += ` ${k}`
				}
				break
			case "string":
				if (typeof(v) === "string") {
					v = `"${v}"`
				}
			case "number":
				html += ` ${k}=${v}`
				break
		}
	}

	html += ">"

	if (typeof(children) === "string" || typeof(children) === "number") {
		html += children
	} else if (Array.isArray(children)) {
		for (const child of children) {
			if (!child) {
				continue
			}
			if (Array.isArray(child)) {
				html += tag("div", {}, child)
			} else {
				html += child
			}
		}
	}

	if (children !== undefined && children !== null) {
		html += `</${tagname}>` + nl
	}

	return html

}

const camelToKababCase = (str) =>
	str.replace(/[A-Z]/g, (c) => `-${c.toLowerCase()}`)

// TODO: @font-face
// sass-like css preprocessor
function style(list) {

	let text = ""

	function handleSheet(s) {
		let t = "{" + nl
		for (const k in s) {
			t += camelToKababCase(k) + ":" + s[k] + ";" + nl
		}
		t += "}" + nl
		return t
	}

	function handleSheetEx(sel, sheet) {
		let t = sel + " {" + nl
		let post = ""
		for (const key in sheet) {
			const val = sheet[key]
			// media
			if (key === "@media") {
				for (const cond in val) {
					post += "@media " + cond + "{" + nl + sel + handleSheet(val[cond]) + "}" + nl
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
				t += camelToKababCase(key) + ":" + val + ";" + nl
			}
		}
		t += "}" + nl + post
		return t
	}

	for (const sel in list) {
		const sheet = list[sel]
		if (sel === "@keyframes") {
			for (const name in sheet) {
				const map = sheet[name]
				text += "@keyframes " + name + "{" + nl
				for (const time in map) {
					text += time + handleSheet(map[time])
				}
				text += "}" + nl
			}
		} else {
			text += handleSheetEx(sel, sheet)
		}
	}

	return text

}

function escapeHTML(unsafe) {
	return unsafe
		.replace(/&/g, "&amp")
		.replace(/</g, "&lt")
		.replace(/>/g, "&gt")
		.replace(/"/g, "&quot")
		.replace(/'/g, "&#039")
}

const csslib = {
	".vstack": {
		"display": "flex",
		"flex-direction": "column",
	},
	".rvstack": {
		"display": "flex",
		"flex-direction": "column-reverse",
	},
	".hstack": {
		"display": "flex",
		"flex-direction": "row",
	},
	".rhstack": {
		"display": "flex",
		"flex-direction": "row-reverse",
	},
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
	".text-center": { "text-align": "center" },
	".text-left": { "text-align": "left" },
	".text-right": { "text-align": "right" },
	".text-center": { "text-align": "center" },
	".wrap": { "flex-wrap": "wrap" },
	".rwrap": { "flex-wrap": "wrap-reverse" },
	".nowrap": { "flex-wrap": "no-wrap" },
}

const spacings = [ 4, 8, 12, 16, 24, 32, 48, 64, 128 ]

for (const spacing of spacings) {
	csslib[`.g${spacing}`] = { "gap": `${spacing}px` }
	csslib[`.p${spacing}`] = { "padding": `${spacing}px` }
	csslib[`.px${spacing}`] = { "padding-x": `${spacing}px` }
	csslib[`.py${spacing}`] = { "padding-y": `${spacing}px` }
	csslib[`.m${spacing}`] = { "margin": `${spacing}px` }
	csslib[`.mx${spacing}`] = { "margin-x": `${spacing}px` }
	csslib[`.my${spacing}`] = { "margin-y": `${spacing}px` }
	csslib[`.f${spacing}`] = { "font-size": `${spacing}px` }
}

export {
	tag,
	style,
	createServer,
	escapeHTML,
	csslib,
	html,
}
