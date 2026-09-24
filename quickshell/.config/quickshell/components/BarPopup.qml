import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs

// Shared popup for bar modules: anchored below the bar, focus-grabbed
// (click outside to dismiss), with fade/scale animations.
PopupWindow {
	id: popup

	required property Item anchorItem  // bar module that owns this popup
	property real xOffset: 0
	property int contentMargins: 12
	property bool showing: false
	default property alias content: slot.data

	anchor.window: anchorItem.QsWindow.window
	anchor.rect.y: anchor.window?.height ?? 0
	visible: false
	color: "transparent"

	function toggle() {
		if (visible && showing)
			close()
		else
			open()
	}

	function open() {
		anchor.rect.x = anchorItem.mapToItem(null, 0, 0).x + xOffset
		visible = true
		showing = true
		grab.active = true
	}

	function close() {
		grab.active = false
		showing = false
		hideTimer.start()
	}

	HyprlandFocusGrab {
		id: grab
		windows: [popup]
		onCleared: popup.close()
	}

	Timer {
		id: hideTimer
		interval: 160
		onTriggered: popup.visible = false
	}

	Rectangle {
		anchors.fill: parent
		color: Theme.popupBg
		border.color: Theme.bright
		border.width: 1

		opacity: popup.showing ? 1.0 : 0.0
		scale: popup.showing ? 1.0 : 0.95
		transformOrigin: Item.Top

		Behavior on opacity {
			NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
		}
		Behavior on scale {
			NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
		}

		Item {
			id: slot
			anchors.fill: parent
			anchors.margins: popup.contentMargins
		}
	}
}
