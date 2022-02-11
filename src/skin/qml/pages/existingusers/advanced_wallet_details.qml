import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
/* AccountStatus OT model:
//
// Advanced wallet details require either a chain id, or an account id.
*
* qml: nym:
* qml: chain:
* qml: objectNameChanged:function() { [native code] }
* qml: dataChanged:function() { [native code] }
* qml: headerDataChanged:function() { [native code] }
* qml: layoutChanged:function() { [native code] }
* qml: resetInternalData:function() { [native code] }
* qml: hasIndex:function() { [native code] }
* qml: index:function() { [native code] }
* qml: rowCount:function() { [native code] }
* qml: columnCount:function() { [native code] }
* qml: data:function() { [native code] }
* 
* Roles:
*   NameRole = Qt::UserRole + 0,            // QString
*   SourceIDRole = Qt::UserRole + 1,        // QString
*   SubaccountIDRole = Qt::UserRole + 2,    // QString
*   SubaccountTypeRole = Qt::UserRole + 3,  // int
*   SubchainTypeRole = Qt::UserRole + 4,    // int
*   ProgressRole = Qt::UserRole + 5,        // QString
* 
*/
//-----------------------------------------------------------------------------
// Display an advanced detailed tree of connected peers and sync 
// details for the blockchains.
//-----------------------------------------------------------------------------
Page {
  id: detailsRoot
  title: qsTr("Advanced Wallet Details")
  objectName: "advanced_wallet_details"
  width: dashStackView.width
  height: dashStackView.height

  background: Rectangle {
    id: page_bg_fill
    color: DawgsStyle.norm_bg
  }

  // Model component ponter propteries:
  property var accountStatus_OT: ({}) // expecting "AccountStatus" OT model
  property var blockchianID: null // looking for an accountID string from an asset or blockchain.

  //-----------------------------------------------------------------------------
  // Finishes deligation requirement for model for OT AccountStatus display.
  function setAccountStatusModel() {
    if (detailsRoot.blockchianID !== null) {
      // grab account_id to get peer sync details AccountStatus model
      console.log("Advanced blockchain details for chain ID:", detailsRoot.blockchianID)
      detailsRoot.accountStatus_OT = OTidentity.getAcountStatusModel(detailsRoot.blockchianID)
    } else {
      console.log("Error: Advanced wallet details is looking for a valid asset account id.")
    }
  }

  // Run as soon as page is loaded:
  Component.onCompleted: {
    // grab current AccountActivity from wallet navigation
    //detailsRoot.accountID = rootAppPage.passAlongData
    //rootAppPage.clear_passAlong()
    var istest_chains = true
    var blockChainList_OT = api.blockchainChooserModelQML(istest_chains)
    var available_chains = []
    for (var i=0; i < blockChainList_OT.rowCount(); i++) {
      // display name is the only column to display on blockchain Chooser
      var chain_name = blockChainList_OT.data( blockChainList_OT.index(i, 0) )
      available_chains.push(chain_name)
    }
    console.log("account has access to:", available_chains)
    detailsRoot.blockchianID = 9 // set what block chain to view details about.
    // populate detailsRoot model pointers
    detailsRoot.setAccountStatusModel()
  }

  //-----------------------------------------------------------------------------
  // main display 'body' layout
  Column {
    id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height
    spacing: 12
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      x: parent.width - width
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("close")
			onClicked: {
        blockchainStatGroup.clearConnections()
        pageRoot.popDash()
      }
		}

    //----------------------
    Text {
      id: contextDrawerFunctionTextDescription
      text: qsTr("Advanced Wallet Details")
      font.weight: Font.Bold
      font.pixelSize: DawgsStyle.fsize_accent
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
    }

    //----------------------
    // Details TreeView display rect:
    ScrollView {
      id: scrollTreeView
      width: parent.width
      height: parent.height * 0.70
      contentWidth: displayTreeRect.width
      clip: true
      ScrollBar.horizontal.interactive: true
      ScrollBar.vertical.interactive: false
      ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
      ScrollBar.vertical.policy: ScrollBar.AsNeeded

      Rectangle {
        id: displayTreeRect
        color: "transparent"
        width: 700
        height: parent.height

        MatterFi_DetailTree {
          id: advancedDetailTreeView
          //model: ( detailsRoot.accountStatus_OT !== undefined ? detailsRoot.accountStatus_OT : ({}) );
          model: (OTidentity.focusedAccountStatus_OTModel)  // uses last active focued blockchain.
        }

      }//end 'displayTreeRect'
    }//end 'scrollTreeView'


  //-----------------------------------------------------------------------------
  }//end 'body'

  Column {
    id: footerBody
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    y: detailsRoot.height - height + DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    // Version String
    Text {
      id: selectionForReceivingTypeTextDescription
      text: qsTr("Version: ") + (api.versionString(DawgsStyle.qml_release_version))
      bottomPadding: 24
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_alert
      font.weight: Font.DemiBold
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // Display the current sync status of the BlockChain:
    MatterFi_BlockChainStatistics {
      id: blockchainStatGroup
      width: parent.width
      anchors.horizontalCenter: parent.horizontalCenter
    }
    
  }//end 'footerBody'

//-----------------------------------------------------------------------------
}//end 'detailsRoot'
