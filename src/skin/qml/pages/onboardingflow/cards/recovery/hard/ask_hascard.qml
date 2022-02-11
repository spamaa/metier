import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/recover_hard/ask_hascard.qml"
// User is recovering a hardware wallet using a physical NFC compliant card.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Recoverying hard wallet")
	objectName: "object_identity_tracing_assitant"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {
    if (radiogroup.selected_item === "Yes") {
      pageRoot.pushCard("qrc:/boarding_cards/hardware_tapit.qml")
    } else if (radiogroup.selected_item === "No") {
      pageRoot.pushCard("qrc:/boarding_cards/recover_soft/enter_seedphrase.qml")
    }
  }

  function onButtonBack() {
    pageRoot.popCard()
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: qsTr("back"),
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
    clip: true
    spacing: 12
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("got plastic?")
      titleText: qsTr("Do you have the <b>spacecard</b>?")
    }

    // Radio Button Group:
    ButtonGroup { 
      id: radiogroup
      exclusive: true
      property var selected_item: null
      onClicked: {
        if (selected_item !== button.text) {
          radiogroup.selected_item = button.text
          pageRoot.setActionFooter({ buttonTwoEnabled: true })
        } else {
          button.checked = false
          radiogroup.selected_item = null
          pageRoot.setActionFooter({ buttonTwoEnabled: false })
        }
      }
    }
    // Radio button options
    Column {
      id: radioButtonColumn
      width: parent.width
      spacing: 16

      Dawgs_RadioButton {
        id: firstRadioButton
        text: qsTr("Yes")
        accentText: qsTr("I got it, conneted to device")
        ButtonGroup.group: radiogroup
      }

      Dawgs_RadioButton {
        text: qsTr("No")
        accentText: qsTr("I lost it, recover to softwallet")
        ButtonGroup.group: radiogroup
      }
    }

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'