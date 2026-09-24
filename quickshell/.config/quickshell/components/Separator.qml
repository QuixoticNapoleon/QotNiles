import QtQuick
import QtQuick.Layouts
import qs

// Powerline transition glyph between bar modules.
Text {
	id: sep

	property color fillColor          // triangle (glyph) color
	property color backColor: "transparent"  // color behind the glyph
	property bool pointLeft: false

	text: pointLeft ? "\ue0b2" : "\ue0b0"
	color: fillColor
	font.family: Theme.fontPowerline
	font.pixelSize: Theme.sepSize
	Layout.fillHeight: true
	verticalAlignment: Text.AlignVCenter

	Rectangle {
		anchors.fill: parent
		color: sep.backColor
		z: -1
	}
}
