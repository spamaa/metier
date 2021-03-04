import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// The customized checkbox deligat to fit in with the design theme.
//-----------------------------------------------------------------------------
CheckBox {
    id: widget
    text: qsTr("CheckBox")
    checked: true
    width: 96
    height: 32
    property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
    // what the check box looks like
    indicator: Rectangle {
      id: indicatorBody
      implicitWidth: 22
      implicitHeight: 22
      x: widget.leftPadding
      y: parent.height / 2 - height / 2
      radius: 3
      border.color: widget.down ? CustStyle.pkt_logo : CustStyle.accent_fill
      // is marked fill space
      Rectangle {
        property var boarder_width: 8
        width: indicatorBody.width - boarder_width
        height: indicatorBody.height - boarder_width
        x: boarder_width / 2
        y: boarder_width / 2
        radius: 2
        color: widget.down ? CustStyle.accent_fill : CustStyle.pkt_logo 
        visible: widget.checked
        // ansi character marker
        Text {
          text: "\u2713" // check mark
          color: widget.fontColor
          font.pixelSize: CustStyle.fsize_normal
          anchors.centerIn : parent
        }
      }
    }
    // The text lable
    contentItem: Text {
      text: widget.text
      font: widget.font
      opacity: enabled ? 1.0 : 0.3
      color: widget.fontColor
      //font.pixelSize: CustStyle.fsize_normal // already sat.
      verticalAlignment: Text.AlignVCenter
      leftPadding: widget.indicator.width + widget.spacing
    }
}