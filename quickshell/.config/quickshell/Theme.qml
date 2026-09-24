pragma Singleton
import Quickshell
import QtQuick

Singleton {
	// Colors
	readonly property color bg1: "#003636"
	readonly property color bg2: "#004344"
	readonly property color fg: "#6ae8eb"
	readonly property color accent: "#FFC500"
	readonly property color bright: "#8affff"
	readonly property color dim: "#4d7f7f"
	readonly property color muted: "#707880"
	readonly property color popupBg: Qt.rgba(0, 0.212, 0.212, 1)

	// Fonts
	readonly property string fontMono: "Source Code Pro"
	readonly property string fontIcons: "Symbols Nerd Font"
	readonly property string fontPowerline: "Inconsolata for Powerline"
	readonly property string fontCjk: "Noto Sans CJK SC"
	readonly property string fontRunes: "Junicode"

	// Sizes
	readonly property int textSize: 14
	readonly property int iconSize: 12
	readonly property int sepSize: 25

	// Planetary day-of-week symbols (Sun..Sat, Japanese convention)
	readonly property var daySymbols: ["\u2609", "\u263d", "\u2642", "\u263f", "\u2643", "\u2640", "\u2644"]
}
