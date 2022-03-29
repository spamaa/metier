import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/create_contact.qml"
// Allows the user to add another's MatterFi payment code to their Contacts.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Create Contact.")
	objectName: "dashboard_create_contact"
	background: null //Qt.transparent

  // Called when its time to use a MatterCode™ to create new contact:
  property bool creationSuccess: false
  function createNewContact() {
    // TODO: need text field for contact's name, unless value from blockchain is resolved.
    var contact_name = contactNameInputText.text // "default"

    //debugger:
    console.log("New contact with MatterCode™", contact_name, addressInputText.text)

    //TODO: how to validate an address for any blockchain in the wallet with out using
    // a single focused AccountActivity model.
    if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
      var addressValid = OTidentity.focusedAccountActivity_OTModel.validateAddress(addressInputText.text)
    } else {
      //TODO Issue:
      consol.log("Error: no active focused AccountActivity model to perform validation on text.")
      return
    }
    if (addressValid) {
      //debuger:
      console.log("Adding Contact into the List:", contact_name, addressInputText.text)
      // update the contact list model
      OTidentity.checkContacts()
      var fetchedContactList = OTidentity.contactList_OTModel
      fetchedContactList.addContact(contact_name, addressInputText.text)
      dashViewRoot.creationSuccess = true
      //debuger:
      console.log("New contact was added.")
    } else {
      console.log("Error: New Contact address is not valid.", addressInputText.text)
    }
  }

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //-----------------------------------------------------------------------------
  // New contact creation success message:
  Column {
		id: successBody
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    visible: (dashViewRoot.creationSuccess)
    clip: false
    spacing: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_Button {
      id: successCloseButton
      x: parent.width - width
      width: 52
      opacity: 0.4
      justText: true
      iconLeft: true
      manualWidth: true
      fontIcon: IconIndex.fa_chevron_left
      fontFamily: Fonts.icons_solid
      buttonType: "Plain"
      displayText: qsTr("close")
      onClicked: pageRoot.popDash()
    }

    Dawgs_CenteredTitle {
      textTitle: qsTr("Contact added")
    }

    LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/cards/success.json"
      height: 240
			width:  parent.width
      speed: 1.0
			loops: 0
			running: (successBody.visible)
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}//end 'successBody'


  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin
    visible: (dashViewRoot.creationSuccess === false)
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
      id: sendCancelButton
      x: parent.width - width
      width: 52
      opacity: 0.4
      justText: true
      iconLeft: true
      manualWidth: true
      fontIcon: IconIndex.fa_chevron_left
      fontFamily: Fonts.icons_solid
      buttonType: "Plain"
      displayText: qsTr("close")
      onClicked: pageRoot.popDash()
    }

    Text {
      text: qsTr("Add contact")
      font.pixelSize: DawgsStyle.fsize_accent
      font.weight: Font.Bold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    Rectangle {
      id: contactAddressRow
      width: parent.width
      height: addressInputText.height
      color: "transparent"
      // input MatterCode™ or blockchaim public address textfield:
      Dawgs_TextField {
        id: addressInputText
        width: parent.width
        maximumLength: 128
        rightPadding: (qrScanButton.visible ? qrScanButton.width : 4)
        placeholderText: qsTr("Mattercode™ or public address")
        canClickOffClose: false
        onTextChanged: {
          //console.log("addressInputText is:", text)
          if (text.length > 0) {
            addressTextTools.paste_mode = false
          } else {
            addressTextTools.paste_mode = true
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
    }//end 'contactAddressRow'

    Dawgs_TranslucentButton {
      id: addressTextTools
      property bool paste_mode: true
      width: 164
      displayText: (paste_mode ? qsTr("Paste from clipboard") : qsTr("Clear input") );
      onClicked: {
        if (paste_mode) {
          addressInputText.paste()
          if (addressInputText.text.length > 0) {
            addressTextTools.paste_mode = false
          }
        } else {
          addressInputText.clear()
          addressTextTools.paste_mode = true
        }
      }
    }
    
    // spacer:
    Rectangle {
      width: parent.width
      height: 24
      color: "transparent"
    }
    // Name entry field:
    Dawgs_TextField {
      id: contactNameInputText
      width: parent.width
      canClickOffClose: false
      placeholderText: qsTr("Contacts's name")
    }

	}//end 'body'

  //-----------------------------------------------------------------------------
  Dawgs_Button {
    topPadding: 18
    displayText: qsTr("Add")
    visible: (dashViewRoot.creationSuccess === false)
    enabled: (addressInputText.text.length > 0 && contactNameInputText.text.length > 0)
    buttonType: "Active"
    y: dashViewRoot.height - height - DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked: dashViewRoot.createNewContact()
  }

  Dawgs_Button {
    topPadding: 18
    displayText: qsTr("Done")
    visible: (dashViewRoot.creationSuccess)
    buttonType: "Active"
    y: dashViewRoot.height - height - DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked: {
      pageRoot.popDash()
    }
  }

//-----------------------------------------------------------------------------
}//end 'dashViewRoot'