import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/nym_restore.qml"
// Provides user flow for restoring additional wallet identities for individual
// asset management between user's blockchain identities.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Restore Nym.")
	objectName: "dashboard_nym_restore"
	background: null //Qt.transparent

  // Listen for OT setup signal is finished importing mnemonic wallet phrase.
  function otsignalDisplayNamePrompt() {
    //debugger:
    console.log("New seed needs a profile name claim now.")
  }

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 2)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin / 3
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Row {
      topPadding: DawgsStyle.verticalMargin
      width: parent.width
      spacing: width - navBackButton.width - accentTitle.width
      
      // Title:
      Dawgs_AccentTitle {
        id: accentTitle
        accentText: qsTr("recover wallet")
        titleText: qsTr("Enter seed phrase")
      }

      Dawgs_Button {
        id: navBackButton
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
    }

    // Recovery options and enter words:
    ScrollView {
      id: scrollSeedWordView
      width: parent.width
      height: parent.height * 0.70
      contentWidth: nymRecoveryView.width
      contentHeight: nymRecoveryView.height
      clip: true
      ScrollBar.horizontal.interactive: false
      ScrollBar.vertical.interactive: true
      ScrollBar.horizontal.policy: ScrollBar.AsNeeded
      ScrollBar.vertical.policy: ScrollBar.AlwaysOn

      MatterFI_NymRecoveryView {
        id: nymRecoveryView
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }

    // Name the new nym being created:
    Dawgs_TextField {
      id: walletNameInputText
      placeholderText: "Enter identity here..."
      canClickOffClose: true
      anchors.horizontalCenter: parent.horizontalCenter
    }

    // Next step button:
    Dawgs_Button {
      topPadding: 18
      displayText: qsTr("Restore Nym")
      buttonType: "Active"
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: {
        console.log("New creating identity:", walletNameInputText.text)
      }
    }

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'