// ╔══════════════════════════════════════════════════════════════════╗
// ║                                                                  ║
// ║   ██████╗ ██╗   ██╗██╗██╗  ██╗ ██████╗ ████████╗██╗ ██████╗    ║
// ║  ██╔═══██╗██║   ██║██║╚██╗██╔╝██╔═══██╗╚══██╔══╝██║██╔════╝    ║
// ║  ██║   ██║██║   ██║██║ ╚███╔╝ ██║   ██║   ██║   ██║██║         ║
// ║  ██║▄▄ ██║██║   ██║██║ ██╔██╗ ██║   ██║   ██║   ██║██║         ║
// ║  ╚██████╔╝╚██████╔╝██║██╔╝ ██╗╚██████╔╝   ██║   ██║╚██████╗    ║
// ║   ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝   ║
// ║                                                                  ║
// ║   ███████╗██╗  ██╗███████╗██╗     ██╗                           ║
// ║   ██╔════╝██║  ██║██╔════╝██║     ██║                           ║
// ║   ███████╗███████║█████╗  ██║     ██║                           ║
// ║   ╚════██║██╔══██║██╔══╝  ██║     ██║                           ║
// ║   ███████║██║  ██║███████╗███████╗███████╗                      ║
// ║   ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝                     ║
// ║                                                                  ║
// ║   A Quickshell status bar for Hyprland                          ║
// ╚══════════════════════════════════════════════════════════════════╝

// ╔══════════════════════════╗
// ║  📦  IMPORTS             ║
// ╚══════════════════════════╝
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire

