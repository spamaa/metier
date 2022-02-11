import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// "MatterFi_BlockchainExplorerButton.qml"
// Creates and provides an interaction Object to open the system's browser for
// displaying to the user transaction details outside of the application.
//-----------------------------------------------------------------------------
Item {
	id: contextRoot

  property string notary_unitname: "" // The abrviated notary name used for blockcahin url construction.
  property var depositChains: undefined // List of applicable notary ids.
  property string txid: ""   // The transaction ID of the account activity.
  property string weburl: "" // Constructed blockchain browser explorere link.

  //-----------------------------------------------------------------------------
  //TODO: get notary abbreviation (unitname) from focused block.
  // The base url used for linking transactions to their web explorers:
  readonly property var explorerBaseURLs: {
    'GENERIC': 'https://live.blockcypher.com/',
    //'GENERIC': 'https://www.blockchain.com/search?search=',
    //'GENERIC': 'https://btc.com/' + contextRoot.notary_unitname + '/transaction/',

    'btc': 'https://live.blockcypher.com/btc/tx/',
    'ltc': 'https://live.blockcypher.com/ltc/tx/',
    'pkt': 'https://explorer.pkt.cash/tx/',

    'tbtc': 'https://live.blockcypher.com/btc-testnet/tx/'
  }

  //-----------------------------------------------------------------------------
  function setWebURL() {
    //debugger:
    console.log("Transaction explorer link for:", 
      contextRoot.notary_unitname, contextRoot.txid );
    QML_Debugger.listEverything(contextRoot.depositChains)
    // build the explorer link
    contextRoot.weburl = explorerBaseURLs['pkt'] + contextRoot.txid
  }

  //-----------------------------------------------------------------------------
  //TODO: plan ahead for future block chain explorer link support. Perhaps 
  // instead of constructing url, a url property provides one from OT for links.
  Dawgs_TextButton {
    id: openExplorerBut
    text_name: qsTr("View in explorer ") //+ IconIndex.
    qrc_url: (contextRoot.weburl)
    color: DawgsStyle.font_color
    enabled: (contextRoot.visible)
    anchors.centerIn: parent

    onLinkActivated: {
      api.openSystemBrowserLink(contextRoot.weburl)
      //debugger:
      console.log("Opening system browser:", contextRoot.weburl)
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'