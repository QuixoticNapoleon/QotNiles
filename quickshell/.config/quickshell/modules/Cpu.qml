import QtQuick
import qs
import qs.components

// CPU load over the last poll interval (delta of /proc/stat counters).
BarBlock {
	id: cpu
	color: Theme.bg1

	property real prevTotal: 0
	property real prevIdle: 0

	Text {
		text: "\uf2db"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		id: cpuText
		text: "..."
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
	}

	Poller {
		command: ["cat", "/proc/stat"]
		interval: 2000
		onOutput: text => {
			const f = text.split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
			const idle = f[3] + f[4]
			const total = f.reduce((a, b) => a + b, 0)
			const dt = total - cpu.prevTotal
			const di = idle - cpu.prevIdle
			if (cpu.prevTotal > 0 && dt > 0)
				cpuText.text = Math.round(100 * (dt - di) / dt) + "%"
			cpu.prevTotal = total
			cpu.prevIdle = idle
		}
	}
}
