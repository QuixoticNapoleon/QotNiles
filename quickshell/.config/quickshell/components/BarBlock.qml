import QtQuick
import QtQuick.Layouts
import qs

// Colored container for a bar module: fills bar height, centers its
// children in a RowLayout. Set `clickable: true` and handle `clicked()`
// for modules that open popups.
Rectangle {
	id: block

	property int padding: 16
	property bool clickable: false
	signal clicked()
	property alias spacing: row.spacing
	default property alias content: row.data

	color: Theme.bg1
	Layout.fillHeight: true
	implicitWidth: row.implicitWidth + padding

	MouseArea {
		anchors.fill: parent
		enabled: block.clickable
		onClicked: block.clicked()
	}

	RowLayout {
		id: row
		anchors.centerIn: parent
		spacing: 4
	}
}
