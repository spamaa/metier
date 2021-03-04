import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Display delegate for BlockChainStatistics.
/*
Roles { // QML usually helps turn these into properties on the model by simular name.
  Balance = Qt::UserRole + 0,       // int, opentxs::blockchain::Amount
  BlockQueue = Qt::UserRole + 1,    // int, std::size_t
  Chain = Qt::UserRole + 2,         // int, opentxs::blockchain::Type
  FilterHeight = Qt::UserRole + 3,  // int, opentxs::blockchain::block::Height
  HeaderHeight = Qt::UserRole + 4,     // int, opentxs::blockchain::block::Height
  Name = Qt::UserRole + 5,             // QString
  ActivePeerCount = Qt::UserRole + 6,     // int, std::size_t
  ConnectedPeerCount = Qt::UserRole + 7,  // int, std::size_t
}
*/
//----------------------
// Column data requires a .data vailid index look up for retrivial:
//  Columns {
//    NameColumn = 0,
//    BalanceColumn = 1,
//    HeaderColumn = 2,
//    FilterColumn = 3,
//    ConnectedPeerColumn = 4,
//    ActivePeerColumn = 5,
//    BlockQueueColumn = 6,
//  };


//-----------------------------------------------------------------------------
Item {
  id: widget
  width: 120
  height: 42
  
  //-----------------------------------------------------------------------------
  // Set starting data container:
  property var blockchainStatistics_OTmodel: ({}) // the OT BlockChainStatistics
  Component.onCompleted: {
    widget.blockchainStatistics_OTmodel = otwrap.blockchainStatisticsModelQML()
    // debugger:
    //console.log("BlockChainStatistics: ", blockchainStatistics_OTmodel)
    //QML_Debugger.listEverything(blockchainStatistics_OTmodel)
    blockchainStatistics_OTmodel.dataChanged.connect(widget.on_datachanged)
  }

  Component.onDestruction: {
    if (widget.blockchainStatistics_OTmodel !== undefined) {
      blockchainStatistics_OTmodel.dataChanged.disconnect(widget.on_datachanged)
    }
  }

  //-----------------------------------------------------------------------------
  // hold onto localy tracked properties with built in signals for update triggers
  // in display data shown
  property var bcsOT_name: ""
  property var bcsOT_balance: ""
  property var bcsOT_header: ""
  property var bcsOT_filter: ""
  property var bcsOT_connectedPeers: ""
  property var bcsOT_activePeers: ""
  property var bcsOT_blockedQueue: ""
  // Update the blockchainStatistics display model data
  function on_datachanged(index, bottomRight, roles) {
    // update column display values used in QML:
    if (widget.blockchainStatistics_OTmodel !== undefined) {
      // Put each Column value into a hash for display:
      widget.bcsOT_name = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 0) ); // NameColumn
      widget.bcsOT_balance = blockchainStatistics_OTmodel.data(
        blockchainStatistics_OTmodel.index(0, 1) ); // BalanceColumn
      widget.bcsOT_header  = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 2) ); // HeaderColumn
      widget.bcsOT_filter  = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 3) ); // FilterColumn
      widget.bcsOT_connectedPeers = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 4) ); // ConnectedPeerColumn
      widget.bcsOT_activePeers  = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 5) ); // ActivePeerColumn
      widget.bcsOT_blockedQueue = blockchainStatistics_OTmodel.data( 
        blockchainStatistics_OTmodel.index(0, 6) ); // BlockQueueColumn
      // debugger:
      //console.log("Refreshed BlockChainStatistics Column data: ", widget.blockChainStatsModelData )
      //QML_Debugger.listEverything(blockChainStatsModelData)
    } else {
      widget.blockChainStatsModelData = undefined
    }
  }

  //-----------------------------------------------------------------------------
  // The main 'body' display containter QObject.
  Rectangle {
    id: body
    color: "transparent"
    width: parent.width
    height: parent.height
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Row {
      id: statisticsDisplayRow
      width: parent.height
      spacing: 16

      anchors {
        margins: 8;
        top: parent.top;
        left: parent.left;
        verticalCenter: parent.verticalCenter;
        horizontalCenter: parent.horizontalCenter;
      }
      //----------------------
      Text {
        id: connectedPeersText
        color: CustStyle.theme_fontColor
        text: (widget.bcsOT_connectedPeers === undefined ? 
          qsTr("Connected Peers: 0") : qsTr("Connected Peers: ") + widget.bcsOT_connectedPeers)
        font.pixelSize: CustStyle.fsize_button
        smooth: true
      }
      //----------------------
      Text {
        id: activePeersText
        color: CustStyle.theme_fontColor
        text: (widget.bcsOT_activePeers === undefined ? 
          qsTr("Active Peers: 0") : qsTr("Active Peers: ") + widget.bcsOT_activePeers)
        font.pixelSize: CustStyle.fsize_button
        smooth: true
      }
      //----------------------
      Text {
        id: blockedQueueText
        color: CustStyle.theme_fontColor
        text: (widget.bcsOT_blockedQueue === undefined ? 
          qsTr("Outstanding Blocks: 0") : qsTr("Outstanding Blocks: ") + widget.bcsOT_blockedQueue)
        font.pixelSize: CustStyle.fsize_button
        smooth: true
      }
      //----------------------
      /*
      Text {
        id: nameDisplayText
        color: CustStyle.theme_fontColor
        text: (qsTr("BlockChain: ") + widget.bcsOT_name)
        font.pixelSize: CustStyle.fsize_button
        smooth: true
      }
      //----------------------
      Text {
        id: balanceDisplayText
        color: CustStyle.theme_fontColor
        text: (qsTr("Balance: ") + widget.bcsOT_balance)
        font.pixelSize: CustStyle.fsize_button
        smooth: true
      }
      */

    }

  //-----------------------------------------------------------------------------
  }//end 'body'

//-----------------------------------------------------------------------------
}//end 'widget'