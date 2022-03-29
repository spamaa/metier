import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// MatterFi_BiPolarSwitch.qml
// Offers a choice between two options, and only one can be selected.
//-----------------------------------------------------------------------------
Switch {
  id: contextRoot
  text: qsTr("Switch")
  width: displayText.width + selectorDeligate.width + (spacing * 2)
  spacing: 8
  //----------------------
  indicator: Item {}
  //----------------------
  contentItem: Row {
    id: content
    width: parent.width
    //height: displayText.height
    spacing: parent.spacing

    Text {
      id: displayText
      text: contextRoot.text
      font.pixelSize: DawgsStyle.fsize_accent
      //font.weight: Font.DemiBold
      opacity: enabled ? 1.0 : 0.3
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
      id: selectorDeligate
      width: (height * 2)
      height: parent.height
      y: parent.height / 2 - height / 2
      radius: 12
      color: (contextRoot.checked ? DawgsStyle.aa_selected_bg : DawgsStyle.font_color);
      border.color: (contextRoot.checked ? DawgsStyle.aa_selected_bg : DawgsStyle.aa_hovered_bg);

      Rectangle {
        id: selector
        width: parent.height
        height: width
        x: (contextRoot.checked ? parent.width - width : 0)
        radius: parent.radius
        color: (contextRoot.down ? DawgsStyle.aa_hovered_bg : DawgsStyle.font_color);
        border.color: (contextRoot.checked ? (contextRoot.down ? 
          DawgsStyle.aa_selected_bg : DawgsStyle.buta_active) : DawgsStyle.aa_norm_ol);
      }
    }
  }//end 'content'

  //-----------------------------------------------------------------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'