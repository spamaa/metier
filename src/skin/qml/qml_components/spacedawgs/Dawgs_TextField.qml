import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TextField.qml
// Styled element used for the input of text strings from the user.
//-----------------------------------------------------------------------------
TextField {
  id: contextRoot
  width: parent.width
  color: DawgsStyle.font_color
  placeholderText: "input some text..."
  placeholderTextColor: DawgsStyle.aa_norm_ol
  font.pixelSize: DawgsStyle.fsize_accent
  height: (DawgsStyle.verticalMargin + font.pixelSize * 2)
  maximumLength: (width / font.pixelSize)
  echoMode: TextInput.Normal
  renderType: Text.QtRendering

  property bool canClickOffClose: true

  // BG component:
  background: Item {
    implicitWidth: contextRoot.width
    implicitHeight: contextRoot.height

    Rectangle {
      id: bgRectFill
      implicitWidth: contextRoot.width
      implicitHeight: contextRoot.height
      color: ((contextRoot.focus || contextRoot.length > 0) ? DawgsStyle.aa_selected_bg : DawgsStyle.aa_hovered_bg)
      radius: 8
      border.color: ((contextRoot.focus || contextRoot.length > 0) ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol)
      border.width: 1
    }
  }
  
  // change mouse cursor on component hovering to os system equivalent
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (parent.hovered ? Qt.IBeamCursor : Qt.ArrowCursor)
  }

  // disable focus on click off
  Rectangle {
    id: mouseClickOffActionRect
    color: "transparent"
    parent: pageRoot
    width: parent.width
    height: parent.height
    visible: (contextRoot.focus && canClickOffClose === true)
    // create clickable area
    MouseArea {
      anchors.fill: parent
      enabled: (parent.visible)
      propagateComposedEvents: true
      onClicked: {
        contextRoot.focus = false
        mouse.accepted = false
      }
    }
  }

}//end 'contextRoot'