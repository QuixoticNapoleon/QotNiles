pragma Singleton
import Quickshell
import QtQuick
import qs

Singleton {
	id: root

	readonly property date now: clock.date
	readonly property string hhmmss: Qt.formatDateTime(clock.date, "HH:mm:ss")
	readonly property string dateString: {
		const d = clock.date
		const m = String(d.getMonth() + 1).padStart(2, '0')
		const day = String(d.getDate()).padStart(2, '0')
		return d.getFullYear() + "\u5e74" + m + "\u6708" + day + "\u65e5 (" + Theme.daySymbols[d.getDay()] + ")"
	}

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}
}
