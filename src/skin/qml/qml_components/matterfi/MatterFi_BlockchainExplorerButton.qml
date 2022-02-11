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
  // The base url used for linking transactions to their web explorers:
  readonly property var explorerBaseURLs: {
    'GENERIC': 'https://live.blockcypher.com/',
    //'GENERIC': 'https://www.blockchain.com/search?search=',
    //'GENERIC': 'https://btc.com/' + contextRoot.notary_unitname + '/transaction/',

    'btc': 'https://live.blockcypher.com/btc/tx/',
    'bch': 'https://live.blockcypher.com/bch/tx/',
    'ltc': 'https://live.blockcypher.com/ltc/tx/',
    'pkt': 'https://explorer.pkt.cash/tx/',

    'tbtc': 'https://live.blockcypher.com/btc-testnet/tx/',
    'tltc': 'https://live.blockcypher.com/bch-testnet/tx/',
    'tbch': 'https://live.blockcypher.com/ltc-testnet/tx/'
  }

  //-----------------------------------------------------------------------------
  function setWebURL() {
    //debugger:
    //console.log("Transaction explorer link for:", contextRoot.notary_unitname, contextRoot.txid )
    //QML_Debugger.listEverything(contextRoot.depositChains)
    // set either notary unitname or id
    var notaryid = null
    if (contextRoot.depositChains !== undefined) {
      notaryid = contextRoot.depositChains[0]
    }
    // build the explorer link
    if (notary_unitname === "btc" || notaryid === 1) {
      contextRoot.weburl = explorerBaseURLs['btc'] + contextRoot.txid
    } else if (notary_unitname === "bch" || notaryid === 3) {
      contextRoot.weburl = explorerBaseURLs['bch'] + contextRoot.txid
    } else if (notary_unitname === "ltc" || notaryid === 7) {
      contextRoot.weburl = explorerBaseURLs['ltc'] + contextRoot.txid
    } else if (notary_unitname === "pkt" || notaryid === 9) {
      contextRoot.weburl = explorerBaseURLs['pkt'] + contextRoot.txid
    // Testnets:
    } else if (notary_unitname === "tbtc" || notaryid === 2) {
      contextRoot.weburl = explorerBaseURLs['tbtc'] + contextRoot.txid
    } else if (notary_unitname === "tbch" || notaryid === 4) {
      contextRoot.weburl = explorerBaseURLs['tbch'] + contextRoot.txid
    } else if (notary_unitname === "tltc" || notaryid === 8) {
      contextRoot.weburl = explorerBaseURLs['tltc'] + contextRoot.txid
    } else {
      // Error net:
      console.log("Error: explorer url link to transaction could not be created.")
    }
  }

  //-----------------------------------------------------------------------------
  //TODO: plan ahead for future block chain explorer link support. Perhaps 
  // instead of constructing url, a url property provides one from OT for links.
  Dawgs_TextButton {
    id: openExplorerBut
    text_name: qsTr("View in explorer")
    font_icon: IconIndex.fa_link
    text_color: DawgsStyle.font_color
    qrc_url: (contextRoot.weburl)
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