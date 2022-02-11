import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// MatterFi_RoundButton.qml
// Provides a rounded style clickable button.
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  scale: contextRoot.down ? DawgsStyle.but_shrink : 1.0
  property color border_color: DawgsStyle.aa_norm_ol

  // Draw button Text:
  contentItem: Text {
    text: contextRoot.text
    color: contextRoot.border_color
    font.pixelSize: DawgsStyle.fsize_accent
    font.weight: Font.DemiBold
    padding: 4
    leftPadding: 8
    rightPadding: leftPadding
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  // Draw Button style:
  background: Rectangle {
    color: (contextRoot.hovered ? DawgsStyle.aa_hovered_bg : "transparent")
    border.color: contextRoot.border_color
    border.width: 1
    radius: height / 2
  }
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: contextRoot
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }
}//end 'contextRoot'