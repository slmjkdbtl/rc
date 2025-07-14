// cli helper

import * as path from "path"

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
	args?: Arg[],
	opts?: Opt[],
	help?: string,
	action: (args: string[], opts: OptMap) => void | Promise<void>,
}

type Desc = {
	name?: string,
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

function fmtArgs(args: Arg[] = []) {
	return args
		.map((a) => a.required === false ? `[${a.name}]` : `<${a.name}>`)
		.join(" ")
}

export async function cli(desc: Desc) {

	const argv = process.argv.slice(2)
	const cmd = (desc.cmds || []).find((c) => c.name && c.name === argv[0])
	const hasCmd = desc.cmds?.length > 0

	const binName = desc.name || path.basename(process.argv[1])

	function help() {

		let msg = ""

		msg += desc.desc
		msg += "\n\n"
		msg += "USAGE"
		msg += "\n"
		msg += "\n"
		msg += `  $ ${binName} ${hasCmd ? "<cmd>" : ""}`
		msg += "\n"

		if (hasCmd) {

			msg += "\n"
			msg += "COMMANDS"
			msg += "\n"
			msg += "\n"

			let maxNameLen = Math.max(...desc.cmds.map((c) => c.name.length))
			let maxArgsLen = Math.max(...desc.cmds.map((c) => fmtArgs(c.args).length))

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

			const fmtOpt = (opt: Opt) =>
				`${opt.short ? `-${opt.short}, ` : "    "}--${opt.name}`
			const maxOptLen = Math.max(...desc.opts.map((o) => fmtOpt(o).length))

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

		const requiredArgs = (cmd.args ?? []).filter((a) => a.required !== false)

		if (args.length < requiredArgs.length) {

			console.error("incorrect number of arguments")

			let msg = ""

			msg += cmd.desc
			msg += "\n\n"
			msg += "USAGE"
			msg += "\n"
			msg += `  $ ${binName} ${cmd.name} ${fmtArgs(cmd.args)}`

			if (cmd.opts?.length > 0) {
				msg += " [opts]"
			}

			msg += "\n"

			// TODO: show desc for each arg and opt

			console.log(msg)

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
