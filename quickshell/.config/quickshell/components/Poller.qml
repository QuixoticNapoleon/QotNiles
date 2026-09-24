import Quickshell
import Quickshell.Io
import QtQuick

// Periodically runs a command and emits its trimmed stdout.
Scope {
	id: poller

	property alias command: proc.command
	property alias interval: timer.interval
	signal output(string text)

	Timer {
		id: timer
		interval: 2000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: proc.running = true
	}

	Process {
		id: proc
		stdout: StdioCollector {
			onStreamFinished: poller.output(this.text.trim())
		}
	}
}
