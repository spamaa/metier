import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/recover/ask_hardorsoft.qml"
// User has chosen to recover a wallet.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Descriptive Title Shown")
	objectName: "object_identity_tracing_assitant"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {
    // user said they have a spacecard?
    if (yesnoToggler.selectedIndex == 0) {
      pageRoot.pushCard("qrc:/boarding_cards/recover_hard/ask_hascard.qml")
    } else { // no
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
      buttonOneEnabled: true,
      buttonTextTwo: qsTr("next"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.sd_chevron_right,
      fontIconTwo: Fonts.icons_spacedawgs,
      buttonTwoEnabled: (yesnoToggler.selectedIndex !== -1)
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
    spacing: 32
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("let's get that back for you")
      titleText: qsTr("Are you restoring a spacecard?")
    }

    Dawgs_YesNoToggle {
      id: yesnoToggler
      onToggled: {
        var props = {
          buttonTwoEnabled: true
        }
        pageRoot.setActionFooter(props)
      }
    }

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'