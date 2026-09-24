import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.services

// Time: HH:mm:ss in the bar, click for an analog clock popup.
BarBlock {
	id: timeModule
	color: Theme.bg1
	clickable: true
	onClicked: popup.toggle()

	Text {
		text: "\u{f0954}"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		text: Time.hhmmss
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}

	BarPopup {
		id: popup
		anchorItem: timeModule
		xOffset: -100
		contentMargins: 15
		implicitWidth: 220
		implicitHeight: 240

		Canvas {
			id: clockCanvas
			anchors.fill: parent

			property date now: Time.now
			onNowChanged: if (popup.visible) requestPaint()

			onPaint: {
				const ctx = getContext("2d")
				const size = Math.min(width, height)
				const cx = width / 2
				const cy = height / 2
				const r = size / 2 - 5
				const hours = now.getHours()
				const minutes = now.getMinutes()
				const seconds = now.getSeconds()

				ctx.clearRect(0, 0, width, height)

				// Clock face circle
				ctx.beginPath()
				ctx.arc(cx, cy, r, 0, 2 * Math.PI)
				ctx.strokeStyle = Theme.bright
				ctx.lineWidth = 1.5
				ctx.stroke()

				// Hour markers
				for (let i = 0; i < 12; i++) {
					const angle = (i * 30 - 90) * Math.PI / 180
					const inner = i % 3 === 0 ? r - 12 : r - 8
					const outer = r - 3
					ctx.beginPath()
					ctx.moveTo(cx + inner * Math.cos(angle), cy + inner * Math.sin(angle))
					ctx.lineTo(cx + outer * Math.cos(angle), cy + outer * Math.sin(angle))
					ctx.strokeStyle = i % 3 === 0 ? Theme.accent : Theme.fg
					ctx.lineWidth = i % 3 === 0 ? 2 : 1
					ctx.stroke()
				}

				// Hour hand
				const hAngle = ((hours % 12) * 30 + minutes * 0.5 - 90) * Math.PI / 180
				ctx.beginPath()
				ctx.moveTo(cx, cy)
				ctx.lineTo(cx + r * 0.5 * Math.cos(hAngle), cy + r * 0.5 * Math.sin(hAngle))
				ctx.strokeStyle = Theme.accent
				ctx.lineWidth = 3
				ctx.lineCap = "round"
				ctx.stroke()

				// Minute hand
				const mAngle = (minutes * 6 + seconds * 0.1 - 90) * Math.PI / 180
				ctx.beginPath()
				ctx.moveTo(cx, cy)
				ctx.lineTo(cx + r * 0.7 * Math.cos(mAngle), cy + r * 0.7 * Math.sin(mAngle))
				ctx.strokeStyle = Theme.fg
				ctx.lineWidth = 2
				ctx.lineCap = "round"
				ctx.stroke()

				// Second hand
				const sAngle = (seconds * 6 - 90) * Math.PI / 180
				ctx.beginPath()
				ctx.moveTo(cx, cy)
				ctx.lineTo(cx + r * 0.8 * Math.cos(sAngle), cy + r * 0.8 * Math.sin(sAngle))
				ctx.strokeStyle = Theme.bright
				ctx.lineWidth = 1
				ctx.lineCap = "round"
				ctx.stroke()

				// Center dot
				ctx.beginPath()
				ctx.arc(cx, cy, 3, 0, 2 * Math.PI)
				ctx.fillStyle = Theme.accent
				ctx.fill()
			}
		}
	}
}
