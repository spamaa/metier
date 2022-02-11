import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_SendButton.qml
// Creates a round button with a font icon in the center of it.
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  height: 48
  width: height
  // Draw button Text:
  contentItem: Text {
    text: IconIndex.sd_send
    color: DawgsStyle.font_color
    font.pixelSize: quickSendButton.height / 2 //DawgsStyle.fsize_pinnum
    font.family: Fonts.icons_spacedawgs
    font.weight: Font.Black // Font.ExtraBold // Font.Black
    padding: 0; rightPadding: 4; topPadding: 2; bottomPadding: 0
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }
  // Draw Button style:
  background: Rectangle {
    width: parent.width
    height: parent.height
    color: (quicksendInputArea.containsMouse ? DawgsStyle.buta_selected : DawgsStyle.buta_active)
    radius: height / 2
  }
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    id: quicksendInputArea
    hoverEnabled: true
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }
}//end 'contextRoot'