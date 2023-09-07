// TODO: artist name

import fs from "fs/promises"
import * as htmlparser2 from "htmlparser2"

function transform(node) {
	if (node.type === "text" && node.data.startsWith("\n")) return
	return {
		name: node.name,
		type: node.type,
		data: node.data,
		attribs: node.attribs,
		children: node.children?.map(transform).filter((c) => c),
	}
}

const musicXML = await fs.readFile("music.xml", "utf8")
const doc = transform(htmlparser2.parseDocument(musicXML))
const albumSet = new Set()
// TODO: better way to find these?
const tracksDoc = doc.children[2].children[0].children[11].children[5]
const playlistsDoc = doc.children[2].children[0].children[11].children[7]

for (const d of tracksDoc.children) {
	if (d.name !== "dict") continue
	let grab = false
	for (const a of d.children) {
		if (grab) {
			grab = false
			albumSet.add(a.children[0].data)
			continue
		}
		if (a.name === "key" && a.children[0].data === "Album") {
			grab = true
		}
	}
}

fs.writeFile("albums.txt", Array.from(albumSet).join("\n"))
