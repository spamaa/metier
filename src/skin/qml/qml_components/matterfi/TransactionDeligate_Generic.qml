import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// TransactionDeligate_Generic.qml
// Delegate for general supported blockchain transactions like BTC.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: detailsBodyColumn.height
  radius: 8
  clip: true
  color: "transparent"
  border.color: DawgsStyle.aa_norm_ol
  border.width: 1
  anchors.centerIn: parent

  property var transData: undefined
  property bool isSendReview: false

  //----------------------
  //Component.onCompleted: {
    //debugger:
    //console.log("Generic transaction details for:")
    //QML_Debugger.listEverything(contextRoot.transData)
  //}

  //-----------------------------------------------------------------------------
  Column {
    id: detailsBodyColumn
    width: parent.width
    padding: 0
    spacing: 6
    anchors.horizontalCenter: parent.horizontalCenter
    //----------------------
    // Transaction ID:
    TransactionDetailItemDeligate {
      id: txidDetails
      dataTitle: (contextRoot.isSendReview ? qsTr("To") : qsTr("TXID") );
      dataLnOne: (contextRoot.isSendReview ? 
        (contextRoot.transData['smalltoAddress'] !== undefined ? contextRoot.transData['smalltoAddress'] : "error") :
        (contextRoot.transData['smalltxid'] !== undefined ? contextRoot.transData['smalltxid'] : "error") );
    }

    //----------------------
    // TimeStamp:
    TransactionDetailItemDeligate {
      id: timestampDetails
      visible: (contextRoot.transData['timestamp'] !== undefined)
      height: (visible ? txidDetails.height : 0)
      displayLineDivide: true
      dataTitle: qsTr("Timestamp")
      dataLnOne: (contextRoot.transData !== undefined ? (contextRoot.transData['timestamp'] !== undefined ? 
        contextRoot.transData['timestamp'] : "error") : "null"
      );
    }

    //----------------------
    // display transaction amount:
    TransactionDetailItemDeligate {
      id: amountDetails
      doubleRow: true
      displayLineDivide: true
      dataTitle: qsTr("Amount")
      dataLnOne: (contextRoot.transData !== undefined ? (contextRoot.transData['amount'] !== undefined ? 
        contextRoot.transData['amount'] : "error") : "null"
      );
      dataLnTwo: "$ 0000 USD"  // TODO: api.convertAmount(transData['amount'], "USD") ??
    }

  }//end 'detailsBodyColumn'

//-----------------------------------------------------------------------------
}//end 'contextRoot'