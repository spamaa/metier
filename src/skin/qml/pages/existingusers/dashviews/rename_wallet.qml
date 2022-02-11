import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/rename_wallet.qml"
// User is re-nameing their wallet, Changing nyms.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Rename Wallet.")
	objectName: "dashboard_rename_wallet"
	background: null //Qt.transparent

  // Called when its time to apply the new wallet nym:
  function saveChanges() {
    console.log("Wallet's new name:", newNymInputText.text)
  
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
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
      id: sendCancelButton
      x: parent.width - width - DawgsStyle.horizontalMargin
      width: 52
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
      text: qsTr("Rename wallet")
      font.pixelSize: DawgsStyle.fsize_accent
      font.weight: Font.DemiBold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    // input new wallet nym textfield:
    Dawgs_TextField {
      id: newNymInputText
      width: parent.width
      height: 56
      placeholderText: "Wallet name here..."
    }

    Text {
      id: desctiptionOfUseText
      text: qsTr("People will see this name when transacting with this wallet in any wallet compatible with MatterCodes™.")
      color: DawgsStyle.font_color
      lineHeight: 1.4 
      font.pixelSize: 11 //DawgsStyle.fsize_contex + 1
      font.weight: Font.DemiBold
      width: newNymInputText.width
      wrapMode: Text.Wrap
    }

	}//end 'body'

  Dawgs_Button {
    topPadding: 18
    displayText: qsTr("Save")
    enabled: (newNymInputText.text.length > 0)
    buttonType: "Active"
    onClicked: dashViewRoot.saveChanges()
    y: dashViewRoot.height - height - DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter
  }
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'