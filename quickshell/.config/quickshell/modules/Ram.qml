import QtQuick
import qs
import qs.components

// RAM usage: used/total in GB, refreshed every 2s.
BarBlock {
	color: Theme.bg2

	Text {
		text: "\uefc5"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		id: ramText
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}

	Poller {
		command: ["sh", "-c", "free -b | awk '/^Mem:/ {printf \"%.1f/%.1fGB\", $3/1073741824, $2/1073741824}'"]
		interval: 2000
		onOutput: text => ramText.text = text
	}
}
