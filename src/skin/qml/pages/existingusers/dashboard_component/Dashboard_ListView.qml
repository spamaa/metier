import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// Dashboard_ListView.qml
// Used for drawing sub dashboard root view component lists. 
//-----------------------------------------------------------------------------
ListView {
  id: contextRoot
  model: []
  delegate: assetDeligate
  clip: true
  spacing: 8
  displayMarginEnd: 24
  width: parent.width
  height: parent.height
  anchors.horizontalCenter: parent.horizontalCenter

  property string footerText: "footer"       // header text displayed.
  property string footerButtonText: "button" // button text displayed.
  property int animationAppearanceSpeed: 600 // ms time before an item finsihes deligation.

  signal footerAction() // called on footer button action.

  //----------------------
  // list Footer:
  footer: Item {
    id: footerRoot
    visible: (contextRoot.footerText !== "")
    height: footerBody.height + (DawgsStyle.verticalMargin * 2)
    width: parent.width

    Rectangle {
      id: footerBody
      width: parent.width
      height: addtokenPromptColumn.height + DawgsStyle.verticalMargin
      color: DawgsStyle.norm_bg
      visible: parent.visible
      radius: 12
      opacity: 0.0
      anchors {
        horizontalCenter: parent.horizontalCenter;
        bottom: parent.bottom;
      }

      Column {
        id: addtokenPromptColumn
        width: parent.width
        spacing: 4
        anchors.horizontalCenter: parent.horizontalCenter

        Dawgs_CenteredTitle {
          fontPixelSize: DawgsStyle.fsize_accent
          textTitle: contextRoot.footerText
        }

        MatterFi_RoundButton {
          text: contextRoot.footerButtonText
          anchors.horizontalCenter: parent.horizontalCenter
          border_color: DawgsStyle.buta_active
          onClicked: contextRoot.footerAction()
        }
      }
      // Footer appearance animation:
      Timer {
        id: footerShowTimer
        running: true
        interval: animationAppearanceSpeed
        onTriggered: {
          footerAppearnceAnimation.running = true
          running = false
        }
      }

      ParallelAnimation {
        id: footerAppearnceAnimation
        running: false
        NumberAnimation { target: footerBody; property: "y"; 
          from: footerBody.height; to: 0;
          duration: animationAppearanceSpeed; easing.type: Easing.OutBack 
        }
        NumberAnimation { target: footerBody; property: "opacity"; 
          from: 0.0; to: 1.0; duration: animationAppearanceSpeed 
        }
      }
    }//end 'footerBody'
  }//end 'footerRoot'

  //----------------------
  // Animations:
  populate: Transition {
    NumberAnimation { property: "y"; duration: animationAppearanceSpeed; easing.type: Easing.OutBack }
    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: animationAppearanceSpeed }
  }

  add: Transition {
    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: animationAppearanceSpeed }
  }

  displaced: Transition {
    PropertyAction { properties: "opacity"; value: 1.0 }
    NumberAnimation { property: "y"; duration: animationAppearanceSpeed }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'