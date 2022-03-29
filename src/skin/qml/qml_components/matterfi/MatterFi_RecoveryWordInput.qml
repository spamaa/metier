import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// MatterFi_RecoveryWordInput.qml
// Entry text box for recovery phrases.
//-----------------------------------------------------------------------------
Row {
  id: contextRoot
  spacing: 8
  focus: false
  property bool active_focus: false // on Tab key, focus is shifted by parent

  property bool fieldReady: false // only set true on valid input accepted

  property string text: ""           // what text is currently displayed
  property int display_index: 0   // which index is this word field display
  property var issue_at_index: undefined // an index set from parent to highlight an issue

  // Sets color to highlighed field when error or correct.
  property var bgColor: (displayOnly === true ? DawgsStyle.aa_hovered_bg :
    contextRoot.issue_at_index === contextRoot.display_index ? DawgsStyle.alert_ol : 
    (wordInputArea.acceptableInput ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_hovered_bg
  ));

  // These values get set by the users interactions
  // with the combo selection boxes for options.
  property int encryption:  1 // place holder
  property int language:    1 // place holder
  property int longestWord: 8 // place holder, should be sat via OT 'api' from parent

  // Can use the same display format, but only to display
  // words instead not letting the user input values.
  property bool displayOnly: false 

  signal nextBox()    // emits that Tab/Enter navigate to next entry field.
  signal changed()    // emits that the user is interacting with this box.
  signal verificationChecked() // emits that TextField has been checked.

  //----------------------
  Component.onCompleted: {
    // sets the starting length value, gets updated from parent
    contextRoot.longestWord = api.longestSeedWord || 8
    //console.log("Longest word length is: ", contextRoot.longestWord)
  }

  //----------------------
  // wordInputArea BG rect fill:
  Rectangle {
    id: bgRectFill
    implicitWidth: contextRoot.width
    implicitHeight: contextRoot.height
    color: (contextRoot.bgColor)
    radius: height / 2
    opacity: 0.0
    border.color: (wordInputArea.focus ? DawgsStyle.aa_selected_ol : DawgsStyle.buta_active)
    border.width: (wordInputArea.focus ? 2 : 1)
    // Index bg Component:
    Rectangle {
      id: numIndexBg
      height: parent.height
      width: 24
      clip: true
      color: "transparent"
      anchors.verticalCenter: parent.verticalCenter
      Rectangle {
        id: indexBGfiller
        height: parent.height - 8
        width: height
        x: 3
        color: DawgsStyle.buta_selected
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter
      }
    }
    Rectangle {
      width: numIndexBg.width / 2 + 2
      height: numIndexBg.height - 8
      x: width - 2
      color: indexBGfiller.color
      radius: 4
      anchors.verticalCenter: parent.verticalCenter
    }
    //----------------------
    // display index
    Text {
      id: indexIdText
      leftPadding: 4
      width: 24
      text: (contextRoot.display_index + 1)
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_lable
      font.weight: Font.DemiBold
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      anchors.verticalCenter: parent.verticalCenter
    }

    //----------------------
    // Word input area with built in verification.
    TextInput {
      id: wordInputArea
      focus: (contextRoot.active_focus ? true : false) // is active input?
      readOnly: contextRoot.displayOnly
      text: contextRoot.text // place holder text or display text
      width: contextRoot.width
      height: contextRoot.height
      maximumLength: contextRoot.longestWord
      leftPadding: numIndexBg.width + 6
      //focus: contextRoot.focus
      color: DawgsStyle.font_color
      // Text display properties:
      echoMode: TextInput.Normal
      renderType: Text.QtRendering
      font.capitalization: Font.AllLowercase
      font.weight: Font.DemiBold
      anchors.verticalCenter: parent.verticalCenter
      verticalAlignment: Text.AlignVCenter
      // set bg color based on field correctness
      validator: (api.seedWordValidatorQML(contextRoot.encryption, contextRoot.language))

      // update the entered value container
      onTextEdited: {
        contextRoot.fieldReady = acceptableInput
        contextRoot.text = text
        contextRoot.changed()
        contextRoot.bgColor = (displayOnly === true ? DawgsStyle.aa_hovered_bg : 
          (acceptableInput ? DawgsStyle.aa_selected_bg : 
          (contextRoot.issue_at_index === contextRoot.display_index) ? DawgsStyle.alert_ol : DawgsStyle.aa_hovered_bg
        ));
        if (displayOnly === true) return;
        contextRoot.verificationChecked()
      }

      //----------------------
      // tab key navigates to next box
      Keys.onTabPressed: {
        if (displayOnly === true) return;
        contextRoot.fieldReady = acceptableInput
        contextRoot.text = text
        contextRoot.nextBox()
        contextRoot.verificationChecked()
        event.accepted = true
      }
      // on key press event:
      Keys.onReleased: {
        if (displayOnly === true) return;
        if (Qt.platform.os === "linux" || Qt.platform.os === "windows" || Qt.platform.os === "osx" || Qt.platform.os === "unix") {
          // backspace key navigates clears a valid filled box
          // on Apple, this is actually the "delete" key
          if (event.key == Qt.Key_Backspace) {
            contextRoot.fieldReady = acceptableInput
            if (acceptableInput) {
              contextRoot.text = ""
              wordInputArea.clear()
              contextRoot.changed()
              contextRoot.bgColor = DawgsStyle.aa_hovered_bg
            }
            contextRoot.fieldReady = acceptableInput
            contextRoot.verificationChecked()
          // Enter or SpaceBar was used, try to move cursor to next entry field:
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            contextRoot.text = text
            contextRoot.fieldReady = acceptableInput
            contextRoot.nextBox()
            contextRoot.verificationChecked()
            event.accepted = true
            return
          }
        }
        event.accepted = false
      }
    }
    // change mouse cursor on component hovering to os system equivalent
    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.NoButton
      enabled: (displayOnly === true)
      cursorShape: (parent.hovered ? Qt.IBeamCursor : Qt.ArrowCursor)
    }
  }//end 'bgRectFill'

  //-----------------------------------------------------------------------------
  // Appearence Animation:
  ParallelAnimation {
    id: appearAnimation
    running: false
    YAnimator { target: bgRectFill
      from: 6;	to: 0; duration: 100;
      easing.type: Easing.OutBack
    }
    OpacityAnimator { target: bgRectFill
      from: 0.0; to: 1.0;	duration: 100;
      easing.type: Easing.OutBack
    }
  }//end 'appearAnimation'
  Timer {
    id: appearTimer
    interval: 300 + (80 * display_index)
    running: (parent.visible)
    onTriggered: {
      appearAnimation.running = true
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'