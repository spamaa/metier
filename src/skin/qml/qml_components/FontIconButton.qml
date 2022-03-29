import QtQuick 2.15

import "qrc:/styling"
//-----------------------------------------------------------------------------
// FontIconButton.qml
// Displays chars from a font file as a button icon.
//-----------------------------------------------------------------------------
Item {
	id: contextRoot
	width: 32
	height: 32

	property string iconChar: "\uf06a" // exclamation-circle 'default icon'
	property color color: DawgsStyle.font_color
	property string fontFamilyName: Fonts.icons_solid
	property int iconSize: 24

	signal action() // called on mouse click.

	//-----------------------------------------------------------------------------
	// Maintains the size of the interaction object's footprint while animating.
	Rectangle {
		id: trueBody
		color: "transparent"
		width: contextRoot.width
		height: contextRoot.height

		// The insides that get animated when interaction is detected.
		Rectangle {
			id: body
			property bool shrunk: false
			scale: shrunk ? DawgsStyle.but_shrink : 1.0
			color: "transparent"
			width: parent.width
			height: parent.height
			radius: 2
			anchors.centerIn: parent
			// Draw the Icon:
			Text {
				text: contextRoot.iconChar
				font.pixelSize: contextRoot.iconSize
				font.family: (contextRoot.fontFamilyName)
				font.styleName: "Solid"
				font.weight: Font.Black
				color: contextRoot.color
				smooth: true
				anchors.fill: parent
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
			}
		}//end 'Body'

		// Mark area around body as Input area.
		MouseArea {
			id: inputArea
			anchors.fill: parent
			hoverEnabled: true
			focus: parent.visible
			cursorShape: (inputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)

			onPressed:  { body.shrunk = true  }
			onReleased: { body.shrunk = false }
			onEntered:  { body.shrunk = true  }
			onExited:   { body.shrunk = false }

			onClicked: {
				contextRoot.action()
			}
		}//end 'inputArea'

	}//end 'trueBody'
}//end 'contextRoot'
