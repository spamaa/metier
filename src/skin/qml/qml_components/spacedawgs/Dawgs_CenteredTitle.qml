import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_CenteredTitle.qml
// Title Component to distinctly segregate areas of the screen display.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: 48
  color: "transparent"
  anchors.horizontalCenter: parent.horizontalCenter

  property string textTitle: "CenteredTitle"
  property alias fontPixelSize: titleText.font.pixelSize
  property alias fontcolor: titleText.color

  //----------------------
  // Display the title string:
  Text {
    id: titleText
    width: parent.width
    text: contextRoot.textTitle
    anchors.fill: parent
    font.pixelSize: DawgsStyle.fsize_title
    font.weight: Font.DemiBold
    color: DawgsStyle.font_color
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'