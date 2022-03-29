import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/finalsteps/enterpin.qml"
// Prompt user for a new pin or to verify an existing pin for a wallet.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Create new pin")
	objectName: "enter_wallet_pin"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {
    
  }

  function onButtonNext() {
    pageRoot.pushCard("qrc:/boarding_cards/finalsteps/namewallet.qml")
  }

  function onButtonBack() {
    if (pinEntryRow.lastpin !== "") {
      // start over
      pinEntryRow.resetPinEntry()
    } else {
      // nav cards back one
      pageRoot.popCard()
    }
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: "",
      buttonTypeOne: "Secondary",
      buttonIconOne: "",
      buttonTextTwo: qsTr("next"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.sd_chevron_right,
      fontIconTwo: Fonts.icons_spacedawgs,
      buttonTwoEnabled: false
    }
    pageRoot.setActionFooter(props)
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    //clip: true
    spacing: 8
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      titleText:  (pinEntryRow.lastpin !== "" ? qsTr("Confirm pin code") : qsTr("Set a pin code"))
      accentText: (pinEntryRow.lastpin !== "" ? qsTr("one more time") : qsTr("secure your wallet"))
    }

    // Create entry for pin numbers:
    Row {
      id: pinEntryRow
      spacing: (pinEntryRow.pinLength === 6 ? 3 : 8)
      anchors.horizontalCenter: parent.horizontalCenter

      property string userpin: ""
      property string lastpin: ""
      function getPinEntered() {
        var pinString = ""
        for (var i = 0; i < pinEntryRow.pinLength; i++) {
          pinString += pinEntryBoxes.itemAt(i).text
        }
        return pinString
      }
      // Clears current display but holds onto last entry pin for compairing
      function clearPinBoxes() {
        for (var i = 0; i < pinEntryRow.pinLength; i++) {
         pinEntryBoxes.itemAt(i).replayAppearnceAnimation()
        }
        pinEntryRow.userpin = pinEntryRow.getPinEntered()
        pageRoot.setActionFooter({ buttonTwoEnabled: false })
      }
      // resets everything
      function resetPinEntry() {
        pinEntryRow.lastpin = ""
        pinEntryRow.clearPinBoxes()
      }
      // draw the pin boxes:
      property int pinLength: (pinLengthModeConfig.pinLengthMode)
      Repeater {
        id: pinEntryBoxes
        model: (pinEntryRow.pinLength)
        Dawgs_PinNumBox {
          display_index: index + 1
          pin_count: pinEntryRow.pinLength
          onTryNextBox: {
            pinEntryRow.userpin = pinEntryRow.getPinEntered()
            pinEntryBoxes.itemAt(index).focus = false
            if (index < pinEntryRow.pinLength - 1) {
              pinEntryBoxes.itemAt(index + 1).focus = true
            } else {
              if (pinEntryRow.lastpin === "") {
                if (pinEntryRow.userpin.length === pinEntryRow.pinLength) {
                  pinEntryRow.lastpin = pinEntryRow.userpin
                }
                pinEntryRow.clearPinBoxes()
                pinEntryBoxes.itemAt(0).focus = true
              } else if (pinEntryRow.lastpin === pinEntryRow.userpin) {
                pageRoot.setActionFooter({ buttonTwoEnabled: true })
              }
            }
          }
          onTryLastBox: {
            if (index === 0) {
              if (pinEntryRow.lastpin !== "") {
                pinEntryRow.resetPinEntry()
              }
            } else {
              pinEntryBoxes.itemAt(index).focus = false
              pinEntryBoxes.itemAt(index - 1).focus = true
              clear()
            }
          }
          onHasChanged: pinEntryRow.userpin = pinEntryRow.getPinEntered()
        }
      }
    }//end 'pinEntryRow'
    
    Rectangle {
      id: pinContextStatusSpacer
      width: parent.width
      height: 2
      color: "transparent"
    }

    // please enter again confirmation text:
    Rectangle {
      visible: (pinEntryRow.lastpin.length === pinEntryRow.pinLength && 
        !(pinEntryRow.lastpin.length + pinEntryRow.userpin.length === pinEntryRow.pinLength * 2)
      );
      implicitWidth: body.width - (DawgsStyle.horizontalMargin * 2)
      implicitHeight: 36
      color: DawgsStyle.buts_active
      radius: 8
      border.color: DawgsStyle.aa_norm_ol
      border.width: 1
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        text: qsTr("confirm pin")
        color: DawgsStyle.alert_txt
        font.pixelSize: DawgsStyle.fsize_button
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    // Confirmation display of pin entry:
    Rectangle {
      id: pinConfirmStatus
      visible: (pinEntryRow.userpin.length > 0 && (pinEntryRow.lastpin.length + 
        pinEntryRow.userpin.length === (pinEntryRow.pinLength * 2)
      ));
      implicitWidth: body.width - (DawgsStyle.horizontalMargin * 2)
      implicitHeight: 36
      color: (pinEntryRow.lastpin === pinEntryRow.userpin ? DawgsStyle.aa_selected_bg : DawgsStyle.alert_bg)
      radius: 6
      border.color: (pinEntryRow.lastpin === pinEntryRow.userpin ? DawgsStyle.aa_selected_ol : DawgsStyle.alert_ol)
      border.width: 1
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        text: (pinEntryRow.lastpin === pinEntryRow.userpin ? qsTr("Pins match") : qsTr("Pins don't match"))
        color: DawgsStyle.alert_txt
        font.pixelSize: DawgsStyle.fsize_button
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    Dawgs_PinLenSwitch {
      id: pinLengthModeConfig
      y: (pinConfirmStatus.visible ? pinConfirmStatus.y : pinConfirmStatus.y + pinConfirmStatus.height)
      anchors.horizontalCenter: parent.horizontalCenter
      onLengthChanged: {
        pinEntryRow.resetPinEntry()
      }
    }

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'