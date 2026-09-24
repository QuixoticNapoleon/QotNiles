import QtQuick
import Quickshell.Hyprland
import qs

Item {
	id: button

	required property int index
	required property string modelData
	readonly property int wsId: index + 1
	readonly property string wsStatus: {
		if ((Hyprland.focusedWorkspace?.id ?? -1) === wsId)
			return "focused"
		const ws = Hyprland.workspaces.values
		for (let i = 0; i < ws.length; i++)
			if (ws[i].id === wsId)
				return "occupied"
		return "empty"
	}

	width: wsLabel.implicitWidth
	height: wsLabel.implicitHeight

	Text {
		id: wsLabel
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: button.wsId >= 11 ? 4 : 0

		text: button.modelData
		color: button.wsStatus === "focused" ? Theme.accent
			 : button.wsStatus === "occupied" ? Theme.bright : Theme.dim
		font.family: button.wsId >= 11 ? Theme.fontRunes : Theme.fontCjk
		font.pixelSize: button.wsId >= 11 ? 17 : 13
		font.bold: button.wsStatus === "focused"
	}

	MouseArea {
		anchors.fill: parent
		anchors.margins: -4  // hit target slightly larger than the glyph
		// This Hyprland build routes dispatches through its Lua config:
		// the classic "workspace N" string is a Lua syntax error there.
		onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + button.wsId + " })")
	}
}
