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
// Dashboard_Assets.qml
// Display delegate for OT AccountList.
/*  QQmlDMAbstractItemModelData
qml: notaryid:
qml: name:
qml: unit:
qml: notaryname:
qml: account:
qml: unitname:
qml: polarity:
qml: balance:
qml: contractid:
qml: accounttype:
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

  signal action() // called when a asset is interacted with.
  //-----------------------------------------------------------------------------
  // Create connections:
  Component.onCompleted: {
    OTidentity.updateAccountModels()
    accountlistView.model = OTidentity.accountList_OTModel
    if (accountlistView.model !== undefined) {
      accountlistView.visible = accountlistView.model.rowCount() > 0
      if (typeof accountlistView.model.rowsInserted === "function") {
        accountlistView.model.rowsInserted.connect(contextRoot.onAccountlist_update)
      }
    }
    // debugger:
    //console.log("Looking at OT AccountList model.", accountlistView.model.rowCount())
    //QML_Debugger.listEverything(accountlistView.model)
  }

  // Clear connections.
  Component.onDestruction: {
    if (accountlistView.model !== undefined) {
      if (typeof accountlistView.model.rowsInserted === "function") {
        accountlistView.model.rowsInserted.disconnect(contextRoot.onAccountlist_update)
      }
    }
  }

  //----------------------
  // Detected an update to the current account list model:
  function onAccountlist_update(index = null, bottomRight = null, roles = null) {
    //debugger:
    //console.log("A change to AccountList or Blockchain OT model detected.", index)
    if (accountlistView !== null) {
      accountlistView.visible = accountlistView.model.rowCount() > 0
    }
  }

  //----------------------
  property var selectedAccountListRow: undefined
  // Called when an account list item was selected from list:
  function onAction_accountList(selection) {
    // selection is the model from the AccountList for that user's wallets
    //console.log("Account selection made: ", selection)
    contextRoot.selectedAccountListRow = selection
    // if the AccountList model changes it will void this activity model pointer
    // value. Take the block chain model for the associated list's account selection
    // and pass the users wallet id to it to populate the account transaction history
    OTidentity.setAccountActivityFocus(selection.account)
    // continue selection signal propagation into parent component.
    contextRoot.action()
    // debugger:
    //console.log("Dash Assets: selected asset OT model:", selection)
    //QML_Debugger.listEverything(selection)
  }

  //-----------------------------------------------------------------------------
  // User AccountAsset Selection list:
  Component {
    id: assetDeligate
    //Item {
      //id: deligateRoot
      //width: body.width
      //height: dashlistDeligate.height
      //----------------------
      Dashboard_ListDeligate {
        id: dashlistDeligate
        width: parent.width
        topText: model.balance
        bottomText: model.notaryname
        item_index: index

        onClicked: { }
        onLeftClicked: {
          //show asset details
          contextRoot.onAction_accountList(model)
        }
        onRightClicked: {
          if (DawgsStyle.advanced_details === true) {
            //debugger:
            console.log("Displaying advanced blockchain details for", model.account)
            // right click debug open advanced details page
            OTidentity.setAccountActivityFocus(model.account)
            pageRoot.pushDash("advanced_wallet_details")
          }
        }

        Component.onCompleted: {
          // has to sometimes wait until model is ready to get data from it
          dashlistDeligate.notaryIcon = model.unitname
          dashlistDeligate.blockchainIcon.abvNotary = dashlistDeligate.notaryIcon
          dashlistDeligate.blockchainIcon.setIconFile()
          //debugger:
          //console.log("Dashboard_Assets, set notary icon:", dashlistDeligate.notaryIcon)
        }
      }
  }

  //----------------------
  // Show the account selection list:
  Dashboard_ListView {
    id: accountlistView
    model: []
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 2)
    visible: (accountlistView.count > 0)
    delegate: assetDeligate
    footerText: qsTr("Looking for more?")
    footerButtonText: ( DawgsStyle.can_search_tokens ? qsTr("Add tokens") : qsTr("Manage assets") );
    onFooterAction: {
      if (DawgsStyle.can_search_tokens) {
        pageRoot.pushDash("dashboard_add_token")
      } else {
        pageRoot.pushDash("dashboard_manage_assets")
      }
    }
  }//end 'accountlistView'

  //-----------------------------------------------------------------------------
  // Viewed when no assets are found and user needs to create some.
  Rectangle {
    id: noAssetsViewRect
    width: accountlistView.width
    height: addAssetsPromptColumn.height + DawgsStyle.verticalMargin
    color: DawgsStyle.norm_bg
    visible: (accountlistView.visible !== true)
    radius: 12
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
      id: addAssetsPromptColumn
      width: noAssetsViewRect.width
      spacing: 4
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_CenteredTitle {
        fontPixelSize: DawgsStyle.fsize_accent
        textTitle: qsTr("No assets found")
      }

      MatterFi_RoundButton {
        text: qsTr("Add some")
        anchors.horizontalCenter: parent.horizontalCenter
        border_color: DawgsStyle.buta_active
        onClicked: {
          pageRoot.pushDash("dashboard_manage_assets")
        }
      }
    }
  }//end 'noAssetsViewRect'

//-----------------------------------------------------------------------------
}//end 'contextRoot'