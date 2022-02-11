import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_PinNumBox.qml
// A large single number entry box typically used for user pin enrty.
//-----------------------------------------------------------------------------
TextField {
  id: contextRoot
  width:  (contextRoot.pin_count === 6 ? 50 : 75)
  height: 86
  color: DawgsStyle.font_color
  font.pixelSize: (contextRoot.pin_count === 6 ? DawgsStyle.fsize_title : DawgsStyle.fsize_pinnum)
  //font.weight: Font.Bold

  property int pin_count: 6      // sets size based on pin length request
  property bool was_error: false // alerts issue. 
  property int display_index: 0  // Value is set by parent for animation timing.
  opacity: 0.0

  maximumLength: 1
  validator: IntValidator { bottom: 0; top: 9 }
  horizontalAlignment: TextInput.AlignHCenter
  echoMode: TextInput.Normal
  renderType: Text.QtRendering

  // call signal when text has been entered
  signal tryNextBox()
  signal tryLastBox()
  signal hasChanged()

  // BG component:
  background: Item {
    width: contextRoot.width
    height: contextRoot.height
    Rectangle {
      id: bgRectFill
      width: parent.width
      height: parent.height
      opacity: (contextRoot.was_error ? 0.1 : 1.0)
      color: (contextRoot.was_error ? DawgsStyle.alert_bg :
        (contextRoot.focus || contextRoot.length > 0) ? DawgsStyle.aa_selected_bg : DawgsStyle.aa_hovered_bg
      );
      radius: 8
    }
    Rectangle {
      width: parent.width
      height: parent.height
      radius: bgRectFill.radius
      color: "transparent"
      border.color: (contextRoot.was_error ? DawgsStyle.alert_ol :
        (contextRoot.focus || contextRoot.length > 0) ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol
      );
      border.width: 1
    }
  }

  // instruct move to next box when field changed.
  onTextChanged: {
    if (contextRoot.length > 0) {
      contextRoot.tryNextBox()
    }
    contextRoot.hasChanged()
  }
  
  // change mouse cursor on component hovering to os system equivalent
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (parent.hovered ? Qt.IBeamCursor : Qt.ArrowCursor)
  }

  // backspace key press is clear and navigate to last PinBox component.
  Keys.onPressed: {
    if (event.key == Qt.Key_Backspace) {
      if (contextRoot.length === 0) {
        event.accepted = true
        contextRoot.tryLastBox()
        return
      }
    }
    event.accepted = false
  }

  //-----------------------------------------------------------------------------
  // Clear current and replay Animation:
  function replayAppearnceAnimation() {
    contextRoot.animationSpeed = 80
    contextRoot.appearanceSpeed = 40
    contextRoot.clear()
    contextRoot.opacity = 0.0
    appearAnimation.running = false
    contextRoot.was_error = false
    appearTimer.start()
  }
  // Appearence Animation:
  property int appearanceSpeed: 80
  property int animationSpeed: 120
  ParallelAnimation {
    id: appearAnimation
    running: false
    YAnimator { target: contextRoot
      from: 20;	to: 0; duration: contextRoot.animationSpeed;
      easing.type: Easing.OutBack
    }
    OpacityAnimator { target: contextRoot
      from: 0.0; to: 1.0;	duration: contextRoot.animationSpeed;
      easing.type: Easing.OutBack
    }
  }//end 'appearAnimation'
  Timer {
    id: appearTimer
    interval: contextRoot.appearanceSpeed + (contextRoot.animationSpeed * display_index)
    running: true
    onTriggered: {
      appearAnimation.running = true
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'