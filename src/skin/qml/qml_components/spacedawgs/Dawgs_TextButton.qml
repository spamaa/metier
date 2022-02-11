import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TextButton.qml
// Used when text displayed like a hyperlink is clickable.
//-----------------------------------------------------------------------------
Text {
  id: contextRoot

  property string text_name: "clickme link" // Text that is clickable.
  property string qrc_url: "qrc:/"          // location to go to when clicked on.

  //----------------------
  color: DawgsStyle.text_accent
  font.pixelSize: DawgsStyle.fsize_accent  
  textFormat: Text.RichText  // Allow for inline stylers.
  text: ("<style>a:link { color: " + color + "; }</style>" +
    "<a href=\"" +  qrc_url + "\">" + text_name + "</a>")

  // Signal for link interaction.
  onLinkActivated: {
    //console.log("Hyperlink text was clicked on.", link)
  }

  //----------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'