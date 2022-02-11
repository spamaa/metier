import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/add_token.qml"
// Allows the user to add additional blockchains to their wallet.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Add Token.")
	objectName: "dashboard_add_token"
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
    spacing: DawgsStyle.verticalMargin
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
			displayText: qsTr("cancel")
			onClicked: pageRoot.popDash()
		}

    //----------------------
    Dawgs_CenteredTitle {
      id: centerTitle
      textTitle: qsTr("Add Token")
    }

    //TODO: OT-13 Add new crypto-currency support

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'