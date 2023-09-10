// Parse apple music library export file into a list of album names

// TODO: playlists

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

const musicXML = await fs.readFile("Library.xml", "utf8")
const doc = transform(htmlparser2.parseDocument(musicXML))
const albumSet = new Set()
// TODO: better way to find these?
const tracksDoc = doc.children[2].children[0].children[11].children[5]
const playlistsDoc = doc.children[2].children[0].children[11].children[7]

function getVal(dict, key) {
	for (let i = 0; i < dict.children.length; i++) {
		const item = dict.children[i]
		if (item.name === "key" && item.children[0].data === key) {
			return dict.children[i + 1].children[0].data
		}
	}
}

for (const d of tracksDoc.children) {
	if (d.name !== "dict") continue
	const artist = getVal(d, "Artist")
	const album = getVal(d, "Album")
	if (album && artist) {
		albumSet.add(`${artist} - ${album}`)
	}
}

fs.writeFile("albums.txt", Array.from(albumSet).sort().join("\n"))
