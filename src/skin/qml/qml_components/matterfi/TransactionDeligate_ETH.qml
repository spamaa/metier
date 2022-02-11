import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// TransactionDeligate_ETH.qml
// Delegate for transactions that require some kind of ETH 'gas' to complete.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: (parent.height - detailsHeader.height - openExplorerBut.height - (DawgsStyle.verticalMargin * 4) )
  radius: 8
  clip: true
  color: "transparent"
  border.color: DawgsStyle.aa_norm_ol
  border.width: 1
  anchors.centerIn: parent

  property var transData: undefined

  //----------------------
  Component.onCompleted: {
    console.log("ETH transaction details for:", contextRoot.transData)
  }

  //----------------------
  Column {
    id: detailsBodyColumn
    width: parent.width
    height: parent.height
    padding: 6
    spacing: 6
    anchors.horizontalCenter: parent.horizontalCenter
    // Transaction ID:
    Row {
      id: txidExplorerRow
      width: parent.width
      height: txidContextText.height
      spacing: width - txidDisplayText.width - txidContextText.width
      Text {
        id: txidContextText
        text: qsTr("TXID")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Text {
        id: txidDisplayText
        text: (transData !== undefined ? transData['uuid'] : "")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
    }
    // TimeStamp:
    Row {
      id: timestampDetailsRow
      width: detailsBodyColumn.width
      height: timestampContextText.height
      spacing: width - timestampContextText.width - timestampDisplayText.width
      Text {
        id: timestampContextText
        text: qsTr("Timestamp")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Text {
        id: timestampDisplayText
        text: (transData !== undefined ? transData['timestamp'] : "")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
    }
    // BlockChain Amount:
    Row {
      id: amountDetailsRow
      width: detailsBodyColumn.width
      height: amountConvertColumn.height
      spacing: width - amountContextText.width - amountConvertColumn.width
      Text {
        id: amountContextText
        text: qsTr("Amount") // TODO: polarity context. sent/recieved
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: amountConvertColumn
        Text {
          id: amountDisplayText
          text: (transData !== undefined ? transData['amount'] : "")
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: amountUSDtext
          text: "usd value" // TODO: api.convertAmount(transData['amount'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
    // Gas or other blockchain fee:
    Row {
      id: gasDetailsRow
      width: detailsBodyColumn.width
      height: gasConvertColumn.height
      spacing: width - gasContextText.width - gasConvertColumn.width
      Text {
        id: gasContextText
        text: qsTr("Gas fee")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: gasConvertColumn
        Text {
          id: gasDisplayText
          text: (transData !== undefined ? transData['gas'] : "")
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: gasUSDtext
          text: "usd value" // TODO: api.convertAmount(transData['gas'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
    // Total amount:
    Row {
      id: totalDetailsRow
      width: detailsBodyColumn.width
      height: totalConvertColumn.height
      spacing: width - totalContextText.width - totalConvertColumn.width
      Text {
        id: totalContextText
        text: qsTr("Total amount")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: totalConvertColumn
        Text {
          id: totalDisplayText
          text: (transData !== undefined ? transData['total'] : "")
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: totalUSDtext
          text: "usd value" // TODO: api.convertAmount(transData['total'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'

/*
Rectangle {
  id: detailsList
  width: parent.width
  height: detailsBodyColumn.height
  radius: 8
  clip: true
  color: "transparent"
  border.color: DawgsStyle.aa_norm_ol
  border.width: 1
  anchors.horizontalCenter: parent.horizontalCenter
  //----------------------
  Column {
    id: detailsBodyColumn
    width: parent.width
    padding: 6
    spacing: 6
    anchors.horizontalCenter: parent.horizontalCenter
    // Transaction ID:
    Row {
      id: sendtoIDrow
      width: parent.width - DawgsStyle.horizontalMargin
      height: matterCodeContextText.height
      spacing: width - toMatterCodeContextText.width - matterCodeContextText.width
      Text {
        id: matterCodeContextText
        text: qsTr("To")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Text {
        id: toMatterCodeContextText
        text: sendtoMatterCodeID
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
    }
    Rectangle {
      width: parent.width
      height: 2
      color: DawgsStyle.aa_norm_ol
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // BlockChain Amount:
    Row {
      id: amountDetailsRow
      width: parent.width - DawgsStyle.horizontalMargin
      height: amountConvertColumn.height
      spacing: width - amountContextText.width - amountConvertColumn.width
      Text {
        id: amountContextText
        text: qsTr("Amount") // TODO: polarity context. sent/recieved
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: amountConvertColumn
        Text {
          id: amountDisplayText
          text: dashViewRoot.amountToSend_validated
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: amountUSDtext
          text: "usd value" // TODO: api.convertAmount(display_data['amount'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
    Rectangle {
      width: parent.width
      height: 2
      color: DawgsStyle.aa_norm_ol
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // Gas or other blockchain fee:
    Row {
      id: gasDetailsRow
      width: parent.width - DawgsStyle.horizontalMargin
      height: gasConvertColumn.height
      spacing: width - gasContextText.width - gasConvertColumn.width
      Text {
        id: gasContextText
        text: qsTr("Gas fee")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: gasConvertColumn
        Text {
          id: gasDisplayText
          text: "gas cost"
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: gasUSDtext
          text: "usd value" // TODO: api.convertAmount(display_data['gas'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
    Rectangle {
      width: parent.width
      height: 2
      color: DawgsStyle.aa_norm_ol
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // Total amount:
    Row {
      id: totalDetailsRow
      width: parent.width - DawgsStyle.horizontalMargin
      height: totalConvertColumn.height
      spacing: width - totalContextText.width - totalConvertColumn.width
      Text {
        id: totalContextText
        text: qsTr("Total amount")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
      }
      Column {
        id: totalConvertColumn
        Text {
          id: totalDisplayText
          text: "total tx cost"
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
        Text {
          id: totalUSDtext
          text: "usd value" // TODO: api.convertAmount(display_data['total'], "USD") ??
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_normal
        }
      }
    }
  }
}//end 'detailsList'
*/