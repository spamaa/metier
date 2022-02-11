import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// MatterFi_PinWall.qml
// Provides prompt pin code protection between protected component interaction.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot

  property bool needPin: true    // Status of pin requirement.
  property bool syncTimer: true  // Sync shared pinWalls so user only enters pass once every so often.

  signal pinCorrectlyEntered()

  //----------------------
  Component.onCompleted: {
    // debug skipping pins
    if (DawgsStyle.debug_skipPinWalls) {
      contextRoot.needPin = false
      contextRoot.pinCorrectlyEntered()
      return
    }
    // If syncing pin entry cache, check time between last pin entry
    if (syncTimer) {
      contextRoot.needPin = (UIUX_UserCache.hasEnteredPassRecently() === false)
      contextRoot.pinCorrectlyEntered()
    }
  }

  //-----------------------------------------------------------------------------
  Column {
    id: pinVerificationColumn
    visible: (contextRoot.needPin && !assetUnlockedAnimation.running && !unlockedFinishTimer.running)
    spacing: 12
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_Button {
      id: pinCancelButton
      x: parent.width - width
      width: 52
      justText: true
      iconLeft: true
      manualWidth: true
      fontIcon: IconIndex.fa_chevron_left
      fontFamily: Fonts.icons_solid
      buttonType: "Plain"
      displayText: qsTr("cancel")
      onClicked: pageRoot.popDash()
    }

    Dawgs_AccentTitle {
      accentText: qsTr("security check")
      titleText: qsTr("Enter pin code")
    }
    // toggle pin length switch, 6 or 4
    Dawgs_PinLenSwitch {
      id: pinLengthModeConfig
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // Prompt pin entry:
    Row {
      id: pinEntryRow
      spacing: (pinEntryRow.pinLength === 6 ? 3 : 8)
      property int pinLength: (pinLengthModeConfig.pinLengthMode)
      anchors.horizontalCenter: parent.horizontalCenter
      // check pin for validity:
      function tryPin(userpin) {
        if (userpin.length < pinEntryRow.pinLength) {
          return
        }
        // TODO: tie into OT 'api' for user blockchain verification
        if (userpin === "123456" || userpin === "1234") {
          // success
          assetUnlockedAnimation.running = true
        } else {
          // failure
          pinEntryRow.resetPinEntry(true)
        }
      }

      // join input fields
      function checkPinEntered() {
        var pinString = ""
        for (var i = 0; i < pinEntryRow.pinLength; i++) {
          pinString += pinEntryBoxes.itemAt(i).text
        }
        pinEntryRow.tryPin(pinString)
      }

      // reset entry
      function resetPinEntry(was_error = false) {
        for (var i = 0; i < pinEntryRow.pinLength; i++) {
          pinEntryBoxes.itemAt(i).clear()
          if (was_error) {
            pinEntryBoxes.itemAt(i).was_error = true
          }
        }
      }
      // draw the pin boxes:
      Repeater {
        id: pinEntryBoxes
        model: (pinEntryRow.pinLength)
        Dawgs_PinNumBox {
          display_index: index + 1
          pin_count: pinEntryRow.pinLength
          onTryNextBox: {
            pinEntryBoxes.itemAt(index).focus = false
            if (index < pinEntryRow.pinLength - 1) {
              pinEntryBoxes.itemAt(index + 1).focus = true
            } else {
              pinEntryRow.checkPinEntered()
            }
          }
          onTryLastBox: {
            if (index === 0) {
              pinEntryRow.resetPinEntry()
            } else {
              pinEntryBoxes.itemAt(index).focus = false
              pinEntryBoxes.itemAt(index - 1).focus = true
              clear()
            }
          }
          onHasChanged: pinEntryRow.checkPinEntered()
        }
      }
    }//end 'pinEntryRow'
  }//end 'pinVerification'

  //-----------------------------------------------------------------------------
  // success unlock animation:
  LottieAnimation {
    id: assetUnlockedAnimation
    source: "qrc:/assets/dash/unlock.json"
    width: 320
    height: width
    loops: 0
    running: false
    visible: (contextRoot.needPin === true)
    fillMode: Image.PreserveAspectFit
    anchors.horizontalCenter: parent.horizontalCenter
    // called when done animating
    onFinished: {
      unlockedFinishTimer.start()
    }
    // wait before next trigger
    Timer {
      id: unlockedFinishTimer
      interval: 300
      running: false
      onTriggered: {
        if (syncTimer) {
          UIUX_UserCache.hasEnteredPassRecently(true)
        }
        contextRoot.needPin = false
        contextRoot.pinCorrectlyEntered()
      }
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'