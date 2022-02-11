import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// MatterFi_ActivityItemDetails.qml
// Single OT ActivityThread model index delegate. Displays Contact's activity details.
//
/*
enum Roles {
  AmountRole = Qt::UserRole + 0,    // QString
  LoadingRole = Qt::UserRole + 1,   // bool
  MemoRole = Qt::UserRole + 2,      // QString
  PendingRole = Qt::UserRole + 3,   // bool
  PolarityRole = Qt::UserRole + 4,  // int, -1, 0, or 1
  TextRole = Qt::UserRole + 5,      // QString
  TimeRole = Qt::UserRole + 6,      // QDateTime
  TypeRole = Qt::UserRole + 7,      // int, opentxs::StorageBox
  OutgoingRole = Qt::UserRole + 8,  // bool
  FromRole = Qt::UserRole + 9,      // QString
};
enum Columns {
  TimeColumn = 0,
  FromColumn = 1,
  TextColumn = 2,
  AmountColumn = 3,
  MemoColumn = 4,
  LoadingColumn = 5,
  PendingColumn = 6,
}
qml: canMessage: false
qml: displayName:
qml: draft:
qml: draftValidator: opentxs::ui::implementation::DraftValidator
qml: participants:
qml: threadID:
qml: submit:function() { [native code] }
qml: revert:function() { [native code] }
qml: canMessageUpdate:function() { [native code] }
qml: displayNameUpdate:function() { [native code] }
qml: draftUpdate:function() { [native code] }
qml: setDraft:function() { [native code] }
qml: pay:function() { [native code] }
qml: paymentCode:function() { [native code] }
qml: sendDraft:function() { [native code] }

qml: QQmlDMAbstractItemModelData(0x7f837b630830)
qml: time:Thu Jul 15 20:19:55 2021 GMT-0500
qml: type:10
qml: polarity:1
qml: text:Incoming PKT transaction from PD1kEC92CeshFRQ3V78XPAGmE1ZWy3YR4Ptsjxw8SxHgZvFVkwqjf
qml: memo:
qml: pending:false
qml: amount:1.479 999 999 52 PKT
qml: loading:false
qml: outgoing:false
qml: from:PD1kEC92CeshFRQ3V78XPAGmE1ZWy3YR4Ptsjxw8SxHgZvFVkwqjf
*/
//-----------------------------------------------------------------------------
Column {
  id: contextRoot
  width: parent.width
  height: 300
  spacing: 8
  padding: spacing
  opacity: 0.0
  visible: (opacity >= 0.1)
  clip: true

  property var ot_ActivityThread: undefined // OT's ActivityThread model for Contact.
  property var activityItemModel: undefined // Single focused model provied.

  //-----------------------------------------------------------------------------
  // Populate display element data for delegation:
  property var display_model: ({})
  function populateDisplayData(activity_model) {
    if (activity_model !== undefined) {
      contextRoot.activityItemModel = activity_model
      // gather up the display data from the index in provied for Delicagation
      var for_index = activity_model.index
      contextRoot.display_model = contextRoot.getDisplayData(for_index)
      genericTransactionType.transData = contextRoot.display_model
      // debugger:
      //console.log("Sat contact activity deligate data:", for_index, display_model, activity_model)
      //QML_Debugger.listEverything(contextRoot.activityItemModel)
    } else {
      console.log("Error: ActivityItemDetails are null activityItemModel.")
    }
  }

  //----------------------
	// Populate display element data for delegation
	function getDisplayData(for_index) {
		var display_data = {}
		if (contextRoot.ot_ActivityThread !== undefined) {
			// gather up the display data from the index in provied for Delicagation:
			display_data['timestamp'] = contextRoot.ot_ActivityThread.data( 
				contextRoot.ot_ActivityThread.index(for_index, 0) );          // TimeColumn
			display_data['from']      = contextRoot.ot_ActivityThread.data(
				contextRoot.ot_ActivityThread.index(for_index, 1) );          // FromColumn
			display_data['text']      = contextRoot.ot_ActivityThread.data( 
				contextRoot.ot_ActivityThread.index(for_index, 2) );          // TextColumn
			display_data['amount']    = contextRoot.ot_ActivityThread.data( 
				contextRoot.ot_ActivityThread.index(for_index, 3) );          // AmountColumn
			display_data['memo']      = contextRoot.ot_ActivityThread.data( 
				contextRoot.ot_ActivityThread.index(for_index, 4) );          // MemoColumn


      //TODO: need to get the transacion ID from the ActivityThread entry not the
      // text some how.
      // Shorthand the TXID for tighter display placement
      if (display_data['from'] !== undefined && display_data['from'].length > 19) {
        display_data['smalltxid'] = display_data['from'].slice(0, 18) + "..."
      } else {
        display_data['smalltxid'] = display_data['from']
      }

      // generate explorer link button
      //TODO: get an AccountActivity notary unitname.
      //blockchainBrowserLink.depositChains = contextRoot.activityModel.depositChains
      blockchainBrowserLink.txid = display_data['from']
      blockchainBrowserLink.setWebURL()

			// debugger:
			//console.log("Set display deligate data for:", for_index, ot_ActivityThread)
			//QML_Debugger.listEverything(display_data)
		} else {
			console.log("Could not locate Row model data from ActivityThread for index:", for_index)
		}
		// return the gathered display data:
		return display_data
	}

  //-----------------------------------------------------------------------------
  Row {
    id: detailsHeader
    width: parent.width
    spacing: width - detailsHeaderText.width - closeDetailsButton.width
    anchors.horizontalCenter: parent.horizontalCenter

    Text {
      id: detailsHeaderText
      text: qsTr("Transaction details") // "Activity details"
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
  // Activity details:
  Rectangle {
    id: transactionDeligateRect
    width: contextRoot.width
    height: 220
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter

    TransactionDeligate_Generic {
      id: genericTransactionType
      transData: contextRoot.display_model
    }
  }

  //-----------------------------------------------------------------------------
  // Footer, open system web browser and take user to blockchain explorer:
  MatterFi_BlockchainExplorerButton {
    id: blockchainBrowserLink
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: transactionDeligateRect.bottom
  }

  //-----------------------------------------------------------------------------
  // States for transitioning:
  state: "closed"

  states: [
    State { name: "closed"
      PropertyChanges {
        target: contextRoot
        opacity: 0.0
        scale: 0.0
      }
    },
    State { name: "open"
      PropertyChanges {
        target: contextRoot
        opacity: 1.0
        scale: 1.0
      }
    }
  ]//end 'states'

  transitions: [
    Transition {
      from: "open"; to: "closed"
      ParallelAnimation {
        OpacityAnimator { target: contextRoot; duration: 200 }
      }
    },
    Transition {
      from: "closed"; to: "open"
      ParallelAnimation {
        id: openAnimation
        OpacityAnimator { target: contextRoot; duration: 200 }
      }
    }
  ]//end 'transitions'

  //-----------------------------------------------------------------------------
  // Change state:
  function open(model) {
    console.log("Opened contact activity details.", model)
    contextRoot.populateDisplayData(model)
    contextRoot.state = "open"
  }
  
  signal closed() // onClosed
  function close() {
    contextRoot.state = "close"
    contextRoot.closed()
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'