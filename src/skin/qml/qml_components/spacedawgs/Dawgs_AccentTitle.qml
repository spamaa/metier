import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_AccentTitle.qml
// Display a title with an accent to distinctly segregate sections displayed.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: 68
  color: "transparent"

  property string accentText: "Accent"
  property string titleText:  "Title Caption"

  //----------------------
  // Main display 'body'
  Column {
    id: body
    spacing: 4
    bottomPadding: 24
    anchors.fill: parent

    Text {
      id: accentTextDeligate
      text: contextRoot.accentText
      color: DawgsStyle.text_accent
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_accent
    }

    Text {
      id: titleTextDeligate
      text: contextRoot.titleText
      color: DawgsStyle.font_color
      width: parent.width
      wrapMode: Text.Wrap
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_title
    }
    
  }//end 'body'

//-----------------------------------------------------------------------------
}//end 'contextRoot'