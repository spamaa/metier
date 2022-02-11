import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/link_spacecard.qml"
// Links NFC device to provide user a 'hard'ware wallet upgrade.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Link Spacecard.")
	objectName: "dashboard_link_spacecard"
	background: null //Qt.transparent

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //----------------------
  // Prompt user to enter pin to continue.
  MatterFi_PinWall {
    id: promptToEnterPin
    syncTimer: false // always ask for pin to continue
    anchors.horizontalCenter: parent.horizontalCenter
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 2)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin
    visible: (!promptToEnterPin.needPin)
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      opacity: 0.4
      x: parent.width - DawgsStyle.horizontalMargin - width
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("close")
			onClicked: pageRoot.popDash()
		}

    //----------------------
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

    //----------------------
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

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'