import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/hardware_tapit.qml"
// Ask the user to scan their NFC complient device and card.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("hardware_tapit")
	objectName: "a_card_ofmany"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonBack() {
    pageRoot.popCard()
  }

  function onNextButton() {  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      visible: false
    }
    pageRoot.setActionFooter(props)
  }

	//-----------------------------------------------------------------------------
  // Main 'body' display container.
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    clip: true
    spacing: 8
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("tap it!")
      titleText: qsTr("Tap your spacecard to the device")
      visible: (DawgsStyle.has_nfc_device)
    }
    Dawgs_AccentTitle {
      accentText: qsTr("no NFC device")
      titleText: qsTr("NFC services have not been found.")
      visible: (!DawgsStyle.has_nfc_device)
    }

    LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/cards/tapit.json"
			width:  parent.width
      height: 300
      speed: 1.0
			loops: Animation.Infinite
      visible: (DawgsStyle.has_nfc_device)
			running: visible
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}
    
    // get true bottom screen location
    function bottomY() {
      return body.y + body.height - (DawgsStyle.verticalMargin * 2)
    }
	}//end 'body'

  //-----------------------------------------------------------------------------
  // Font icon as back button:
  FontIconButton {
    id: goBackButton
    iconChar: IconIndex.sd_close
    fontFamilyName: Fonts.icons_spacedawgs
    y: body.bottomY()
    opacity: 0.0
    anchors.horizontalCenter: parent.horizontalCenter
    // when clicked on:
    onAction: {
      cardDeligateRoot.onButtonBack()
    }
    // Apperance animation for goBackButton
    ParallelAnimation {
      id: backIconAnimation
      running: false
      YAnimator { target: goBackButton
        from: body.bottomY() + 40;	to: body.bottomY(); duration: 400;
        easing.type: Easing.OutBack
      }
      OpacityAnimator { target: goBackButton
        from: 0.0; to: 1.0;	duration: 400;
        easing.type: Easing.OutBack
      }
    }//end 'backIconAnimation'
    Timer {
      id: cardBgAppearTimer
      interval: 500
      running: true
      onTriggered: {
        backIconAnimation.running = true
      }
    }
  }

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'