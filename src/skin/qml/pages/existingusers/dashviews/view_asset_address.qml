import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/view_asset_address.qml"
// Display the receive address of current focused wallet asset.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Asset Receive Address.")
	objectName: "dashboard_asset_view_address"
	background: null //Qt.transparent

  property var activityModel_OT: undefined // OT AccountActivityQt
  property string userPaymentCode: ""      // Address string to display
  property bool is_legacy: true            // is a legacy address or MatterCode™

	//----------------------
	Component.onCompleted: {
    // get a pointer to focused activty
		dashViewRoot.activityModel_OT = OTidentity.focusedAccountActivity_OTModel
    // set icon
    blockChainIcon.depositChains = dashViewRoot.activityModel_OT.depositChains
    blockChainIcon.setIconFile()
    // set the address type
    //dashViewRoot.setDisplayAddress(true)
    dashViewRoot.userPaymentCode = dashViewRoot.activityModel_OT.getDepositAddress()
    assetQRcodeImage.set_display_string(dashViewRoot.userPaymentCode)
		// debugger:
		//console.log("Activity Details: ", dashViewRoot.activityModel_OT)
		//QML_Debugger.listEverything(dashViewRoot.activityModel_OT)
	}

  function setDisplayAddress(legacy_address = false) {
    dashViewRoot.is_legacy = legacy_address
    animateSwapTimer.restart()
    interactionTimeOut.restart()
    //debugger:
    //console.log("swapping display modes.", dashViewRoot.is_legacy)
  }
  // Provide a wait time between interactions after animating.
  Timer {
    id: animateSwapTimer
    interval: 400
    running: false
    onTriggered: {
      if (dashViewRoot.is_legacy === true) {
        dashViewRoot.userPaymentCode = dashViewRoot.activityModel_OT.getDepositAddress()
      } else {// is for MatterCode™
        dashViewRoot.userPaymentCode = OTidentity.profile_OTModel.paymentCode
      }
      assetQRcodeImage.set_display_string(dashViewRoot.userPaymentCode)
      //debugge:
      //console.log("Asset view timer over.", dashViewRoot.is_legacy, running)
    }
  }
  // prevent changing display type while animating
  Timer {
    id: interactionTimeOut
    interval: 600
    running: false
    onTriggered: {
      animateSwapTimer.running = false
      qrcodeWithAddressStringColumn.opacity = 1.0
    }
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
			displayText: qsTr("done")
			onClicked: {
        pageRoot.clearDashHome() // return to dashboard root
        //pageRoot.popDash()     // navigate back one page
      }
		}

    //----------------------
    //TODO: include the blockchain notary name. Jira OT-242 AccountActivity notartName
    Dawgs_CenteredTitle {
      id: centerTitle
      textTitle: qsTr("Receive")
    }

    MatterFi_BlockChainIcon {
      id: blockChainIcon
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //TODO:
    // There isn't a way to get the notay name from the activity model.
    /*
    Text {
      id: assetNotaryText
      text: dashViewRoot.activityModel_OT.depositChains
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_normal
      anchors.horizontalCenter: parent.horizontalCenter
    }
    */

    //----------------------
    Column {
      id: qrcodeWithAddressStringColumn
      spacing: parent.spacing
      width: parent.width
      anchors.horizontalCenter: parent.horizontalCenter

      // display asset's address scanable qr code
      MatterFi_QRCodeImage {
        id: assetQRcodeImage
        width: 160
        primaryColor: DawgsStyle.font_color
        anchors.horizontalCenter: parent.horizontalCenter
      }

      MatterFi_PaymentCode {
        id: assetAddressPaymentCode
        primaryColor: DawgsStyle.font_color
        displayLable: "" //qsTr("MatterCode™: ")
        displayText: dashViewRoot.userPaymentCode
        anchors.horizontalCenter: parent.horizontalCenter
      }

      // type swapped animation:
      Behavior on opacity { OpacityAnimator {
				duration: 600
				easing.type: Easing.OutQuint
			}}

      states: [
        State {
          when: animateSwapTimer.running
          PropertyChanges {
            target: qrcodeWithAddressStringColumn
            opacity: 0.0
          }
        }
      ]
    }//end 'qrcodeWithAddressStringColumn'

	}//end 'body'

  //-----------------------------------------------------------------------------
  Column {
    id: footerBody
    width: body.width
    spacing: DawgsStyle.verticalMargin

    anchors {
      horizontalCenter: parent.horizontalCenter;
      bottom: body.bottom;
      bottomMargin: DawgsStyle.verticalMargin * 2
    }

    Text {
      id: methodText
      text: qsTr("Choose method")
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_accent
      verticalAlignment: Text.AlignVCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // Show address display options:
    Row {
      id: footerRow
      spacing: DawgsStyle.horizontalMargin
      width: parent.width
      leftPadding: spacing / 2
      anchors.horizontalCenter: parent.horizontalCenter
      //----------------------
      Button {
        id: mattercodeButton
        width: parent.width / 2 - DawgsStyle.horizontalMargin
        height: 48
        // on action
        onClicked: {
          if (interactionTimeOut.running !== true && dashViewRoot.is_legacy === true) {
            dashViewRoot.setDisplayAddress(false)
          }
        }
        // Draw button Text:
        contentItem: Text {
          id: legacyButText
          text: qsTr("MatterCode™")
          color: DawgsStyle.font_color
          font.pixelSize: DawgsStyle.fsize_accent
          //font.weight: Font.DemiBold
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
        }
        // Draw Button style:
        background: Rectangle {
          color: (dashViewRoot.is_legacy === false ? DawgsStyle.buta_selected : 
            (parent.hovered ? DawgsStyle.aa_hovered_bg : DawgsStyle.aa_selected_bg)
          );
          radius: 2
        }
        // Change cursor to pointing action as configured by root os system.
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.NoButton
          cursorShape: (parent.hovered && dashViewRoot.is_legacy === true ? 
            Qt.PointingHandCursor : Qt.ArrowCursor
          );
        }
      }
      //----------------------
      Button {
        id: legacyButton
        width: mattercodeButton.width
        height: mattercodeButton.height
        // on action
        onClicked: {
          if (interactionTimeOut.running !== true && dashViewRoot.is_legacy === false) {
            dashViewRoot.setDisplayAddress(true)
          }
        }
        // Draw button Text:
        contentItem: Text {
          text: qsTr("Legacy")
          color: DawgsStyle.font_color
          font.pixelSize: DawgsStyle.fsize_accent
          //font.weight: Font.DemiBold
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
        }
        // Draw Button style:
        background: Rectangle {
          color: (dashViewRoot.is_legacy === true ? DawgsStyle.buta_selected : 
            (parent.hovered ? DawgsStyle.aa_hovered_bg : DawgsStyle.aa_selected_bg)
          );
          radius: 2
        }
        // Change cursor to pointing action as configured by root os system.
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.NoButton
          cursorShape: (parent.hovered && dashViewRoot.is_legacy === false ? 
            Qt.PointingHandCursor : Qt.ArrowCursor
          );
        }
      }
    }//end 'footerRow'
  }//end 'footerBody'
  
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'