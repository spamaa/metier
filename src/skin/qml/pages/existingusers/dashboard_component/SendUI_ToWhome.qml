import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// SendUI_ToWhome.qml
// Provides a selection Component for Contacts and Recent transaction addresses.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: parent.height

  signal toNextStep() // called when ready for next step.

  //----------------------
  // On creation, populate quick send with contacts list to start with:
  Component.onCompleted: {
    // sending via contact ActivityThread
    if (dashViewRoot.sendtoContactID !== "") {
      //debugger:
      console.log("SendUI_ToWhome using contact ID:", dashViewRoot.sendtoContactID)
      contextRoot.toNextStep()
    } else {
      // default unless provided a MatterCode to auto fill TextField
      OTidentity.checkContacts()
      quicksendListView.model = OTidentity.contactList_OTModel
      if (dashViewRoot.sendtoAddressID.length > 0) {
        addressInputText.text = dashViewRoot.sendtoAddressID
        //debugger:
        console.log("SendUI_ToWhome using MatterCode provided:", addressInputText.text)
      }
    }
  }

  //----------------------
  // Called to reset send entry target:
  function resetEntry() {
    addressInputText.clear()
    addressTextTools.paste_mode = true
    quickSendCodesButtonGroup.selected_item = ""
    quickSendCodesButtonGroup.checkState = Qt.Unchecked
    dashViewRoot.sendtoAddressID = ""
    dashViewRoot.sendtoContactID = ""
    dashViewRoot.matterCodeIsValid = false
    //debugger:
    //console.log("Address field and contact selection cleared.")
  }

  //-----------------------------------------------------------------------------
  Column {
    id: body
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: contextRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
      id: sendCancelButton
      x: parent.width - width
      width: 60
      opacity: 0.4
      justText: true
      iconLeft: true
      manualWidth: true
      fontIcon: IconIndex.fa_chevron_left
      fontFamily: Fonts.icons_solid
      buttonType: "Plain"
      displayText: qsTr("cancel")
      onClicked: pageRoot.popDash()
    }

    Text {
      text: qsTr("Send to")
      font.pixelSize: DawgsStyle.fsize_title
      font.weight: Font.DemiBold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    Rectangle {
      id: sendWhereRow
      width: parent.width
      height: addressInputText.height
      color: "transparent"
      // input MatterCode™ or blockchaim public address textfield:
      Dawgs_TextField {
        id: addressInputText
        width: parent.width
        placeholderText: "MatterCode™ or public address"
        maximumLength: 256
        rightPadding: (qrScanButton.visible ? qrScanButton.width : 4)
        onTextChanged: {
          if (addressInputText.text !== dashViewRoot.sendtoAddressID) {
            if (quickSendCodesButtonGroup.checkedButton !== null) {
              quickSendCodesButtonGroup.checkedButton.checked = false
            }
          }
          if (text.length > 0) {
            addressTextTools.paste_mode = false
          } else {
            addressTextTools.paste_mode = true
          }
          // validate sending address from OT AccountActivity model.
          if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
            var is_valid = OTidentity.focusedAccountActivity_OTModel.validateAddress(addressInputText.text)
            dashViewRoot.matterCodeIsValid = is_valid
            if (is_valid) {
              dashViewRoot.sendtoAddressID = addressInputText.text
            } else {
              dashViewRoot.sendtoAddressID = ""
            }
            //debugger:
            //console.log("SendUI_ToWhome: Address was validated, it was", is_valid, dashViewRoot.sendtoAddressID)
          } else {
            // error net
            console.log("Error: SendUI_ToWhome sees no focused AccountActivity_OTModel.")
          }
        }
        // Display Alert when pasting text.
        Dawgs_Alert {
          id: addressPastedAlert
          text: addressInputText.text
          smallMode: true
          // Display for a period of time?
          Timer {
            id: textPastedAlertTimer
            interval: 3000
            running: false
            onTriggered: {
              addressPastedAlert.visible = false
            }
          }
        }
      }
      // open device QR scaner:
      Dawgs_TranslucentButton {
        id: qrScanButton
        fontIcon: IconIndex.sd_qr
        height: parent.height
        width: height - 2
        visible: (addressInputText.focus === false && DawgsStyle.has_qrCode_scanner)
        enabled: DawgsStyle.has_qrCode_scanner
        anchors.right: parent.right
        onClicked: {
          // TODO: open device qr scaner if it has one
          console.log("WIP: open qrcode scaner.")
        }
      }
    }//end 'sendWhereRow'

    Dawgs_TranslucentButton {
      id: addressTextTools
      property bool paste_mode: true
      width: 164
      displayText: (paste_mode ? qsTr("Paste from clipboard") : qsTr("Clear input") );
      onClicked: {
        if (paste_mode) {
          contextRoot.resetEntry()
          addressInputText.paste()
          if (addressInputText.length > 0) {
            // after pasting text, use the AccountActivity for the asset performing the transaction
            // to validate the address is correct or not.
            if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
              var is_valid = OTidentity.focusedAccountActivity_OTModel.validateAddress(dashViewRoot.sendtoAddressID)
              dashViewRoot.matterCodeIsValid = is_valid
              //debugger:
              console.log("SendUI_ToWhome: Address was validated, it was", is_valid, dashViewRoot.sendtoAddressID)
              if (is_valid) {
                dashViewRoot.sendtoAddressID = addressInputText.text
                addressTextTools.paste_mode = false
                addressPastedAlert.text = addressInputText.text
              } else {
                addressPastedAlert.text = "Not a valid address."
                contextRoot.resetEntry()
              }
              textPastedAlertTimer.start()
              addressPastedAlert.visible = true
            } else {
              // error net
              console.log("Error: SendUI_ToWhome sees no focused AccountActivity_OTModel.")
              dashViewRoot.matterCodeIsValid = false
            }
          } else {
            // user error help
            if (addressInputText.illegalPaste) {
              addressPastedAlert.text = "Contains illegal graphemes."
            } else {
              addressPastedAlert.text = "Clipboard empty."
            }
            textPastedAlertTimer.start()
            addressPastedAlert.visible = true
          }
        } else {
          contextRoot.resetEntry()
          addressPastedAlert.visible = false
          dashViewRoot.matterCodeIsValid = false
        }
      }
    }
    // Draw item list line divider:
    Rectangle {
      width: parent.width
      height: 1
      color: DawgsStyle.aa_norm_ol
    }

    //----------------------
    Text {
      text: qsTr("Quick send")
      font.pixelSize: DawgsStyle.fsize_accent
      //font.weight: Font.DemiBold
      height: font.pixelSize + DawgsStyle.verticalMargin
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }
    // Deligate the interactive Tab button group to provide user selections:
    Row {
      id: quicksendTabContextButtons
      height: tabAssets.height
      visible: true // TODO: for now, just contacts. need OT models for multiple nyms and recent
      spacing: 0
      anchors.horizontalCenter: parent.horizontalCenter
      // Set Tab view options:
      Dawgs_TabGroupButton {
        id: tabAssets
        text: qsTr("Contacts")
        textPadding: 16
        checked: true
        ButtonGroup.group: tabDisplayBeltButtonGroup
      }
      Dawgs_TabGroupButton {
        id: tabCollectibles
        text: qsTr("Recent")
        textPadding: 16
        ButtonGroup.group: tabDisplayBeltButtonGroup
      }
      Dawgs_TabGroupButton {
        id: tabActivity
        text: qsTr("My wallets")
        textPadding: 16
        ButtonGroup.group: tabDisplayBeltButtonGroup
      }
    }
    // Manage display updates depending on selection context Tab for viewing associated data.
    ButtonGroup { 
      id: tabDisplayBeltButtonGroup
      exclusive: true
      property var selected_item: tabAssets.text

      onClicked: {
        if (selected_item !== button.text) {
          contextRoot.resetEntry()
          selected_item = button.text
          // when tab option has changed, update quick select list model
          switch (selected_item) {
            case "Contacts":
              quicksendListView.model = OTidentity.contactList_OTModel
              break;
            case "Recent":

              //TODO: request OT recent transaction contacts
              quicksendListView.model = ({})

              break;
            case "My wallets":
              quicksendListView.model = OTidentity.userIdentity_OTModel.getNymListQML()
              break;
            default:
              quicksendListView.model = ({})
          }
        }
      }
    }

    //----------------------
    Rectangle {
      id: quicksendSelectionViewRect
      width: Math.min(360, parent.width)
      height: 280
      color: DawgsStyle.page_bg
      radius: 8
      border.color: DawgsStyle.aa_selected_ol
      border.width: 1
      anchors.horizontalCenter: parent.horizontalCenter
      // quick send selection group
      ButtonGroup {
        id: quickSendCodesButtonGroup
        exclusive: true
        property var selected_item: (dashViewRoot.sendtoContactID)
        /*
        onClicked: {
          //debugger:
          for (let i = 0; i < 5; i++) {
            let checked = quickSendCodesButtonGroup.buttons[i].checked
            console.log("Contacts checked", i, checked)
          }
        }
        */
      }//end 'quickSendCodesButtonGroup'

      // quick item deligation:
      Component {
        id: accountListModelDelegator
        // quick send entry:
        Row {
          id: deligateRoot
          width: quicksendSelectionViewRect.width - 24
          visible: (index !== 0)
          height: (visible ? 64 : 0)
          anchors.horizontalCenter: parent.horizontalCenter
          // Image displayed
          Dawgs_Avatar {
            id: quicksendContextAvatar
            height: parent.height - DawgsStyle.verticalMargin - 6
            width:  height
            avatarUrl: (model.image !== undefined ? model.image : "")
            contactID: model.id
            visible: (model.id.length > 0)
            anchors.verticalCenter: parent.verticalCenter
          }
          // Name, and transaction count
          Column {
            id: descriptiveTextColumn
            width: parent.width - quicksendContextAvatar.width - checkToSendButton.width
            height: quicksendContextAvatar.height - 8
            spacing: 0
            leftPadding: 12
            rightPadding: parent.width - width - tabCollectibles.width
            anchors.verticalCenter: parent.verticalCenter

            Text {
              text: (model.name.length > 18 ? model.name.slice(0, 18) + "..." : model.name)
              color: DawgsStyle.font_color
              height: parent.height / 2
              font.pixelSize: DawgsStyle.fsize_accent
              font.family: Fonts.font_HindVadodara_semibold
              font.weight: Font.DemiBold
            }
            Text {
              text: "nil transaction(s)" //TODO: bugzilla#294
              visible: false
              
              color: DawgsStyle.text_descrip
              height: parent.height / 2
              font.pixelSize: DawgsStyle.fsize_lable
              font.family: Fonts.font_HindVadodara_semibold
              font.weight: Font.DemiBold
            }
          }
          // select send to this MatterCode quick send box
          Dawgs_RadioButton {
            id: checkToSendButton
            width: 32
            enabled: (deligateRoot.visible)
            onlyBox: true
            anchors.verticalCenter: parent.verticalCenter
            ButtonGroup.group: quickSendCodesButtonGroup

            onToggled: {
              if (checkToSendButton.checked) {
                // is a new/diffrent contact selection
                if (quickSendCodesButtonGroup.selected_item !== model.id) {
                  contextRoot.resetEntry()
                  quickSendCodesButtonGroup.selected_item = model.id
                  dashViewRoot.sendtoContactID = model.id
                  checkToSendButton.checked = true
                  addressTextTools.paste_mode = false
                }
                //debugger:
                console.log("Sending via contact model ID.", dashViewRoot.sendtoContactID)
              } else {
                contextRoot.resetEntry()
              }
            }
          }
        }//end 'deligateRoot'
      }//end 'accountListModelDelegator'

      ListView {
        id: quicksendListView
        width: quicksendSelectionViewRect.width
        height: quicksendSelectionViewRect.height
        clip: true
        model: ({})
        delegate: accountListModelDelegator
        anchors.horizontalCenter: parent.horizontalCenter
      }
      // mange quick send selection list:
      ButtonGroup { 
        id: quickSelectButtonGroup
        exclusive: true // allow only one
        property var selected_item: ({})

        onClicked: {
          if (selected_item !== button.text) {
            selected_item = button.text
          }
        }
      }
    }//end 'quicksendSelectionViewRect'
  }//end 'body'

  //-----------------------------------------------------------------------------
  // Footer button:
  Dawgs_Button {
    id: nextStepButton
    displayText: qsTr("Next")
    buttonType: "Active"
    enabled: (dashViewRoot.matterCodeIsValid || dashViewRoot.sendtoContactID !== "")

    anchors {
      bottom: parent.bottom;
      bottomMargin: DawgsStyle.verticalMargin * 2;
      horizontalCenter: parent.horizontalCenter;
    }

    onClicked: {
      // If using contact id for ActivityThread
      if (dashViewRoot.sendtoContactID !== "") {
        console.log("Sending transaction via contact:", dashViewRoot.sendtoContactID)
      // ensure that the entered address is valid before proceeding
      } else if (dashViewRoot.matterCodeIsValid === false) {
        console.log("A valid MatterCode is required to procceed.", dashViewRoot.sendtoAddressID)
        return
      }
      contextRoot.toNextStep()
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'