PanelWindow {
	id: root
	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 25
	color: "transparent"

	// ╔══════════════════════════╗
	// ║  🎨  THEME               ║
	// ╚══════════════════════════╝
	property color bg1: "#003636"
	property color bg2: "#004344"
	property color fg: "#6ae8eb"

	// ╔══════════════════════════╗
	// ║  🗂️  WORKSPACE STATE     ║
	// ╚══════════════════════════╝
	property var wsValues: Hyprland.workspaces.values
	property int focusedId: Hyprland.focusedWorkspace?.id ?? -1

	function wsState(id) {
		if (focusedId === id) return "focused"
		for (var i = 0; i < wsValues.length; i++) {
			if (wsValues[i].id === id) return "occupied"
		}
		return "empty"
	}

	// ╔══════════════════════════════════════════════════════════════╗
	// ║  🏢  CENTER: WORKSPACES                                      ║
	// ╚══════════════════════════════════════════════════════════════╝
	RowLayout {
		id: workspacesRow
		anchors.centerIn: parent
		spacing: 12

		Repeater {
			model: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "ᚨ", "ᚠ"]

			Item {
				required property int index
				required property string modelData
				property int wsId: index + 1
				property string state: wsState(wsId)

				width: wsLabel.implicitWidth
				height: wsLabel.implicitHeight

				Text {
					id: wsLabel
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter
					anchors.verticalCenterOffset: parent.wsId >= 11 ? 4 : 0

					text: parent.modelData
					color: parent.state === "focused" ? "#FFC500" : parent.state === "occupied" ? "#8affff" : "#4d7f7f"
					font.family: parent.wsId >= 11 ? "Junicode" : "Noto Sans CJK SC"
					font.pixelSize: parent.wsId >= 11 ? 17 : 13
					font.bold: parent.state === "focused"
				}

				MouseArea {
					anchors.fill: parent
					onClicked: Hyprland.dispatch("workspace " + wsId)
				}
			}
		}
	}

	// ╔══════════════════════════════════════════════════════════════╗
	// ║  ◀️  LEFT MODULES                                             ║
	// ║     Distro Icon → Network → Window Title                     ║
	// ╚══════════════════════════════════════════════════════════════╝
	RowLayout {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		spacing: -1

		// ── 🐧 Distro Icon ────────────────────────────────────────
		Rectangle {
			id: distroModule
			color: root.bg2
			Layout.fillHeight: true
			implicitWidth: distroIcon.implicitWidth + 16

			Text {
				id: distroIcon
				anchors.centerIn: parent
				text: "󰣇"
				color: root.fg
				font.family: "Symbols Nerd Font"
				font.pixelSize: 14
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					dropdownToggleProc.running = true
				}
			}

			Process {
				id: dropdownToggleProc
				command: ["sh", "-c", "if hyprctl clients -j | jq -e '.[] | select(.class==\"quickshell-dropdown\")' > /dev/null 2>&1; then pkill -f 'kitty --class quickshell-dropdown'; else kitty --class quickshell-dropdown --override font_size=8 -e sh -c 'fastfetch; echo; printf \"\\e[1;33mI USE ARCH BTW!!!!\\e[0m\\n\"; echo; exec $SHELL' & fi"]
			}
		}

		// Powerline separator: bg2 -> bg1
		Text {
			text: ""
			color: root.bg2
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg1
				z: -1
			}
		}

		// ── 📶 Network (WiFi / Ethernet) ──────────────────────────
		Rectangle {
			color: root.bg1
			Layout.fillHeight: true
			implicitWidth: wlanRow.implicitWidth + 16

			RowLayout {
				id: wlanRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: ""
					id: wlanIcon
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: wlanIface
					text: "wlo1"
					color: "#FFC500"
					font.family: "Source Code Pro"
					font.pixelSize: 14
					visible: text !== ""
				}

				Text {
					id: wlanSsid
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
					font.bold: true
					text: "..."
				}

				Text {
					id: wlanIp
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
					visible: text !== ""
				}
			}

			Timer {
				interval: 5000
				running: true
				repeat: true
				triggeredOnStart: true
				onTriggered: wlanProc.running = true
			}

			Process {
				id: wlanProc
				command: ["sh", "-c", "WIFACE=$(ip -o link show up | grep -oP 'wl[^:]+' | head -1); EIFACE=$(ip -o link show up | grep -oP 'en[^:]+' | head -1); if [ -n \"$WIFACE\" ]; then SSID=$(iwgetid -r 2>/dev/null); if [ -n \"$SSID\" ]; then IP=$(ip -4 -o addr show $WIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"wifi|$WIFACE|$SSID|$IP\"; else echo disconnected; fi; elif [ -n \"$EIFACE\" ]; then IP=$(ip -4 -o addr show $EIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"eth|$EIFACE|$IP\"; else echo disconnected; fi"]
				stdout: StdioCollector {
					onStreamFinished: {
						var parts = this.text.trim().split("|")
						var type = parts[0]
						if (type === "wifi") {
							wlanIcon.text = ""
							wlanIface.text = parts[1] || ""
							wlanSsid.text = parts[2] || ""
							wlanSsid.color = root.fg
							wlanSsid.font.bold = true
							wlanIp.text = parts[3] || ""
						} else if (type === "eth") {
							wlanIcon.text = ""
							wlanIface.text = parts[1] || ""
							wlanSsid.text = ""
							wlanIp.text = parts[2] || ""
						} else {
							wlanIcon.text = "󱚼"
							wlanIface.text = ""
							wlanSsid.text = "DISCONNECTED"
							wlanSsid.color = "#707880"
							wlanSsid.font.bold = false
							wlanIp.text = ""
						}
					}
				}
			}
		}

		// Powerline separator: bg1 -> bg2
		Text {
			text: ""
			color: root.bg1
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg2
				z: -1
			}
		}

		// ── 🪟 Window Title ───────────────────────────────────────
		Rectangle {
			id: windowModule
			color: root.bg2
			Layout.fillHeight: true
			implicitWidth: windowRow.implicitWidth + 16

			RowLayout {
				id: windowRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: windowTitle
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
					property string fullTitle: Hyprland.activeToplevel?.title ?? ""
					property int maxChars: Math.max(5, Math.floor((workspacesRow.x - windowModule.x - 80) / 8))
					text: fullTitle.length > maxChars ? fullTitle.substring(0, maxChars - 3) + "..." : fullTitle
				}
			}
		}

		// Powerline separator: bg2 -> transparent
		Text {
			text: ""
			color: root.bg2
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter
		}
	}

	// ╔══════════════════════════════════════════════════════════════╗
	// ║  ▶️  RIGHT MODULES                                            ║
	// ║     Tray → Volume → RAM → CPU → Date → Time                  ║
	// ╚══════════════════════════════════════════════════════════════╝
	RowLayout {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		spacing: -1

		// Powerline separator: transparent -> bg2
		Text {
			text: ""
			color: root.bg2
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter
		}

		// ── 📌 System Tray ────────────────────────────────────────
		Rectangle {
			color: root.bg2
			Layout.fillHeight: true
			implicitWidth: trayRow.implicitWidth + 12
			// visible: SystemTray.items.values.length > 0

			RowLayout {
				id: trayRow
				anchors.centerIn: parent
				spacing: 6

				Text {
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Repeater {
					model: SystemTray.items

					Image {
						required property SystemTrayItem modelData
						source: modelData.icon
						sourceSize.width: 16
						sourceSize.height: 16
						width: 16
						height: 16

						MouseArea {
							anchors.fill: parent
							acceptedButtons: Qt.LeftButton | Qt.RightButton
							onClicked: function(mouse) {
								if (mouse.button === Qt.LeftButton) {
									modelData.activate()
								} else {
									modelData.display(root, mouse.x, mouse.y)
								}
							}
						}
					}
				}
			}
		}

		// Powerline separator: bg2 -> bg1
		Text {
			text: ""
			color: root.bg1
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg2
				z: -1
			}
		}

		// ── 🔊 Volume ─────────────────────────────────────────────
		Rectangle {
			id: volModule
			color: root.bg1
			Layout.fillHeight: true
			implicitWidth: volRow.implicitWidth + 16

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (!volPopup.visible) {
						var pos = volModule.mapToItem(null, 0, 0)
						volPopup.popupX = pos.x - 40
						volPopup.visible = true
						volPopup.showing = true
						volGrab.active = true
					} else {
						volGrab.active = false
						volPopup.showing = false
						volCloseTimer.start()
					}
				}
			}

			Timer {
				id: volCloseTimer
				interval: 160
				onTriggered: volPopup.visible = false
			}

			PopupWindow {
				id: volPopup
				anchor.window: root
				property real popupX: 0
				anchor.rect.x: popupX
				anchor.rect.y: root.height
				visible: false
				width: 200
				height: 80
				color: "transparent"

				property bool showing: false
				property var sink: Pipewire.defaultAudioSink
				property real currentVol: sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0
				property bool isMuted: sink && sink.audio ? sink.audio.muted : false

				HyprlandFocusGrab {
					id: volGrab
					windows: [volPopup]
					onCleared: {
						volPopup.showing = false
						volCloseTimer.start()
					}
				}

				Rectangle {
					anchors.fill: parent
					color: Qt.rgba(0, 0.212, 0.212, 1)
					border.color: "#8affff"
					border.width: 1

					opacity: volPopup.showing ? 1.0 : 0.0
					scale: volPopup.showing ? 1.0 : 0.95
					transformOrigin: Item.Top

					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
					Behavior on scale {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
				}

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 12
					spacing: 0

					opacity: volPopup.showing ? 1.0 : 0.0
					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}

					RowLayout {
						Layout.alignment: Qt.AlignHCenter
						spacing: 6

						Text {
							id: volPopupIcon
							color: root.fg
							font.family: "Symbols Nerd Font"
							font.pixelSize: 18
						text: volSlider.value === 0 ? "" : volSlider.value <= 50 ? "" : ""
						}

						Text {
							id: volSliderLabel
							color: "#FFC500"
							font.family: "Source Code Pro"
							font.pixelSize: 17
							font.bold: true
							text: Math.round(volSlider.value) + "%"
						}
					}

					Item {
						id: volSlider
						Layout.fillWidth: true
						height: 20

						property real value: volPopup.currentVol
						property bool pressed: sliderMouse.pressed

						Rectangle {
							anchors.verticalCenter: parent.verticalCenter
							width: parent.width
							height: 4
							radius: 2
							color: "#4d7f7f"

							Rectangle {
								width: Math.max(0, Math.min(1, volSlider.value / 300)) * parent.width
								height: parent.height
								color: volSlider.value > 100 ? "#FFC500" : "#8affff"
								radius: 2
							}
						}

						Rectangle {
							x: Math.max(0, Math.min(1, volSlider.value / 300)) * (parent.width - width)
							anchors.verticalCenter: parent.verticalCenter
							width: 12
							height: 12
							radius: 6
							color: volSlider.value > 100 ? "#FFC500" : "#6ae8eb"
						}

						MouseArea {
							id: sliderMouse
							anchors.fill: parent
							onPressed: function(mouse) { updateVol(mouse) }
							onPositionChanged: function(mouse) { if (pressed) updateVol(mouse) }

							function updateVol(mouse) {
								var ratio = Math.max(0, Math.min(1, mouse.x / width))
								var vol = Math.round(ratio * 300)
								volSlider.value = vol
								if (volPopup.sink && volPopup.sink.audio)
									volPopup.sink.audio.volume = vol / 100
							}
						}
					}
				}

			}

			RowLayout {
				id: volRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					id: volIcon
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: volText
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
				}
			}

			property var sink: Pipewire.defaultAudioSink
			property real volPercent: sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0
			property bool isMuted: sink && sink.audio ? sink.audio.muted : false

			PwObjectTracker {
				objects: [ Pipewire.defaultAudioSink ]
			}

			Binding { target: volText; property: "text"; value: volModule.isMuted ? "MUTED" : volModule.volPercent + "%" }
			Binding { target: volIcon; property: "text"; value: volModule.isMuted ? "󰖁" : "" }
		}

		// Powerline separator: bg1 -> bg2
		Text {
			text: ""
			color: root.bg2
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg1
				z: -1
			}
		}
		// ── 🧠 RAM ────────────────────────────────────────────────
		Rectangle {
			color: root.bg2
			Layout.fillHeight: true
			implicitWidth: ramRow.implicitWidth + 16

			property string ramOutput: ""

			RowLayout {
				id: ramRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: ramText
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
				}
			}

			Timer {
				interval: 2000
				running: true
				repeat: true
				triggeredOnStart: true
				onTriggered: ramProc.running = true
			}

			Process {
				id: ramProc
				command: ["sh", "-c", "free -b | awk '/^Mem:/ {printf \"%.1f/%.1fGB\", $3/1073741824, $2/1073741824}'"]
				stdout: StdioCollector {
					onStreamFinished: ramText.text = this.text.trim()
				}
			}
		}

		// Powerline separator: bg2 -> bg1
		Text {
			text: ""
			color: root.bg1
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg2
				z: -1
			}
		}

		// ── 🖥️ CPU ────────────────────────────────────────────────
		Rectangle {
			color: root.bg1
			Layout.fillHeight: true
			implicitWidth: cpuRow.implicitWidth + 16

			RowLayout {
				id: cpuRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: cpuText
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14
				}
			}

			Timer {
				interval: 2000
				running: true
				repeat: true
				triggeredOnStart: true
				onTriggered: cpuProc.running = true
			}

			Process {
				id: cpuProc
				command: ["sh", "-c", "awk '/^cpu / {u=$2+$4; t=$2+$3+$4+$5+$6+$7+$8; printf \"%.0f%%\", u*100/t}' /proc/stat"]
				stdout: StdioCollector {
					onStreamFinished: cpuText.text = this.text.trim()
				}
			}
		}

		// Powerline separator: bg1 -> bg2
		Text {
			text: ""
			color: root.bg2
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg1
				z: -1
			}
		}

		// ── 📅 Date (click for calendar popup) ────────────────────
		Rectangle {
			id: dateModule
			color: root.bg2
			Layout.fillHeight: true
			implicitWidth: dateRow.implicitWidth + 16

			property int calMonth: new Date().getMonth()
			property int calYear: new Date().getFullYear()

			MouseArea {
				anchors.fill: parent
				onClicked: {
					var now = new Date()
					dateModule.calMonth = now.getMonth()
					dateModule.calYear = now.getFullYear()
					var pos = dateModule.mapToItem(null, 0, 0)
					calendarPopup.popupX = pos.x - 40
					if (!calendarPopup.visible) {
						calendarPopup.visible = true
						calendarPopup.showing = true
					} else {
						calendarPopup.showing = false
						calCloseTimer.start()
					}
				}
			}

			Timer {
				id: calCloseTimer
				interval: 160
				onTriggered: calendarPopup.visible = false
			}

			PopupWindow {
				id: calendarPopup
				anchor.window: root
				property real popupX: root.width - 400
				anchor.rect.x: popupX
				anchor.rect.y: root.height
				visible: false
				width: 282
				height: 322
				color: "transparent"

				property bool showing: false

				Rectangle {
					id: calendarBg
					anchors.fill: parent
					color: Qt.rgba(0, 0.212, 0.212, 1)
					border.color: "#8affff"
					border.width: 1
					radius: 0
					clip: true

					opacity: calendarPopup.showing ? 1.0 : 0.0
					scale: calendarPopup.showing ? 1.0 : 0.95
					transformOrigin: Item.Top

					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
					Behavior on scale {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
				}

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 11
					spacing: 8

					opacity: calendarPopup.showing ? 1.0 : 0.0
					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}

					// Month/Year header with navigation
					RowLayout {
						Layout.fillWidth: true

						Text {
							text: "<"
							color: root.fg
							font.family: "Source Code Pro"
							font.pixelSize: 16
							font.bold: true
							MouseArea {
								anchors.fill: parent
								onClicked: {
									if (dateModule.calMonth === 0) {
										dateModule.calMonth = 11
										dateModule.calYear--
									} else {
										dateModule.calMonth--
									}
								}
							}
						}

						Text {
							Layout.fillWidth: true
							horizontalAlignment: Text.AlignHCenter
							text: dateModule.calYear + "年" + String(dateModule.calMonth + 1).padStart(2, '0') + "月"
							color: "#FFC500"
							font.family: "Noto Sans CJK SC"
							font.pixelSize: 14
							font.bold: true
						}

						Text {
							text: ">"
							color: root.fg
							font.family: "Source Code Pro"
							font.pixelSize: 16
							font.bold: true
							MouseArea {
								anchors.fill: parent
								onClicked: {
									if (dateModule.calMonth === 11) {
										dateModule.calMonth = 0
										dateModule.calYear++
									} else {
										dateModule.calMonth++
									}
								}
							}
						}
					}

					// Day of week headers
					RowLayout {
						Layout.fillWidth: true
						spacing: 0

						Repeater {
							model: ["☉", "☽", "♂", "☿", "♃", "♀", "♄"]

							Text {
								required property string modelData
								Layout.fillWidth: true
								text: modelData
								color: "#FFC500"
								font.family: "Source Code Pro"
								font.pixelSize: 14
								font.bold: true
								horizontalAlignment: Text.AlignHCenter
							}
						}
					}

					// Calendar grid
					MonthGrid {
						Layout.fillWidth: true
						Layout.fillHeight: true
						month: dateModule.calMonth
						year: dateModule.calYear
						locale: Qt.locale("ja_JP")

						delegate: Text {
							required property var model
							property bool isToday: model.day === new Date().getDate() &&
												   model.month === new Date().getMonth() &&
												   model.year === new Date().getFullYear()
							property bool isCurrentMonth: model.month === dateModule.calMonth

							text: model.day
							color: isToday ? "#FFC500" : isCurrentMonth ? root.fg : "#4d7f7f"
							font.family: "Source Code Pro"
							font.pixelSize: 14
							font.bold: isToday
							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter
						}
					}
				}
			}

			RowLayout {
				id: dateRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: ""
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: dateText
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14

					property var daySymbols: ["☉", "☽", "♂", "☿", "♃", "♀", "♄"]

					Timer {
						interval: 1000
						running: true
						repeat: true
						triggeredOnStart: true
						onTriggered: {
							var now = new Date()
							var y = now.getFullYear()
							var m = String(now.getMonth() + 1).padStart(2, '0')
							var d = String(now.getDate()).padStart(2, '0')
							dateText.text = y + "年" + m + "月" + d + "日 (" + dateText.daySymbols[now.getDay()] + ")"
						}
					}
				}
			}
		}

		// Powerline separator: bg2 -> bg1
		Text {
			text: ""
			color: root.bg1
			font.family: "Inconsolata for Powerline"
			font.pixelSize: 25
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter

			Rectangle {
				anchors.fill: parent
				color: root.bg2
				z: -1
			}
		}

		// ── 🕐 Time (click for analog clock popup) ────────────────
		Rectangle {
			id: timeModule
			color: root.bg1
			Layout.fillHeight: true
			implicitWidth: timeRow.implicitWidth + 16

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (!clockPopup.visible) {
						var pos = timeModule.mapToItem(null, 0, 0)
						clockPopup.popupX = pos.x - 100
						clockPopup.visible = true
						clockPopup.showing = true
					} else {
						clockPopup.showing = false
						clockCloseTimer.start()
					}
				}
			}

			Timer {
				id: clockCloseTimer
				interval: 160
				onTriggered: clockPopup.visible = false
			}

			PopupWindow {
				id: clockPopup
				anchor.window: root
				property real popupX: root.width - 250
				anchor.rect.x: popupX
				anchor.rect.y: root.height
				visible: false
				width: 220
				height: 240
				color: "transparent"

				property bool showing: false

				Rectangle {
					anchors.fill: parent
					color: Qt.rgba(0, 0.212, 0.212, 1)
					border.color: "#8affff"
					border.width: 1

					opacity: clockPopup.showing ? 1.0 : 0.0
					scale: clockPopup.showing ? 1.0 : 0.95
					transformOrigin: Item.Top

					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
					Behavior on scale {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}
				}

				Canvas {
					id: clockCanvas
					anchors.fill: parent
					anchors.margins: 15

					opacity: clockPopup.showing ? 1.0 : 0.0
					Behavior on opacity {
						NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
					}

					property real hours: 0
					property real minutes: 0
					property real seconds: 0

					Timer {
						interval: 1000
						running: clockPopup.visible
						repeat: true
						triggeredOnStart: true
						onTriggered: {
							var now = new Date()
							clockCanvas.hours = now.getHours()
							clockCanvas.minutes = now.getMinutes()
							clockCanvas.seconds = now.getSeconds()
							clockCanvas.requestPaint()
						}
					}

					onPaint: {
						var ctx = getContext("2d")
						var size = Math.min(width, height)
						var cx = width / 2
						var cy = height / 2
						var r = size / 2 - 5

						ctx.clearRect(0, 0, width, height)

						// Clock face circle
						ctx.beginPath()
						ctx.arc(cx, cy, r, 0, 2 * Math.PI)
						ctx.strokeStyle = "#8affff"
						ctx.lineWidth = 1.5
						ctx.stroke()

						// Hour markers
						for (var i = 0; i < 12; i++) {
							var angle = (i * 30 - 90) * Math.PI / 180
							var inner = i % 3 === 0 ? r - 12 : r - 8
							var outer = r - 3
							ctx.beginPath()
							ctx.moveTo(cx + inner * Math.cos(angle), cy + inner * Math.sin(angle))
							ctx.lineTo(cx + outer * Math.cos(angle), cy + outer * Math.sin(angle))
							ctx.strokeStyle = i % 3 === 0 ? "#FFC500" : "#6ae8eb"
							ctx.lineWidth = i % 3 === 0 ? 2 : 1
							ctx.stroke()
						}

						// Hour hand
						var hAngle = ((hours % 12) * 30 + minutes * 0.5 - 90) * Math.PI / 180
						ctx.beginPath()
						ctx.moveTo(cx, cy)
						ctx.lineTo(cx + r * 0.5 * Math.cos(hAngle), cy + r * 0.5 * Math.sin(hAngle))
						ctx.strokeStyle = "#FFC500"
						ctx.lineWidth = 3
						ctx.lineCap = "round"
						ctx.stroke()

						// Minute hand
						var mAngle = (minutes * 6 + seconds * 0.1 - 90) * Math.PI / 180
						ctx.beginPath()
						ctx.moveTo(cx, cy)
						ctx.lineTo(cx + r * 0.7 * Math.cos(mAngle), cy + r * 0.7 * Math.sin(mAngle))
						ctx.strokeStyle = "#6ae8eb"
						ctx.lineWidth = 2
						ctx.lineCap = "round"
						ctx.stroke()

						// Second hand
						var sAngle = (seconds * 6 - 90) * Math.PI / 180
						ctx.beginPath()
						ctx.moveTo(cx, cy)
						ctx.lineTo(cx + r * 0.8 * Math.cos(sAngle), cy + r * 0.8 * Math.sin(sAngle))
						ctx.strokeStyle = "#8affff"
						ctx.lineWidth = 1
						ctx.lineCap = "round"
						ctx.stroke()

						// Center dot
						ctx.beginPath()
						ctx.arc(cx, cy, 3, 0, 2 * Math.PI)
						ctx.fillStyle = "#FFC500"
						ctx.fill()
					}
				}
			}

			RowLayout {
				id: timeRow
				anchors.centerIn: parent
				spacing: 4

				Text {
					text: "󰥔"
					color: root.fg
					font.family: "Symbols Nerd Font"
					font.pixelSize: 12
				}

				Text {
					id: timeText
					color: root.fg
					font.family: "Source Code Pro"
					font.pixelSize: 14

					Timer {
						interval: 100
						running: true
						repeat: true
						triggeredOnStart: true
						onTriggered: {
							var now = new Date()
							timeText.text = now.toLocaleTimeString(Qt.locale(), "HH:mm:ss")
						}
					}
				}
			}
		}
	}
}
