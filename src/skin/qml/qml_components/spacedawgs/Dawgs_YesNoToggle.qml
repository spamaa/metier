import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_YesNoToggle.qml
// Used to toggle binary states of yes or no situations.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width + DawgsStyle.horizontalMargin
  height: 48
  color: "transparent"

  property int selectedIndex: -1 // holds onto index choice when one is made.

  // Called when a selection is made to update the holding index property.
  // Index values:  1 = No  0 = Yes
  function makeSelection(button_index) {
    contextRoot.selectedIndex = button_index
    contextRoot.toggled()
  }

  signal toggled() // called when state of selection changes.

  //-----------------------------------------------------------------------------
  // Main display 'body'
  Row {
    id: body
    width: parent.width
    height: parent.height
    spacing: 16

    //----------------------
    // Yes button:
    Rectangle {
      id: buttonYesBGRect
      implicitWidth: buttonYes.width
      implicitHeight: buttonYes.height
      color: (buttonYes.down ? DawgsStyle.aa_selected_bg : (contextRoot.selectedIndex === 0 ? 
        DawgsStyle.aa_selected_bg : (buttonYes.hovered ? DawgsStyle.aa_hovered_bg : "transparent"))
      );
      radius: 8
      OutlineSimple {
        outline_color: (buttonYes.down ? DawgsStyle.aa_norm_ol : (contextRoot.selectedIndex === 0 ? 
          DawgsStyle.aa_selected_ol : (buttonYes.hovered ? DawgsStyle.but_txtnorm : DawgsStyle.aa_norm_ol))
        );
        radius: parent.radius
      }
      // now make the button
      Button {
        id: buttonYes
        width: body.width / 2 - body.spacing
        height: body.height
        scale: buttonYes.down ? DawgsStyle.but_shrink : 1.0
        enabled: (contextRoot.selectedIndex !== 0)
        // Draw button Text:
        contentItem: Text {
          text: qsTr("Yes")
          width: parent.width
          color: DawgsStyle.but_txtnorm
          font.pixelSize: DawgsStyle.fsize_accent
          font.weight: Font.DemiBold
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }
        // Draw Button style:
        background: Rectangle { color: "transparent" }
        onClicked: {
          contextRoot.makeSelection(0)
        }
        // Change cursor to pointing action as configured by root os system.
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.NoButton
          cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
        }
      }//end 'buttonYes'
    }//end 'buttonYesBGRect'

    //----------------------
    // No button:
    Button {
      id: buttonNo
      width: buttonYes.width
      height: parent.height
      scale: buttonNo.down ? DawgsStyle.but_shrink : 1.0
      enabled: (contextRoot.selectedIndex !== 1)
      // Draw button Text:
      contentItem: Text {
        text: qsTr("No")
        width: parent.width
        color: DawgsStyle.but_txtnorm
        font.pixelSize: DawgsStyle.fsize_accent
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
      }
      // Draw Button style:
      background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: (buttonNo.down ? DawgsStyle.aa_selected_bg : (contextRoot.selectedIndex === 1 ? 
          DawgsStyle.aa_selected_bg : (buttonNo.hovered ? DawgsStyle.aa_hovered_bg : "transparent"))
        );
        radius: 8
        border.color: (buttonNo.down ? DawgsStyle.aa_norm_ol : (contextRoot.selectedIndex === 1 ? 
          DawgsStyle.aa_selected_ol : (buttonNo.hovered ? DawgsStyle.but_txtnorm : DawgsStyle.aa_norm_ol))
        );
        border.width: 1
      }
      onClicked: {
        contextRoot.makeSelection(1)
      }
      // Change cursor to pointing action as configured by root os system.
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
      }
    }//end 'buttonYes'

  //----------------------
  }//end 'body'
  
//-----------------------------------------------------------------------------
}//end 'contextRoot'