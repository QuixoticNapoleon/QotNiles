import QtQuick
import QtQuick.Layouts
import qs

// Hyprland workspaces 1-12: Chinese numerals + runes. Click to switch.
RowLayout {
	spacing: 12

	Repeater {
		model: ["\u4e00", "\u4e8c", "\u4e09", "\u56db", "\u4e94", "\u516d", "\u4e03", "\u516b", "\u4e5d", "\u5341", "\u16a8", "\u16a0"]
		WorkspaceButton {}
	}
}
