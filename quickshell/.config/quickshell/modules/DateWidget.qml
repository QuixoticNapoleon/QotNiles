import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.components
import qs.services

// Date: full date in the bar, click for a calendar popup.
BarBlock {
	id: dateModule
	color: Theme.bg2
	clickable: true

	property int calMonth: new Date().getMonth()
	property int calYear: new Date().getFullYear()

	onClicked: {
		const now = new Date()
		calMonth = now.getMonth()
		calYear = now.getFullYear()
		popup.toggle()
	}

	Text {
		text: "\uf073"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		text: Time.dateString
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}

	BarPopup {
		id: popup
		anchorItem: dateModule
		xOffset: -40
		contentMargins: 11
		implicitWidth: 282
		implicitHeight: 322

		ColumnLayout {
			anchors.fill: parent
			spacing: 8

			// Month/Year header with navigation
			RowLayout {
				Layout.fillWidth: true

				Text {
					text: "<"
					color: Theme.fg
					font.family: Theme.fontMono
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
					text: dateModule.calYear + "\u5e74" + String(dateModule.calMonth + 1).padStart(2, '0') + "\u6708"
					color: Theme.accent
					font.family: Theme.fontCjk
					font.pixelSize: 14
					font.bold: true
				}

				Text {
					text: ">"
					color: Theme.fg
					font.family: Theme.fontMono
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
					model: Theme.daySymbols

					Text {
						required property string modelData
						Layout.fillWidth: true
						text: modelData
						color: Theme.accent
						font.family: Theme.fontMono
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
					property bool isToday: model.day === Time.now.getDate() &&
										   model.month === Time.now.getMonth() &&
										   model.year === Time.now.getFullYear()
					property bool isCurrentMonth: model.month === dateModule.calMonth

					text: model.day
					color: isToday ? Theme.accent : isCurrentMonth ? Theme.fg : Theme.dim
					font.family: Theme.fontMono
					font.pixelSize: 14
					font.bold: isToday
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
			}
		}
	}
}
