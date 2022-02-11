import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TextButton.qml
// Used when text displayed like a hyperlink is clickable.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  height: displayText.height
  width: displayText.width + fontIconRight.width
  color: "transparent"

  property string text_name: "clickme link" // Text that is clickable.
  property string font_icon: ""
  property string qrc_url: "qrc:/"          // location to go to when clicked on.
  property alias text_color: displayText.color

  signal linkActivated()

  //----------------------
  Text {
    id: displayText
    color: DawgsStyle.text_accent
    font.pixelSize: DawgsStyle.fsize_accent  
    textFormat: Text.RichText  // Allow for inline stylers.
    text: ("<style>a:link { color: " + color + "; }</style>" +
      "<a href=\"" +  qrc_url + "\">" + text_name + "</a>")
    // Signal for link interaction.
    onLinkActivated: {
      //console.log("Hyperlink text was clicked on.", link)
    }
    anchors {
      verticalCenter: parent.verticalCenter;
      left: parent.left
    }
  }

  // Font icon:
  Text {
    id: fontIconRight
    text: contextRoot.font_icon
    height: openExplorerBut.height
    color: displayText.color
    visible: (contextRoot.font_icon !== "")
    font.family: Fonts.icons_solid
    font.styleName: "Solid"
    font.pixelSize: DawgsStyle.fsize_accent
    smooth: true
    verticalAlignment: Text.AlignVCenter
    anchors {
      verticalCenter: parent.verticalCenter;
      left: displayText.right
      leftMargin: 4
    }
  }

  //----------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    id: inputArea
    anchors.fill: contextRoot
    cursorShape: (inputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
    onClicked: {
      contextRoot.linkActivated()
    }
  }

}//end 'contextRoot'