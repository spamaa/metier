import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// MatterFi_TransactionDetails.qml
// Delegate for an OT Activity model. Displays Asset's activity details.
//
/*  Roles { // QML usually helps turn these into properties on the model by simular name.
  AmountRole = Qt::UserRole + 0,    // QString
  TextRole = Qt::UserRole + 1,      // QString
  MemoRole = Qt::UserRole + 2,      // QString
  TimeRole = Qt::UserRole + 3,      // QDateTime
  UUIDRole = Qt::UserRole + 4,      // QString
  PolarityRole = Qt::UserRole + 5,  // int, -1, 0, or 1
  ContactsRole = Qt::UserRole + 6,  // QStringList
  WorkflowRole = Qt::UserRole + 7,  // QString
  TypeRole = Qt::UserRole + 8,      // int, opentxs::StorageBox

Columns {
  TimeColumn   = 0
  TextColumn   = 1
  AmountColumn = 2
  UUIDColumn   = 3
  MemoColumn   = 4
};

qml: index:0
qml: hasModelChildren:false
qml: confirmations:226683
qml: contacts:
qml: workflow:
qml: uuid:
qml: polarity:1
qml: memo:
qml: timestamp: Fri May 7 18:03:18 2021 GMT-0500
qml: amount: 0.499 990 202 49 <blockchain>
qml: description: "Incoming/Outgoing" <blockchain> transaction
qml: type:10
*/
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: 300
  color: "transparent"
  opacity: 0.0
  visible: (opacity >= 0.8)

  property bool justDetails: false

  property var activityModel: undefined // Activity model from OT, AccountActivity.
  property var sumaryModel: undefined   // Manual instead of an Activit/Thread model.

  //----------------------
  // Activity/transaction details:

  //TODO: sort out how OT will provide details for transactions across blockchains
  // and which of those details are nesisary for user review satisfaction.
  function setTransactionType(forced = null) {
    var transType = null
    if (forced !== null) {
      transType = forced
    } else {
      transType = "Generic"
    }
    //switch (transType) {
    //  case "ETH":
    //    transactionViewLoader.sourceComponent = contextRoot.ethTransactionComponent
    //    break;
    //  default:
    //    transactionViewLoader.sourceComponent = contextRoot.genericTransactionComponent
    //}
    //debugger:
    //console.log("displaying transaction type:", transType, transactionViewLoader.sourceComponent)
  }

  //----------------------
  // Populate display element data for delegation:
  property var display_model: ({})
  function populateActivity(activity_model) {
    if (activity_model !== undefined) {
      // gather up the display data from the index in provied for Delicagation
      var for_index = activity_model.index
      contextRoot.display_model = contextRoot.getDisplayData(for_index)
      contextRoot.setTransactionType()
      // debugger:
      //console.log("Sat activity/transaction deligate data:", for_index, display_model, activity_model)
      //QML_Debugger.listEverything(activity_model)
      //QML_Debugger.listEverything(display_model)
    } else {
      console.log("Error: TransactionDetails are null activity_model.")
    }
  }

  //----------------------
  // Populate display with manually provided transaction/activity details:
  function useProvidedDetails() {
    var display_data = {}
    if (contextRoot.sumaryModel !== undefined) {
      // format amount display for blockchain value
      display_data['amount'] = sumaryModel['amount']
      var notary = " " + (OTidentity.focusedAccountActivity_OTModel.displayBalance !== undefined ? 
        OTidentity.focusedAccountActivity_OTModel.displayBalance.split(" ")[1] : "null" );
      sumaryModel['amount'] = sumaryModel['amount'] + notary
      // send toWhome MatterfiCode
      if (sumaryModel['sendreview'] === true) {
        display_data['fulltoAddress'] = sumaryModel['fulltoAddress']
        if (sumaryModel['fulltoAddress'] !== undefined && sumaryModel['fulltoAddress'].length > 19) {
          display_data['smalltoAddress'] = sumaryModel['fulltoAddress'].slice(0, 18) + "..."
        } else {
          display_data['smalltoAddress'] = sumaryModel['fulltoAddress']
        }
        blockchainBrowserLink.txid = display_data['fulltoAddress']
      } else {
        display_data['fulltxid'] = sumaryModel['fulltxid']
        if (sumaryModel['fulltxid'] !== undefined && sumaryModel['fulltxid'].length > 19) {
          display_data['smalltxid'] = sumaryModel['fulltxid'].slice(0, 18) + "..."
        } else {
          display_data['smalltxid'] = sumaryModel['fulltxid']
        }
        blockchainBrowserLink.txid = display_data['fulltxid']
      }
      contextRoot.display_model = display_data
      genericTransactionType.isSendReview = true

      // generate explorer link button using depositChains role
      blockchainBrowserLink.depositChains = OTidentity.focusedAccountActivity_OTModel.depositChains
      blockchainBrowserLink.setWebURL()

      //debugger:
      //console.log("Send summary review:", contextRoot.display_model)
    } else {
      console.log("Attempted to set tranasaction details manually with out providing them.")
    }
  }

  //----------------------
  // Populate display element data for delegation
  function getDisplayData(for_index) {
    var display_data = {}
    if (contextRoot.activityModel !== undefined) {
      // gather up the display data from the index in provied for Delicagation:
      display_data['timestamp'] = contextRoot.activityModel.data( 
        contextRoot.activityModel.index(for_index, 0) );          // TimeColumn
      display_data['text']      = contextRoot.activityModel.data(
        contextRoot.activityModel.index(for_index, 1) );          // TextColumn
      display_data['amount']    = contextRoot.activityModel.data( 
        contextRoot.activityModel.index(for_index, 2) );          // AmountColumn
      display_data['fulltxid']  = contextRoot.activityModel.data( 
        contextRoot.activityModel.index(for_index, 3) );          // UUIDColumn
      display_data['memo']      = contextRoot.activityModel.data( 
        contextRoot.activityModel.index(for_index, 4) );          // MemoColumn
      // Shorthand the TXID for tighter display placement
      if (display_data['fulltxid'] !== undefined && display_data['fulltxid'].length > 19) {
        display_data['smalltxid'] = display_data['fulltxid'].slice(0, 18) + "..."
      } else {
        display_data['smalltxid'] = display_data['fulltxid']
      }
      // explorer link, create with depositChains and transaction ID
      blockchainBrowserLink.depositChains = contextRoot.activityModel.depositChains
      blockchainBrowserLink.txid = display_data['fulltxid']
      blockchainBrowserLink.setWebURL()
      // debugger:
      //console.log("Set display deligate data for:", for_index, activityModel)
      //QML_Debugger.listEverything(display_data)
      //QML_Debugger.listEverything(activityModel)
    } else {
      console.log("Could not locate Row model data from AccountActivity for index:", for_index)
    }
    //QML_Debugger.listEverything(display_data)
    // return the gathered display data:
    return display_data
  }

  //-----------------------------------------------------------------------------
  Column {
    id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height
    spacing: 8
    padding: spacing
    clip: true
    anchors.centerIn: parent

    //-----------------------------------------------------------------------------
    Row {
      id: detailsHeader
      width: parent.width
      visible: (contextRoot.justDetails === false)
      spacing: width - detailsHeaderText.width - closeDetailsButton.width
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        id: detailsHeaderText
        text: qsTr("Transaction details")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_accent
        font.weight: Font.Bold
        anchors.verticalCenter: parent.verticalCenter
      }

      FontIconButton {
        id: closeDetailsButton
        iconChar: IconIndex.sd_close
        fontFamilyName: Fonts.icons_spacedawgs
        enabled: (parent.visible)
        anchors.verticalCenter: parent.verticalCenter
        onAction: contextRoot.close()
      }
    }//end 'detailsHeader'

    //-----------------------------------------------------------------------------
    // Create transaction view types
    /*
    Component {
      id: genericTransactionComponent
      TransactionDeligate_Generic {
        id: genericTransactionType
        transData: contextRoot.display_model
      }
    }

    Component {
      id: ethTransactionComponent
      TransactionDeligate_ETH {
        id: gasTransactionType
        transData: contextRoot.display_model
      }
    }
    */

    // Make loader for single transaction deligated componet
    Rectangle {
      id: transactionDeligateRect
      width: parent.width
      height: 220
      color: "transparent"
      anchors.horizontalCenter: parent.horizontalCenter

      //Loader {
      //  id: transactionViewLoader
      //  sourceComponent: genericTransactionComponent
      //}

      TransactionDeligate_Generic {
        id: genericTransactionType
        transData: contextRoot.display_model
      }
    }

    //-----------------------------------------------------------------------------
    // Footer, open system web browser and take user to blockchain explorer:
    MatterFi_BlockchainExplorerButton {
      id: blockchainBrowserLink
      visible: (contextRoot.justDetails === false)
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: transactionDeligateRect.bottom
    }
  }//end 'body'

  //-----------------------------------------------------------------------------
  // States for transitioning:
  state: "closed"

  states: [
    State { name: "closed"
      PropertyChanges { target: contextRoot; opacity: 0.0 }
    },
    State { name: "open"
      PropertyChanges { target: contextRoot; opacity: 1.0 }
    }
  ]//end 'states'

  transitions: [
    Transition {
      from: "*"; to: "closed"
      NumberAnimation { target: contextRoot; property: "opacity"; duration: 400 }
    },
    Transition {
      from: "*"; to: "open"
      NumberAnimation { target: contextRoot; property: "opacity"; duration: 400 }
    }
  ]//end 'transitions'

  //-----------------------------------------------------------------------------
  // Change state:
  function open(model) {
    contextRoot.populateActivity(model)
    contextRoot.state = "open"
    //debugger:
    //console.log("Opened transaction details.", model)
  }
  
  signal closed() // onClosed
  function close() {
    contextRoot.state = "close"
    contextRoot.closed()
  }
//-----------------------------------------------------------------------------
}//end 'contextRoot'