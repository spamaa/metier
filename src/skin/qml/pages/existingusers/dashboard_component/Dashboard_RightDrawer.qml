import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_RightDrawer.qml
// Displayed when the Dashboard's Header bar's right menu icon is interacted with.
//-----------------------------------------------------------------------------
Popup {
  id: popupRoot
  height: menuOptions.height + body.spacing
  width: pageRoot.width * 0.75
  x: pageRoot.width - width
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
  modal: true

  background: Rectangle { color: "transparent" }

  //-----------------------------------------------------------------------------
  function handleMenuOutcome(listid) {
    switch(listid) {
    case 'assets': // Manage assets
      popupRoot.close()
      pageRoot.pushDash("dashboard_manage_assets")
      break;
    case 'rename': // Rename wallet
      popupRoot.close()
      pageRoot.pushDash("dashboard_rename_wallet")
      break;
    case 'picture': // Change Profile Pic
      popupRoot.close()
      pageRoot.pushDash("dashboard_change_profile")
      break;
    case 'view_seed': // View wallet phrase
      popupRoot.close()
      pageRoot.pushDash("dashboard_view_seedphrase")
      break;
    case 'link_card': // Link with NFC device
      popupRoot.close()
      pageRoot.pushDash("dashboard_link_spacecard")
      break;
    case 'lost_card': // Lost spacecard
      popupRoot.close()
      pageRoot.pushDash("dashboard_lost_spacecard")
      break;
    case 'adv_details': // Advanced wallet details
      //pageRoot.showAdvancedDetailsWindow()
      pageRoot.pushDash("advanced_wallet_details")
      popupRoot.close()
      break;
    default: // setup error grounds
      console.log("un-known menu target.", listid)
    }
  }

  //-----------------------------------------------------------------------------
  // main display 'body' layout
  contentItem: Rectangle {
    id: interactionAreaBG
    width: parent.width
    height: body.height
    color: DawgsStyle.norm_bg
    radius: 12
    clip: true
    //----------------------
    // Display body
    Column {
      id: body
      property int entryHeight: 48
      spacing: 4
      property int viewCount: (UIUX_UserCache.data.walletMode === "hard" ? 5 : 6) //menuOptions.count
      height: (entryHeight + spacing) * viewCount
      width: interactionAreaBG.width
      // Deligate menu list Components:
      ListView {
        id: menuOptions
        height: parent.height
        // diplay options
        model: ListModel {
          ListElement {
            name: "Manage assets"
            icon: "\uf555" // IconIndex.fa_wallet
            itype: "fa"
            listid: 'assets'
          }
          ListElement {
            name: "Rename wallet"
            icon: "\ue90b" // IconIndex.sd_edit
            itype: "sd"
            listid: 'rename'
          }
          ListElement {
            name: "Change Profile Pic"
            icon: "\uf03e" // IconIndex.fa_image
            itype: "fa"
            listid: 'picture'
          }
          ListElement {
            name: "View seed phrase"
            icon: "\uf4d8" // IconIndex.fa_seedling
            itype: "fa"
            listid: 'view_seed'
            walletmode: "soft"
          }
          ListElement {
            name: "Connect spacecard"
            icon: "\uf09d" // IconIndex.fa_credit_card
            itype: "fa"
            listid: 'link_card'
            walletmode: "soft"
          }
          ListElement {
            name: "Lost spacecard"
            icon: "\ue902" // IconIndex.sd_alert
            itype: "sd"
            listid: 'lost_card'
            walletmode: "hard"
          }
          ListElement {
            name: "Advanced wallet details"
            icon: "\uf121" // IconIndex.fa_code
            itype: "fa"
            listid: 'adv_details'
          }
        }
        //----------------------
        // How the menu items are displayed:
        delegate: Item {
          id: listItemDeligate
          width: body.width
          height: (visible ? body.entryHeight : 0)
          visible: (walletmode === undefined ? true : UIUX_UserCache.data.walletMode === walletmode)
          // background component:
          Rectangle {
            width: parent.width
            y: 1
            height: parent.height - 1
            color: (inputArea.containsMouse ? DawgsStyle.aa_hovered_bg : "transparent")
            // Change cursor to pointing action as configured by root os system.
            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.NoButton
              cursorShape: (inputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
            }
          }
          // Fill area with context information:
          Row {
            id: listItemContent
            width: parent.width
            height: parent.height
            spacing: DawgsStyle.horizontalMargin
            leftPadding: DawgsStyle.horizontalMargin
            anchors.verticalCenter: parent.verticalCenter

            Text {
              text: icon
              width: DawgsStyle.fsize_button
              color: DawgsStyle.font_color
              //font.weight: Font.Bold
              font.styleName: (itype == "sd" ? "Regular" : "Solid")
              font.pixelSize: DawgsStyle.fsize_button
              font.family: (itype == "sd" ? Fonts.icons_spacedawgs : Fonts.icons_solid)
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              anchors.verticalCenter: parent.verticalCenter
            }

            Text {
              text: name
              color: DawgsStyle.font_color
              font.pixelSize: DawgsStyle.fsize_accent
              font.weight: Font.DemiBold
              verticalAlignment: Text.AlignVCenter
              anchors.verticalCenter: parent.verticalCenter
            }
          }
          // Draw item list line divider:
          Rectangle {
            width: parent.width
            height: 1
            visible: (index < menuOptions.count - 1)
            y: listItemContent.height
            color: DawgsStyle.aa_norm_ol
          }
          // Mark area as clickable:
          MouseArea {
            id: inputArea
            enabled: parent.visible
            anchors.fill: parent
            hoverEnabled: true
            onClicked: popupRoot.handleMenuOutcome(listid)
            onPressed: { }
            onReleased: { }
            onEntered: { }
            onExited: { }
          }
        }//end 'listItemDeligate'
      }//end 'menuOptions'
    }//end 'body'

    //----------------------
    // Round the list view's corners:
    layer.enabled: false
    layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
      maskSource: Rectangle {
        width: interactionAreaBG.width
        height: interactionAreaBG.height
        radius: interactionAreaBG.radius
      }
    }
  }//end 'interactionAreaBG'

  //-----------------------------------------------------------------------------
  // Replace the default Popup animations
  enter: Transition {
    ParallelAnimation {
      id: openAnimation
      ScaleAnimator   { target: interactionAreaBG;
        from: 0.0; to: 1.0; duration: 320 }
      OpacityAnimator { target: interactionAreaBG;
        from: 0.0; to: 1.0; duration: 320 }
      YAnimator { target: interactionAreaBG; 
        from: (interactionAreaBG.height / 2) * -1; to: 8; duration: 320;
        easing.type: Easing.OutCubic }
      XAnimator { target: interactionAreaBG;
        from: (interactionAreaBG.width / 2); to: 18; duration: 320; 
        easing.type: Easing.OutCubic }
    }
  }

  exit: Transition {
    ParallelAnimation {
      ScaleAnimator   { target: interactionAreaBG;
        from: 1.0; to: 0.0; duration: 320 }
      OpacityAnimator { target: interactionAreaBG;
        from: 1.0; to: 0.0; duration: 320 }
      YAnimator { target: interactionAreaBG; 
        from: 18; to: (interactionAreaBG.height / 2) * -1; duration: 320;
        easing.type: Easing.OutCubic }
      XAnimator { target: interactionAreaBG;
        from: 8; to: (interactionAreaBG.width / 2); duration: 320;
        easing.type: Easing.OutCubic }
    }
  }
//-----------------------------------------------------------------------------
}//end 'popupRoot'