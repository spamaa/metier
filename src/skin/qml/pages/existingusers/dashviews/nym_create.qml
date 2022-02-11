import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/nym_create.qml"
// Creating an additional wallet identity for individual asset management 
// between user's blockchain identities with in the wallet.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Create Nym.")
	objectName: "dashboard_nym_create"
	background: null //Qt.transparent

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
    spacing: DawgsStyle.verticalMargin / 2
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

    // Title:
    Dawgs_AccentTitle {
      accentText: qsTr("Write this down")
      titleText: qsTr("New seed phrase")
    }

    // Generate a new seed before accepting and starting creation:
    ScrollView {
      id: scrollSeedWordView
      width: parent.width
      height: parent.height * 0.60
      contentWidth: newNymSeedView.width
      contentHeight: newNymSeedView.height
      clip: true
      ScrollBar.horizontal.interactive: false
      ScrollBar.vertical.interactive: true
      ScrollBar.horizontal.policy: ScrollBar.AsNeeded
      ScrollBar.vertical.policy: ScrollBar.AlwaysOn

      MatterFI_NymNewSeedView {
        id: newNymSeedView
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }

    // Name the new nym being created:
    Dawgs_TextField {
      id: walletNameInputText
      placeholderText: "New identity here..."
      canClickOffClose: true
      anchors.horizontalCenter: parent.horizontalCenter
    }

    // Name the wallet:
    Dawgs_Button {
      topPadding: 18
      displayText: qsTr("Create Nym")
      buttonType: "Active"
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: {
        console.log("New creating identity:", walletNameInputText.text)
        // accept words
        //api.seedBackupFinished()

        //TODO: how would the nym profile name work for new generations
        // Creating a new nym from OT SeedTree model and importing existing
        // to be managed by the wallet.
      }
    }

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'