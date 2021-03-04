import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"
//-----------------------------------------------------------------------------
// Entry text box for recovery phrases.
Row {
  id: widget
  spacing: 8
  focus: false
  property var active_focus: false // on Tab key, focus is shifted by parent

  property bool fieldReady: false // only set true on valid input accepted

  property var text: ""           // what text is currently displayed
  property var display_index: 0   // which index is this word field display
  property var issue_at_index: undefined // an index set from parent to highlight an issue

  // Sets color to highlighed field when error or correct.
  property var bgColor: (widget.issue_at_index === widget.display_index ? CustStyle.neutral_error : 
      wordInputArea.acceptableInput ? CustStyle.neutral_correct : CustStyle.neutral_fill)

  // These values get set by the users interactions
  // with the combo selection boxes for options.
  property var encryption:  1 // place holder
  property var language:    1 // place holder
  property var longestWord: 8 // place holder, should be sat via otwrap from parent

  // Can use the same display format, but only to display
  // words instead not letting the user input values.
  property var displayOnly: false 

  signal nextBox()  // emits that Tab/Enter navigate to next entry field.
  signal changed()  // emits that the user is interacting with this box.

  //----------------------
  Component.onCompleted: {
    // sets the starting length value, gets updated from parent
    widget.longestWord = otwrap.longestSeedWord || 8
    //console.log("Longest word length is: ", widget.longestWord)
  }

  //----------------------
  Text {
    id: indexIdText
    leftPadding: 8
    width: 20
    text: (widget.display_index + 1) + "."
    color: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
    font.pixelSize: CustStyle.fsize_normal
    anchors.verticalCenter: parent.verticalCenter
    verticalAlignment: Text.AlignVCenter
    // wordInputArea BG rect fill, done here
    // as if it was created in the TextInput object
    // it will prevent 'focus' for TextInput
    Item {
      x: wordInputArea.x
      y: wordInputArea.y - 6
      implicitWidth: wordInputArea.width
      implicitHeight: wordInputArea.height
      Rectangle {
        color: (widget.bgColor)
        height: parent.height
        width: parent.width
        radius: 4.0
      }
    }
  }

  //----------------------
  // Word input area with built in verification.
  TextInput {
    id: wordInputArea
    focus: (widget.active_focus ? true : false) // is active input?
    readOnly: widget.displayOnly
    text: widget.text // place holder text or display text
    width: widget.width - indexIdText.width
    height: widget.height
    maximumLength: widget.longestWord
    //focus: widget.focus
    color: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
    // Text display properties:
    echoMode: TextInput.Normal
    renderType: Text.QtRendering
    font.capitalization: Font.AllLowercase
    anchors.verticalCenter: parent.verticalCenter
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    // set bg color based on field correctness
    validator: (otwrap.seedWordValidatorQML(widget.encryption, widget.language))

    // update the entered value container
    onTextEdited: {
      widget.fieldReady = acceptableInput
      widget.text = text
      widget.changed()
      widget.bgColor = (acceptableInput ? CustStyle.neutral_correct : widget.issue_at_index === widget.display_index ? 
        CustStyle.neutral_error : CustStyle.neutral_fill)
    }
    //----------------------
    // tab key navigates to next box
    Keys.onTabPressed: {
      widget.fieldReady = acceptableInput
      widget.text = text
      widget.nextBox()
      event.accepted = true
    }
    // on key press event:
    Keys.onReleased: {
      if (Qt.platform.os === "linux" || Qt.platform.os === "windows" || Qt.platform.os === "osx" || Qt.platform.os === "unix") {
        // backspace key navigates clears a valid filled box
        // on Apple, this is actually the "delete" key
        if (event.key == Qt.Key_Backspace) {
          widget.fieldReady = acceptableInput
          if (acceptableInput) {
            wordInputArea.clear()
            widget.text = ""
            widget.changed()
            widget.bgColor = CustStyle.neutral_fill
          }
          //console.log("back key was used.")
        // Enter was used, try to move cursor to next entry field:
        } else if (event.key === Qt.Key_Return) {
          widget.text = text
          widget.fieldReady = acceptableInput
          widget.nextBox()
          event.accepted = true
          return
        }
      }
      event.accepted = false
    }
  }

//-----------------------------------------------------------------------------
}//end 'widget'