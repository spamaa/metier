import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/welcome.qml"
// Step 1 'Welcome' card for on boarding flow.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Welcome")
	objectName: "welcome_first_card"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {
    // user said they have a spacecard?
    if (yesnoToggler.selectedIndex == 0) {
      pageRoot.pushCard("qrc:/boarding_cards/hardware_tapit.qml")
    } else { // no
      pageRoot.pushCard("qrc:/boarding_cards/softwallet/surrounding_warn.qml")
    }
  }

  function onButtonBack() {  }

  function onNextButton() {  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: qsTr("next"),
      buttonTypeOne: "Active",
      buttonIconOne: IconIndex.sd_chevron_right,
      buttonOneEnabled: (yesnoToggler.selectedIndex !== -1),
      buttonTextTwo: "",
      singleButtonAlign: Qt.AlignRight
    }
    pageRoot.setActionFooter(props)
    importWalletInsteadButton.opacity = 0.0
    cardBgAppearTimer.start()
  }

	//-----------------------------------------------------------------------------
  // Main 'body' display container.
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    clip: true
    spacing: 16
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("welcome")
      titleText: qsTr("Do you have a spacecard?")
    }

    LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/cards/spacecard.json"
			width:  312
      height: 164
      speed: 0.35
			loops: 0 // Animation.Infinite
			running: true
			//fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}

    Dawgs_YesNoToggle {
      id: yesnoToggler
      onToggled: {
        var props = {
          buttonOneEnabled: true
        }
        pageRoot.setActionFooter(props)
      }
    }

    // get true bottom screen location
    function bottomY() {
      return DawgsStyle.verticalMargin * 2 + y + height
    }
	}//end 'body'

  //-----------------------------------------------------------------------------
  // Importing a wallet instead cards flow.
  Dawgs_TextButton {
    id: importWalletInsteadButton
    opacity: 0.0
    text_name: qsTr("wallet recovery")
    qrc_url: "qrc:/boarding_cards/recover/ask_hardorsoft.qml"
    onLinkActivated: pageRoot.pushCard(qrc_url)
    anchors.horizontalCenter: parent.horizontalCenter
    // Apperance animation for hyperlink text
    ParallelAnimation {
      id: linkAppearAnimation
      running: false
      YAnimator { target: importWalletInsteadButton
        from: body.bottomY() + 40;	to: body.bottomY(); duration: 400;
        easing.type: Easing.OutBack
      }
      OpacityAnimator { target: importWalletInsteadButton
        from: 0.0; to: 1.0;	duration: 400;
        easing.type: Easing.OutBack
      }
    }//end 'linkAppearAnimation'
    Timer {
      id: cardBgAppearTimer
      interval: 800
      running: true
      onTriggered: {
        linkAppearAnimation.running = true
      }
    }
  }//end 'importWalletInsteadButton'

  //-----------------------------------------------------------------------------
  // Conext help interaction icon with popup for information details.
  Dawgs_ContextualHelp {
    id: contextualHelp
    x: body.width - DawgsStyle.horizontalMargin + 2
    y: 2
    animateToScreenRight: false
    text: qsTr("A spacecard is like a credit card with the Spacedawgs logo on the back and offers an extra layer of security to your wallet.")
  }//end 'callHelpText'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'