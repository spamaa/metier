import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/lost_spacecard.qml"
// Display details on how to convert hard wallet into soft wallet.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Lost Spacecard.")
	objectName: "dashboard_lost_spacecard"
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
      x: parent.width - DawgsStyle.horizontalMargin - width
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

    //----------------------
    Dawgs_CenteredTitle {
      id: centerTitle
      textTitle: qsTr("Lost spacecard, Hard to Soft.")
    }

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'