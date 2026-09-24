import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs
import qs.components

// Volume: shows default sink volume, click for a slider popup (0-300%).
BarBlock {
	id: volModule
	color: Theme.bg1
	clickable: true
	onClicked: popup.toggle()

	readonly property var sink: Pipewire.defaultAudioSink
	readonly property real volPercent: sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0
	readonly property bool isMuted: sink && sink.audio ? sink.audio.muted : false

	PwObjectTracker { objects: [ Pipewire.defaultAudioSink ] }

	Text {
		text: volModule.isMuted ? "\u{f0581}" : "\uf028"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		text: volModule.isMuted ? "MUTED" : volModule.volPercent + "%"
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}

	BarPopup {
		id: popup
		anchorItem: volModule
		xOffset: -40
		implicitWidth: 200
		implicitHeight: 80

		ColumnLayout {
			anchors.fill: parent
			spacing: 0

			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				spacing: 6

				Text {
					color: Theme.fg
					font.family: Theme.fontIcons
					font.pixelSize: 18
					text: volSlider.value === 0 ? "\uf026" : volSlider.value <= 50 ? "\uf027" : "\uf028"
				}

				Text {
					color: Theme.accent
					font.family: Theme.fontMono
					font.pixelSize: 17
					font.bold: true
					text: Math.round(volSlider.value) + "%"
				}
			}

			Item {
				id: volSlider
				Layout.fillWidth: true
				height: 20

				// Show the drag position while pressed, otherwise track the sink.
				// (Never assign to `value` -- that would break this binding.)
				property real value: sliderMouse.pressed ? sliderMouse.dragValue : volModule.volPercent

				Rectangle {
					anchors.verticalCenter: parent.verticalCenter
					width: parent.width
					height: 4
					radius: 2
					color: Theme.dim

					Rectangle {
						width: Math.max(0, Math.min(1, volSlider.value / 300)) * parent.width
						height: parent.height
						color: volSlider.value > 100 ? Theme.accent : Theme.bright
						radius: 2
					}
				}

				Rectangle {
					x: Math.max(0, Math.min(1, volSlider.value / 300)) * (parent.width - width)
					anchors.verticalCenter: parent.verticalCenter
					width: 12
					height: 12
					radius: 6
					color: volSlider.value > 100 ? Theme.accent : Theme.fg
				}

				MouseArea {
					id: sliderMouse
					anchors.fill: parent
					property real dragValue: 0

					onPressed: mouse => updateVol(mouse)
					onPositionChanged: mouse => { if (pressed) updateVol(mouse) }

					function updateVol(mouse) {
						const ratio = Math.max(0, Math.min(1, mouse.x / width))
						dragValue = Math.round(ratio * 300)
						if (volModule.sink && volModule.sink.audio)
							volModule.sink.audio.volume = dragValue / 100
					}
				}
			}
		}
	}
}
