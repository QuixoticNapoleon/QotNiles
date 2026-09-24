import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.modules

PanelWindow {
	id: root
	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 25
	color: "transparent"

	// Center: workspaces
	Workspaces {
		id: workspacesRow
		anchors.centerIn: parent
	}

	// Left: distro icon -> network -> window title
	RowLayout {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		spacing: -1

		DistroIcon {}
		Separator { fillColor: Theme.bg2; backColor: Theme.bg1 }
		Network {}
		Separator { fillColor: Theme.bg1; backColor: Theme.bg2 }
		WindowTitle {
			id: windowTitle
			maxChars: Math.max(5, Math.floor((workspacesRow.x - windowTitle.x - 80) / 8))
		}
		Separator { fillColor: Theme.bg2 }
	}

	// Right: tray -> volume -> ram -> cpu -> date -> time
	RowLayout {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		spacing: -1

		Separator { pointLeft: true; fillColor: Theme.bg2 }
		Tray {}
		Separator { pointLeft: true; fillColor: Theme.bg1; backColor: Theme.bg2 }
		Volume {}
		Separator { pointLeft: true; fillColor: Theme.bg2; backColor: Theme.bg1 }
		Ram {}
		Separator { pointLeft: true; fillColor: Theme.bg1; backColor: Theme.bg2 }
		Cpu {}
		Separator { pointLeft: true; fillColor: Theme.bg2; backColor: Theme.bg1 }
		DateWidget {}
		Separator { pointLeft: true; fillColor: Theme.bg1; backColor: Theme.bg2 }
		TimeWidget {}
	}
}
