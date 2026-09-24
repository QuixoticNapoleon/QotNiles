import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs
import qs.components

// System tray icons; left click activates, right click opens the menu.
BarBlock {
	color: Theme.bg2
	padding: 12
	spacing: 6

	Text {
		text: "\uf013"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Repeater {
		model: SystemTray.items

		Image {
			id: trayIcon
			required property SystemTrayItem modelData
			source: modelData.icon
			sourceSize.width: 16
			sourceSize.height: 16
			width: 16
			height: 16

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.LeftButton | Qt.RightButton
				onClicked: mouse => {
					if (mouse.button === Qt.LeftButton)
						trayIcon.modelData.activate()
					else
						trayIcon.modelData.display(trayIcon.QsWindow.window, mouse.x, mouse.y)
				}
			}
		}
	}
}
