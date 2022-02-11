import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/asset_choice.qml"
// Provides a screen to select an avaliable wallet asset to set current in
// focused AccountActivity model.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Asset Choice.")
	objectName: "dashboard_asset_choice"
	background: null //Qt.transparent

  property string selected_account: "" // the selected account's id string

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
			displayText: qsTr("done")
			onClicked: pageRoot.popDash()
		}

    //----------------------
    Text {
      text: qsTr("Choose token to receive")
      font.pixelSize: DawgsStyle.fsize_title
      font.weight: Font.Bold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    Dawgs_TextField {
      id: searchAssetTextBox
      width: parent.width - DawgsStyle.horizontalMargin
      isSeachBox: true
      canClickOffClose: true
      placeholderText: qsTr("Search tokens")
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // quick item deligation:
    Component {
      id: accountListModelDelegator

      Rectangle {
        id: deligateRoot
        width: assetListView.width
        height: (visible ? 64 : 0)
        color: (is_selected ? DawgsStyle.aa_selected_bg : 
          (assetSelectionMouseArea.containsMouse ? DawgsStyle.aa_hovered_bg : "transparent")
        );
        radius: 4
        clip: true
        border.color: (is_selected ? DawgsStyle.buta_selected : "transparent");
        border.width: 1

        property bool is_selected: (dashViewRoot.selected_account === model.account)

        Row {
          id: assetSelectionRow
          width: parent.width
          height: parent.height
          leftPadding: DawgsStyle.horizontalMargin
          anchors.horizontalCenter: parent.horizontalCenter
          // blockchain icon displayed
          MatterFi_BlockChainIcon {
            id: blockchainIcon
            height: parent.height - DawgsStyle.verticalMargin - 6
            width:  height
            abvNotary: model.unitname
            anchors.verticalCenter: parent.verticalCenter
          }
          // asset notary and unit names
          Column {
            id: descriptiveTextColumn
            width: parent.width - blockchainIcon.width
            height: blockchainIcon.height - 8
            spacing: 0
            leftPadding: 12
            rightPadding: parent.width - width
            anchors.verticalCenter: parent.verticalCenter

            Text {
              text: model.notaryname
              color: DawgsStyle.font_color
              height: parent.height / 2
              font.pixelSize: DawgsStyle.fsize_accent
              font.family: Fonts.font_HindVadodara_semibold
              font.weight: Font.DemiBold
            }
            Text {
              text: model.unitname
              color: DawgsStyle.font_color
              opacity: 0.5
              height: parent.height / 2
              font.pixelSize: DawgsStyle.fsize_lable
              font.family: Fonts.font_HindVadodara_semibold
              font.weight: Font.DemiBold
            }
          }
        }//end 'assetSelectionRow'

        MouseArea {
          id: assetSelectionMouseArea
          hoverEnabled: true
          anchors.fill: parent
          cursorShape: (assetSelectionMouseArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
          onClicked: {
            dashViewRoot.selected_account = model.account
          }
          onPressed: { }
          onReleased: { }
          onEntered: { }
          onExited: { }
        }
      }//end 'deligateRoot'
    }//end 'accountListModelDelegator'

    //----------------------
    // footer item deligation:
    Component {
      id: accountListModelFooterDelegator

      Item {
        id: footerDeligateRoot
        width: assetListView.width
        height: footerDeligateRow.height + DawgsStyle.verticalMargin

        Rectangle {
          id: assetSelectionBG
          width: parent.width
          height: parent.height - DawgsStyle.verticalMargin
          y: DawgsStyle.verticalMargin
          color: (additionalAssetMouseArea.containsMouse ? DawgsStyle.aa_hovered_bg : "transparent");
          radius: 4
          clip: true
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom

          Row {
            id: footerDeligateRow
            width: parent.width
            leftPadding: DawgsStyle.horizontalMargin
            height: 64
            opacity: 0.0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            // add asset icon
            Rectangle {
              id: addIconBgRect
              height: parent.height - DawgsStyle.verticalMargin - 6
              width:  height
              color: DawgsStyle.page_bg
              radius: (height / 2)
              anchors.verticalCenter: parent.verticalCenter

              Text {
                id: buttonIcon
                text: IconIndex.sd_add
                width: parent.width
                height: parent.height
                color: DawgsStyle.font_color
                font.pixelSize: DawgsStyle.fsize_pinnum
                font.weight: Font.Black
                font.family: Fonts.icons_spacedawgs
                font.styleName: "Regular"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
              }
            }
            // Add new asset
            Column {
              id: descriptiveTextColumn
              width: parent.width - addIconBgRect.width
              height: addIconBgRect.height - 8
              spacing: 0
              leftPadding: 12
              rightPadding: parent.width - width
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: qsTr("Add asset")
                color: DawgsStyle.font_color
                height: parent.height
                font.pixelSize: DawgsStyle.fsize_accent
                font.family: Fonts.font_HindVadodara_semibold
                font.weight: Font.DemiBold
                verticalAlignment: Text.AlignVCenter
              }
            }
            // Footer appearance animation:
            Timer {
              id: footerShowTimer
              running: true
              interval: 800
              onTriggered: {
                footerAppearnceAnimation.running = true
                running = false
              }
            }

            ParallelAnimation {
              id: footerAppearnceAnimation
              running: false
              NumberAnimation { target: footerDeligateRow; property: "y"; 
                from: footerDeligateRow.height * 2; to: 0;
                duration: 800; easing.type: Easing.OutBack 
              }
              NumberAnimation { target: footerDeligateRow; property: "opacity"; 
                from: 0.0; to: 1.0; duration: 400 
              }
            }
          }//end 'footerDeligateRow'

          MouseArea {
            id: additionalAssetMouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: (additionalAssetMouseArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
            onClicked: {
              if (DawgsStyle.can_search_tokens) {
                pageRoot.pushDash("dashboard_add_token")
              } else {
                pageRoot.pushDash("dashboard_manage_assets")
              }
              dashViewRoot.selected_account = ""
            }
            onPressed: { }
            onReleased: { }
            onEntered: { }
            onExited: { }
          }
        }//end 'assetSelectionBG'
      }//end 'footerDeligateRoot'
    }//end 'accountListModelFooterDelegator'

    //-----------------------------------------------------------------------------
    ListView {
      id: assetListView
      width: parent.width - assetListView.spacing
      height: parent.height - 256
      clip: true
      model: OTidentity.accountList_OTModel
      delegate: accountListModelDelegator
      spacing: DawgsStyle.horizontalMargin
      footer: Loader {
        sourceComponent: accountListModelFooterDelegator
      }
      anchors.horizontalCenter: parent.horizontalCenter
      //----------------------
      // Animations:
      populate: Transition {
        NumberAnimation { property: "y"; duration: 800; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 800 }
      }

      add: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 800 }
      }

      displaced: Transition {
        PropertyAction { properties: "opacity"; value: 1.0 }
        NumberAnimation { property: "y"; duration: 800 }
      }
    }

    //-----------------------------------------------------------------------------
    Dawgs_Button {
      id: nextStepButton
      displayText: qsTr("Next")
      buttonType: "Active"
      enabled: (dashViewRoot.selected_account !== "")
      anchors.horizontalCenter: parent.horizontalCenter

      onClicked: {
        OTidentity.setAccountActivityFocus(dashViewRoot.selected_account)
        pageRoot.pushDash("dashboard_asset_view_address")
      }
    }

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'