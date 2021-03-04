import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"

//-----------------------------------------------------------------------------
// FontIconButton.qml
// Displays chars from a font file as a button icon.
Item {
    id: widget
    width: 32
    height: 32

    property bool enabled: true

    property string iconChar: "\uf06a" // exclamation-circle 'default icon'
    property color color: rootAppPage.currentStyle > 0 ? CustStyle.dm_icon_but : CustStyle.lm_icon_but
    property string fontFamilyName: Fonts.icons_solid
    property int iconSize: 26

    signal action() // called on mouse click.

    //-----------------------------------------------------------------------------
    // Maintains the size of the interaction object's footprint while animating.
    Rectangle {
        id: trueBody
        color: (inputArea.containsMouse ? CustStyle.active_highlight : "transparent")
        width: widget.width
        height: widget.height
        radius: width / 2

        // The insides that get animated when interaction is detected.
        Rectangle {
            id: body
            property bool shrunk: false
            scale: shrunk ? CustStyle.but_shrink : 1.0
            color: "transparent"
            width: parent.width
            height: parent.height
            radius: 2
            anchors.centerIn: parent
            // Draw the Icon:
            Text {
                text: widget.iconChar
                font.pixelSize: widget.iconSize
                font.family: (widget.fontFamilyName)
                font.styleName: "Solid"
                color: (widget.enabled ? widget.color : "grey")
                opacity: (widget.enabled ? 1.0 : 0.5)
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
            enabled: widget.enabled
            hoverEnabled: true

            onPressed:  { body.shrunk = true  }
            onReleased: { body.shrunk = false }
            onEntered:  { body.shrunk = true  }
            onExited:   { body.shrunk = false }

            onClicked: {
                widget.action()
            }
        }//end 'inputArea'

    }//end 'trueBody'
}//end 'widget'
