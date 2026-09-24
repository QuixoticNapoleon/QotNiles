import QtQuick
import Quickshell.Hyprland
import qs
import qs.components

// Active window title, truncated to fit the space left of the workspaces.
BarBlock {
	id: windowModule
	color: Theme.bg2

	property int maxChars: 60

	Text {
		text: "\uf2d0"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		readonly property string fullTitle: Hyprland.activeToplevel?.title ?? ""
		text: fullTitle.length > windowModule.maxChars
			? fullTitle.substring(0, windowModule.maxChars - 3) + "..."
			: fullTitle
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}
}
