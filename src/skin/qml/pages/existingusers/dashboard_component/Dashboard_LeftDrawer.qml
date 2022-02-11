import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_LeftDrawer.qml
// Displayed when the Dashboard's Header bar's left menu.
//-----------------------------------------------------------------------------
Popup {
  id: popupRoot
  height: body.height
  width: pageRoot.width * 0.85
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
  modal: true

  background: Rectangle { color: "transparent" }

  //-----------------------------------------------------------------------------
  // main display 'body' layout
  contentItem: Rectangle {
    id: interactionAreaBG
    width: parent.width
    height: body.height
    color: DawgsStyle.norm_bg
    radius: 12
    //----------------------
    // Display body
    Column {
      id: body
      width: interactionAreaBG.width
      height: 512
      
    }//end 'body'
    
    //-----------------------------------------------------------------------------
    // States for transitioning:
    state: "closed"
    states: [
      State { name: "closed"
        PropertyChanges {
          opacity: 0.0
          scale: 0.0
          target: interactionAreaBG
        }
      },
      State { name: "open"
        PropertyChanges {
          target: interactionAreaBG
          opacity: 1.0
          scale: 1.0
        }
      }
    ]//end 'states'

    transitions: [
      Transition {
        from: "open"; to: "closed"
        ParallelAnimation {
          ScaleAnimator   { target: interactionAreaBG; duration: 200 }
          OpacityAnimator { target: interactionAreaBG; duration: 200 }
        }
      },
      Transition {
        from: "closed"; to: "open"
        ParallelAnimation {
          id: openAnimation
          ScaleAnimator   { target: interactionAreaBG; duration: 200 }
          OpacityAnimator { target: interactionAreaBG; duration: 200 }
        }
      }
    ]//end 'transitions'

  }//end 'interactionAreaBG'

  //-----------------------------------------------------------------------------
  onClosed: {
    interactionAreaBG.state = "closed"
  }

  onOpened: {
    interactionAreaBG.state = "open"
  }
//-----------------------------------------------------------------------------
}//end 'popupRoot'