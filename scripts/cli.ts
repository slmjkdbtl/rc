// cli helper

type Opt = {
	name: string,
	desc: string,
	short?: string,
	hasValue?: boolean,
	required?: boolean,
}

type Arg = {
	name: string,
	desc: string,
	required?: boolean,
}

type OptMap = Record<string, string | boolean>

type Cmd = {
	name: string,
	desc: string,
	args?: string[],
	opts?: Opt[],
	help?: string,
	action: (args: string[], opts: OptMap) => void | Promise<void>,
}

type Desc = {
	name: string,
	desc: string,
	opts?: Opt[],
	cmds: Cmd[],
	action?: (args: string[], opts: OptMap) => void | Promise<void>,
}

function isAsync(fn: Function): fn is (...args: any[]) => Promise<any> {
	return fn.constructor.name === "AsyncFunction"
}

async function runMaybeAsync(fn, ...args) {
	return isAsync(fn) ? await fn(...args) : fn(...args)
}

function toOptMap(opts: Opt[]): Record<string, Opt> {
	const map = {}
	for (const opt of opts) {
		map[opt.name] = opt
		if (opt.short) {
			map[opt.short] = opt
		}
	}
	return map
}

// TODO support -abc style short flag combo
function parseArgv(argv: string[], optDesc: Opt[]) {
	const args = []
	const opts = {}
	const optMap = toOptMap(optDesc)
	for (let i = 0; i < argv.length; i++) {
		const arg = argv[i]
		if (arg.startsWith("-")) {
			const name = arg.slice(arg.startsWith("--") ? 2 : 1)
			const opt = optMap[name]
			if (!opt) {
				throw new Error(`unknown option: ${arg}`)
			}
			if (opt.hasValue) {
				const val = argv[i + 1]
				if (!val || val.startsWith("-")) {
					throw new Error(`option requires value: ${arg}`)
				}
				opts[opt.name] = val
				i += 1
			} else {
				opts[opt.name] = true
			}
		} else {
			args.push(arg)
		}
	}
	for (const opt of optDesc) {
		if (opt.required && !optMap[opt.name]) {
			throw new Error(`required option: ${opt.name}`)
		}
	}
	return { args, opts }
}

export async function cli(desc: Desc) {

	const argv = process.argv.slice(2)
	const cmd = (desc.cmds || []).find((c) => c.name && c.name === argv[0])
	const hasCmd = desc.cmds && desc.cmds.length > 0

	function help() {

		let msg = ""

		msg += desc.desc
		msg += "\n\n"
		msg += "USAGE"
		msg += "\n"
		msg += "\n"
		msg += `  $ ${desc.name} ${hasCmd ? "<cmd>" : ""}`
		msg += "\n"

		if (hasCmd) {

			msg += "\n"
			msg += "COMMANDS"
			msg += "\n"
			msg += "\n"

			let maxNameLen = 0
			let maxArgsLen = 0
			const fmtArgs = (args) => (args || []).map((a) => `[${a}]`).join(" ")

			for (const cmd of desc.cmds) {
				maxNameLen = Math.max(maxNameLen, cmd.name.length)
				maxArgsLen = Math.max(maxArgsLen, fmtArgs(cmd.args).length)
			}

			for (const cmd of desc.cmds) {
				msg += "  "
				msg += cmd.name.padEnd(maxNameLen)
				msg += " "
				msg += fmtArgs(cmd.args).padEnd(maxArgsLen)
				msg += "   "
				msg += cmd.desc
				msg += "\n"
			}

		}

		if (desc.opts && desc.opts.length > 0) {

			msg += "\n"
			msg += "OPTIONS"
			msg += "\n"
			msg += "\n"

			let maxOptLen = 0
			const fmtOpt = (opt: Opt) =>
				`${opt.short ? `-${opt.short}, ` : "    "}--${opt.name}`

			for (const opt of desc.opts) {
				maxOptLen = Math.max(maxOptLen, fmtOpt(opt).length)
			}

			for (const opt of desc.opts) {
				msg += "  "
				msg += fmtOpt(opt).padEnd(maxOptLen)
				msg += "   "
				msg += opt.desc
				msg += "\n"
			}

		}

		console.log(msg.trim())

	}

	if (cmd) {

		const { args, opts } = parseArgv(
			argv.slice(1),
			[ ...(desc.opts || []), ...(cmd.opts || [])
		])

		const requiredArgs = (cmd.args ?? []).filter((a) => !a.endsWith("?"))

		if (args.length < requiredArgs.length) {
			console.error("incorrect number of arguments")
			console.log()
			// TODO: nicer cmd help msg with opts
			console.log(`  $ ${desc.name} ${cmd.name} ${cmd.args.map((a) => `<${a}>`).join(" ")}   ${cmd.desc}`)
			return
		}

		await runMaybeAsync(cmd.action, args, opts)

	} else {

		if (desc.action) {
			const { args, opts } = parseArgv(argv, desc.opts || [])
			await runMaybeAsync(desc.action, args, opts)
		} else {
			help()
			return
		}

	}

}
