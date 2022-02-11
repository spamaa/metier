import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dawgs_AssetSelection.qml
// Provides a drop down selection of avaiable assets to provide an OT 
// AssetList model.
//
// model:QQmlDMAbstractItemModelData
// [ polarity, unitname, account, notaryname, unit, name, notaryid, 
// accounttype, contractid, balance ]
//-----------------------------------------------------------------------------
Item {
  id: assetContextRoot
  width: parent.width
  height: 76

  // The currently loaded asset model for displaying account selection.
  property var assetListOTModel: undefined // Expecting OT AssetList index model.
  // if an asset account id is provided, set that asset as selected for amount entry.
  property string accountID: ""

  signal accountActivtySelected() // signal fired when the asset model selection has changed.
  signal menuOpened()
  signal menuClosed()

  //-----------------------------------------------------------------------------
  // set current account ID for the transaction to be sent:
  function deligateAnAccountID() {
    // use the current focused account asset if one is avaliable, this will use last account
    // that had send related activity around it that the user used.
    if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
      assetContextRoot.accountID = OTidentity.focusedAccountActivity_OTModel.accountID
      //debugger:
      //console.log("AssetSelection UI is looking at 'send_funds' account:", assetContextRoot.accountID)
      //QML_Debugger.listEverything(OTidentity.focusedAccountActivity_OTModel)
    }
    // use first index of account list if no asset id was provided
    if (assetContextRoot.accountID === "") {
      accountAssestsListView.currentIndex = 0
      assetContextRoot.assetListOTModel = accountAssestsListView.itemAtIndex(0)
      //debugger:
      //console.log("AssetSelection has defaulted to index 0.")
    } else if (accountAssestsListView.count > 0) {
      // if an asset id was provided when send Component was called, display that asset
			var account_index = -1
      var loop_index = 0
			while (loop_index < accountAssestsListView.count) {
				var asset_indexmodel = accountAssestsListView.itemAtIndex(loop_index)
        //debugger:
        //console.log("Searching for matching provided accountId.", 
        //  assetContextRoot.accountID, loop_index, asset_indexmodel.lmodel.account);
        //QML_Debugger.listEverything(asset_indexmodel.lmodel)
        // locate index with matching accountID value
        if (asset_indexmodel.lmodel.account !== assetContextRoot.accountID) {
          loop_index ++
          continue;
        } else {
          account_index = loop_index
          accountAssestsListView.currentIndex = loop_index
          dashViewRoot.useAccountID = asset_indexmodel.lmodel.account
          //debugger:
          //console.log("AssetSelection located matching index for accountID:", loop_index)
          break;
        }
			}
      // if no match was found, default to index 0
      if (account_index === -1) {
        var asset_indexmodel = accountAssestsListView.itemAtIndex(0)
        if (asset_indexmodel !== null) {
          dashViewRoot.useAccountID = asset_indexmodel.lmodel.account
        } else {
          console.log("Warning: Unable to find AssetSelection index 0, OT AccountList is empty?")
        }
        accountAssestsListView.currentIndex = 0
        console.log("Warning: AssetSelection did not find a matching index for accountID provided.")
      }
    }
    //debugger:
    //console.log("AssetSelection is currently focused on:", assetContextRoot.accountID, accountAssestsListView.currentIndex)
    // set the focused Asset to be displayed as selected.
    assetContextRoot.setActivtyModel()
  }

  // obtain the associated OT AccountActivity model for the selected asset:
  function setActivtyModel() {
    if (accountAssestsListView.currentItem !== undefined && accountAssestsListView.currentItem !== null) {
      //debugger:
      //QML_Debugger.listEverything(accountAssestsListView.currentItem.lmodel)  
      assetContextRoot.accountID = accountAssestsListView.currentItem.lmodel.account
      console.log("AssetSelection was account:", assetContextRoot.accountID)
      // get the current selected asset from the AccountList model and set
      // the AccountActivity for 'send()' functionality in parent Component
      OTidentity.setAccountActivityFocus(assetContextRoot.accountID)
      assetContextRoot.accountActivtySelected()
      // update the change to the selected asset icon displayed
      blockchainIconImage.setIconFile()
    }
  }

  //-----------------------------------------------------------------------------
  Rectangle {
    id: selectionRect
    width: parent.width
    height: parent.height
    radius: 8
    color: (selectionInputArea.containsMouse ? DawgsStyle.aa_hovered_bg : "transparent")
    border.color: DawgsStyle.aa_norm_ol
    border.width: 1

    MatterFi_BlockChainIcon {
      id: blockchainIconImage
      height: parent.height - 24
      width: blockchainIconImage.height
      x: 12
      //abvNotary: (accountAssestsListView.currentItem !== null ?
      //  accountAssestsListView.currentItem.lmodel.unitname : ""
      //);
      displayBalance: (accountAssestsListView.currentItem !== null ?
        accountAssestsListView.currentItem.lmodel.balance : ""
      );
      anchors.verticalCenter: parent.verticalCenter
    }

    Column {
      id: selectionDescriptionColumn
      width: parent.width * 0.6
      x: blockchainIconImage.width + blockchainIconImage.x + 8
      spacing: 2
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: nameText
        text: (accountAssestsListView.currentItem !== null ? 
          accountAssestsListView.currentItem.lmodel.notaryname : "None-NULL"
        );
        font.pixelSize: DawgsStyle.fsize_accent
        font.weight: Font.DemiBold
        color: DawgsStyle.font_color
      }

      Text {
        id: balanceText
        text: (accountAssestsListView.currentItem !== null ? qsTr("balance: ") + 
          accountAssestsListView.currentItem.lmodel.balance : "No Assets"
        );
        font.pixelSize: DawgsStyle.fsize_normal
        color: DawgsStyle.text_descrip
      }
    }

    //----------------------
    // Change cursor to pointing action as configured by root os system.
    MouseArea {
      id: selectionInputArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: (selectionInputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)

			onClicked: {
				assetContextRoot.state = (assetContextRoot.state === "open" ? "closed" : "open")
        if (assetContextRoot.state === "open") {
          assetContextRoot.menuOpened()
        } else {
          assetContextRoot.menuClosed()
        }
			}
    }
  }//end 'selectionRect'

  //-----------------------------------------------------------------------------
  Rectangle {
    id: dropdownListRect
    width: parent.width
    height: parent.height * 4
    radius: 8
    y: assetContextRoot.height + 8
    opacity: 0.0
    clip: true
    color: DawgsStyle.page_bg
    border.color: DawgsStyle.aa_selected_ol
    border.width: 1
    //----------------------
    Component {
      id: assetDeligate
      Rectangle {
        id: assetDeligateRoot
        width: parent.width - 2
        height: assetContextRoot.height - 1
        color: (accountAssestsListView.currentIndex === index ? 
          DawgsStyle.aa_selected_bg : (assetDropListInputArea.containsMouse ? 
          DawgsStyle.aa_hovered_bg : "transparent")
        );
        anchors.horizontalCenter: parent.horizontalCenter

        property var lmodel: model

        MatterFi_BlockChainIcon {
          id: assetListBlockChainIcon
          height: parent.height - 24
          width: assetListBlockChainIcon.height
          x: 12
          //abvNotary: (model.notary !== undefined ? model.notary : "")
          displayBalance: (model.balance !== undefined ? model.balance : "")
          anchors.verticalCenter: parent.verticalCenter
        }

        Column {
          id: assetListDescriptionColumn
          width: parent.width * 0.6
          x: assetListBlockChainIcon.width + assetListBlockChainIcon.x + 8
          spacing: 2
          anchors.verticalCenter: parent.verticalCenter

          Text {
            text: model.notaryname //notaryid
            font.pixelSize: DawgsStyle.fsize_accent
            font.weight: Font.DemiBold
            color: DawgsStyle.font_color
          }

          Text {
            text: qsTr("balance ") + model.balance //unitname account contractid
            font.pixelSize: DawgsStyle.fsize_normal
            color: DawgsStyle.text_descrip
          }
        }
        //Component.onCompleted: {
          //debugger:
        //  console.log("AssetSelection debugger.")
        //  QML_Debugger.listEverything(model)
        //}
        MouseArea {
          id: assetDropListInputArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: (assetDropListInputArea.containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
          onClicked: {
            accountAssestsListView.currentIndex = index
            assetContextRoot.state = "closed"
            assetContextRoot.setActivtyModel()
          }
        }
      }
    }

    ListView {
      id: accountAssestsListView
      model: OTidentity.accountList_OTModel
      delegate: assetDeligate
      focus: (assetContextRoot.state === "open")
      enabled: (assetContextRoot.state === "open")
      clip: true
      anchors.fill: parent
      anchors.margins: 2

      // Setup drop selection model data for deligation:
      Component.onCompleted: {
        assetContextRoot.deligateAnAccountID()
      }
    }
  }//end 'dropdownListRect'

  //-----------------------------------------------------------------------------
  // States for transitioning:
  state: "closed"
  states: [
    State { name: "closed"
      PropertyChanges {
        target: dropdownListRect
        opacity: 0.0
        y: assetContextRoot.height + 8 + (dropdownListRect.height / 4)
      }
    },
    State { name: "open"
      PropertyChanges {
        target: dropdownListRect
        opacity: 1.0
        y: assetContextRoot.height + 8
      }
    }
  ]//end 'states'

  transitions: [
    Transition {
      from: "*"; to: "closed"
      ParallelAnimation {
        OpacityAnimator { target: dropdownListRect; duration: 260 }
        YAnimator { target: dropdownListRect; duration: 280; easing.type: Easing.OutCubic }
      }
    },
    Transition {
      from: "*"; to: "open"
      ParallelAnimation {
        id: openAnimation
        OpacityAnimator { target: dropdownListRect; duration: 260 }
        YAnimator { target: dropdownListRect; duration: 280; easing.type: Easing.OutCubic }
      }
    }
  ]//end 'transitions'

//-----------------------------------------------------------------------------
}//end 'assetContextRoot'