import QtQuick 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"

//-----------------------------------------------------------------------------
// Used for a styled horizonatal line divider for list elements.
Item {
    id: widget

    property color color: CustStyle.neutral_fill

    property int bottomPadding: 0
    property int topPadding: 0

    Rectangle {
        color: "transparent"
        height: widget.height + widget.topPadding + widget.bottomPadding
        width: widget.width

        Rectangle {
            color: widget.color
            height: 1
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.bottomMargin: widget.bottomPadding
            anchors.topMargin: widget.topPadding
        }
    }
}
