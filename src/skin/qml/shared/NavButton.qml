import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"

//-----------------------------------------------------------------------------
// Used in the Debug page for testing Page layouts.
Item {
    id: widget
    width: 64
    height: 32

    property color colorNormal: CustStyle.accent_normal
    property color colorPress: CustStyle.accent_active
    property color colorHover: "steelblue"
    property color colorText: CustStyle.accent_text
    property string textDisplay: "Button"

    signal action()

    Rectangle {
        id: body
        scale: shrunk ? CustStyle.but_shrink : 1.0
        radius: 2
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: widget.colorNormal
        property bool shrunk: false

        Text {
            text: textDisplay
            //color: colorText
            anchors.fill: parent
            smooth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            font.pixelSize: CustStyle.fsize_normal
            wrapMode: Text.WordWrap
        }

        // Create mouse interaction target area
        MouseArea {
            id: inputArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                widget.action()
            }

            onPressed: {
                body.color = widget.colorPress
                body.shrunk = true
            }
            onReleased: {
                body.color = widget.colorNormal
                body.shrunk = false
            }
            onEntered: {
                body.color = widget.colorHover
                body.shrunk = true
            }
            onExited: {
                body.color = widget.colorNormal
                body.shrunk = false
            }
        }

    }
}
