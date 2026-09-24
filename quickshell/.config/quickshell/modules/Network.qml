import QtQuick
import qs
import qs.components

// Network: WiFi (iface + SSID + IP) or Ethernet (iface + IP), 5s poll.
BarBlock {
	id: net
	color: Theme.bg1

	property string netType: ""  // "wifi" | "eth" | "disconnected" | "" (initial)
	property string iface: ""
	property string ssid: "..."
	property string ip: ""

	Text {
		text: net.netType === "eth" ? "\uef44"
			: net.netType === "disconnected" ? "\u{f16bc}" : "\uf1eb"
		color: Theme.fg
		font.family: Theme.fontIcons
		font.pixelSize: Theme.iconSize
	}

	Text {
		text: net.iface
		color: Theme.accent
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
		visible: text !== ""
	}

	Text {
		text: net.netType === "disconnected" ? "DISCONNECTED" : net.ssid
		color: net.netType === "disconnected" ? Theme.muted : Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
		font.bold: net.netType !== "disconnected"
		visible: text !== ""
	}

	Text {
		text: net.ip
		color: Theme.fg
		font.family: Theme.fontMono
		font.pixelSize: Theme.textSize
		visible: text !== ""
	}

	Poller {
		interval: 5000
		command: ["sh", "-c", "WIFACE=$(ip -o link show up | grep -oP 'wl[^:]+' | head -1); EIFACE=$(ip -o link show up | grep -oP 'en[^:]+' | head -1); if [ -n \"$WIFACE\" ]; then SSID=$(iwgetid -r 2>/dev/null); if [ -n \"$SSID\" ]; then IP=$(ip -4 -o addr show $WIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"wifi|$WIFACE|$SSID|$IP\"; else echo disconnected; fi; elif [ -n \"$EIFACE\" ]; then IP=$(ip -4 -o addr show $EIFACE 2>/dev/null | cut -d' ' -f7 | cut -d/ -f1); echo \"eth|$EIFACE|$IP\"; else echo disconnected; fi"]
		onOutput: text => {
			const parts = text.split("|")
			if (parts[0] === "wifi") {
				net.netType = "wifi"
				net.iface = parts[1] || ""
				net.ssid = parts[2] || ""
				net.ip = parts[3] || ""
			} else if (parts[0] === "eth") {
				net.netType = "eth"
				net.iface = parts[1] || ""
				net.ssid = ""
				net.ip = parts[2] || ""
			} else {
				net.netType = "disconnected"
				net.iface = ""
				net.ssid = ""
				net.ip = ""
			}
		}
	}
}
