import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// Dashboard_LeftDrawer.qml
// Displayed when the Dashboard's Header bar's left menu.
/*
qml: objectNameChanged:function() { [native code] }
qml: dataChanged:function() { [native code] }
// nym entry from list:
qml: name:
qml: id: 
qml: objectNameChanged:function() { [native code] }
qml: modelIndexChanged:function() { [native code] }
*/
//-----------------------------------------------------------------------------
Popup {
  id: popupRoot
  height: body.height
  width: pageRoot.width * 0.85
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
  //focusPolicy: Qt.NoFocus
  modal: true

  background: Rectangle { color: "transparent" }

  property string filterString: "" // Used for searching nyms list.

  //-----------------------------------------------------------------------------
  // On opening menu, refresh the current list of wallet nyms:
  onOpened: {
    identitiyListView.model = OTidentity.userIdentity_OTModel.getNymListQML()
    searchNymTextBox.focus = false
    //debugger:
    //console.log("Populating wallet's nym identity list:", identitiyListView.model)
    //QML_Debugger.listEverything(identitiyListView.model)
  }

  //-----------------------------------------------------------------------------
  function handleMenuOutcome(listid) {
    switch(listid) {
    case 'create':
      pageRoot.pushDash("dashboard_nym_create")
      popupRoot.close()
      break;
    case 'restore':
      pageRoot.pushDash("dashboard_nym_restore")
      popupRoot.close()
      break;
    case 'support':
      //TODO: an entire help center qml UI
      console.log("Deep support UI context 'WIP'.")
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
    height: 480
    color: DawgsStyle.norm_bg
    radius: 12
    //----------------------
    // Display body
    Column {
      id: body
      y: 4
      width: interactionAreaBG.width
      height: 480 - appVersionRect.height
      spacing: 2
      anchors {
        topMargin: 4;
        horizontalCenter: parent.horizontalCenter;
      }

      // Nym search:
      //TODO: TextFields seem broken when in a Popup, activefocus debugging required
      // to check into the issue.
      /*
      TextField { // simple test
        id: searchNymTextBox
        placeholderText: qsTr("Search wallets")
      }

      */
      Dawgs_TextField {
        id: searchNymTextBox
        width: parent.width - 8
        isSeachBox: true
        canClickOffClose: false
        placeholderText: qsTr("Search identities") // only one wallet, multiple nyms
      }

      //-----------------------------------------------------------------------------
      // Nym identity searchable selection list:
      Component {
        id: identitiyListDeligate

        Rectangle {
          id: namBackgroundRect
          width: parent.width
          height: (nymDeligate.visible ? 48 : 0)
          color: (nymDeligate.selected ? DawgsStyle.aa_selected_bg : (selectionInputArea.containsMouse ? 
            DawgsStyle.aa_hovered_bg : "transparent"));
          anchors.horizontalCenter: parent.horizontalCenter

          // Filtering the display:  Qt::CaseInsensitive
          property var filterString: (popupRoot.filterString)
          visible: ((filterString.length === 0) || (
            model !== undefined && (
              model.name.indexOf(filterString) !== -1 ||
              model.id.indexOf(filterString) !== -1
            )
          ))
          //----------------------
          Row {
            id: nymDeligate
            width: parent.width - (DawgsStyle.horizontalMargin * 2)
            height: parent.height - (DawgsStyle.verticalMargin / 2)
            spacing: 4
            anchors.centerIn: parent
            property bool selected: (model.id === OTidentity.profile_OTModel.nymID)

            // Image displayed
            Dawgs_Avatar {
              id: nymAvatar
              height: parent.height - (DawgsStyle.verticalMargin / 2)
              width:  height
              avatarUrl: (OTidentity.profile_OTModel !== undefined ? 
                (OTidentity.profile_OTModel.image !== undefined ? OTidentity.profile_OTModel.image : "" ) : "");
              contactID: model.id
              visible: (model.id.length > 0)
              anchors.verticalCenter: parent.verticalCenter
            }

            // Name, and transaction count
            Column {
              id: descriptiveTextColumn
              width: parent.width - nymAvatar.width
              height: nymAvatar.height
              leftPadding: nymDeligate.spacing
              spacing: 0
              anchors.verticalCenter: parent.verticalCenter

              Text {
                text: (nymDeligate.selected ? (model.name + " (current)") : 
                  (model.name.length > 18 ? model.name.slice(0, 18) + "..." : model.name) );
                color: DawgsStyle.font_color
                height: parent.height / 2
                font.pixelSize: DawgsStyle.fsize_accent
                font.family: Fonts.font_HindVadodara_semibold
                font.weight: Font.DemiBold
              }
              Text {
                text: "" //"full nym asset value." //TODO: asset value for each nym.
                color: DawgsStyle.text_descrip
                height: parent.height / 2
                font.pixelSize: DawgsStyle.fsize_lable
                font.family: Fonts.font_HindVadodara_semibold
                font.weight: Font.DemiBold
              }
            }

          }//end 'nymDeligate'

          // Set interaction area:
          MouseArea {
            id: selectionInputArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: (selectionInputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
            // procceed with nym selection and swap out of OT models
            onClicked: {
              if (model.id !== OTidentity.profile_OTModel.nymID) {
                OTidentity.changeActiveNym(model.id)
                //debugger:
                //console.log("LeftDawer swapped nym:", model)
                //QML_Debugger.listEverything(model)
                //var current_nym = OTidentity.userIdentity_OTModel.getNymTypeQML()
                //QML_Debugger.listEverything(current_nym)
                //QML_Debugger.listEverything(OTidentity.profile_OTModel)
              }
            }
          }
        }//end 'namBackgroundRect'
      }//end 'identitiyListDeligate'

      //----------------------
      // show the nym list:
      ListView {
        id: identitiyListView
        model: []
        height: 200
        width: parent.width
        delegate: identitiyListDeligate
        anchors.horizontalCenter: parent.horizontalCenter
        // Search time out is busy indication:
        Timer {
          id: searchTimeoutTimer
          interval: 500

          onTriggered: {
            searchingBusyIndicator.running = false
            searchingBusyIndicator.visible = false
            contextRoot.filterString = searchbox.text
          }
        }
        // is searching/filtering contact list
        BusyIndicator {
          id: searchingBusyIndicator
          visible: (searchTimeoutTimer.running)
          scale: 1.0
          anchors.centerIn: parent
        }
        // displayed when no contacts match search context
        Label {
          id: noMatchesLabel
          anchors.centerIn: parent
          visible: false
          text: "No matches"
          color: DawgsStyle.font_color
        }
      }//end 'contactListView'

      //-----------------------------------------------------------------------------
      // Menu to create and restore additional wallet nyms:
      ListView {
        id: menuOptions
        height: 144
        width: popupRoot.width
        // diplay options
        model: ListModel {
          ListElement {
            name: "create"
            icon: "\ue900" // IconIndex.sd_add
            itype: "sd"
            listid: 'create'
          }
          ListElement {
            name: "restore"
            icon: "\ue912" // IconIndex.sd_return
            itype: "sd"
            listid: 'restore'
          }
          ListElement {
            name: "Support"
            icon: "\ue918" // IconIndex.sd_support
            itype: "sd"
            listid: 'support'
          }
        }
        //----------------------
        // How the menu items are displayed:
        delegate: Item {
          id: listItemDeligate
          width: body.width
          height: (visible ? 48 : 0)
          // background component:
          Rectangle {
            width: listItemDeligate.width
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
            spacing: DawgsStyle.horizontalMargin + 4
            leftPadding: DawgsStyle.horizontalMargin
            anchors.verticalCenter: parent.verticalCenter

            Text {
              text: icon
              width: DawgsStyle.fsize_button
              color: DawgsStyle.font_color
              font.weight: Font.Black //Bold
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

        Rectangle {
          width: parent.width
          height: 1
          color: DawgsStyle.aa_norm_ol
          anchors {
            bottom: parent.top;
          }
        }
      }//end 'menuOptions'
      
    }//end 'body'

    //-----------------------------------------------------------------------------
    // Application version number:
    Rectangle {
      id: appVersionRect
      height: versionText.height
      width: parent.width - 8
      color: DawgsStyle.page_bg
      radius: 6
      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 4
      }

      // Version String
      Text {
        id: versionText
        text: qsTr("Version: ") + (api.versionString(DawgsStyle.qml_release_version))
        padding: 4
        leftPadding: 6
        color: DawgsStyle.text_descrip
        font.pixelSize: DawgsStyle.fsize_lable
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
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
        from: (interactionAreaBG.width / 2) * -1; to: 12; duration: 320; 
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
        from: 12; to: (interactionAreaBG.height / 2) * -1; duration: 320;
        easing.type: Easing.OutCubic }
      XAnimator { target: interactionAreaBG;
        from: 8; to: (interactionAreaBG.width / 2) * -1; duration: 320;
        easing.type: Easing.OutCubic }
    }
  }
//-----------------------------------------------------------------------------
}//end 'popupRoot'