import QtQuick 2.15
import QtQuick.Controls 2.15

import QtGraphicalEffects 1.12

import "qrc:/styling"
//-----------------------------------------------------------------------------
// MatterFi_BlockChainIcon.qml
// Provides the loading of Images that display a blockchain icon.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width:  72
  height: 72

  property string abvNotary: ""         // unitname of block notary to load associated image file.
	property string notaryType: ""        // ID (blockchain type) to use when generating an icon.
	property var depositChains: undefined // List of chain types associated to an Activity.

  // On completed, attempt to load svg icon image.
  Component.onCompleted: {
		if (contextRoot.visible) {
    	contextRoot.setIconFile()
		}
  }

	// TODO: bugzilla#291
	// load the image used for the blockchain icon:
	function setIconFile() {
		// setting the icon from depositchain information
		if (contextRoot.depositChains !== undefined) {
			contextRoot.notaryType = contextRoot.depositChains[0] // first index
		}
		// set unitname from blockchain type id
		if (contextRoot.notaryType.length > 0) {
			switch (contextRoot.notaryType) {
			// Livechains:
			case "1":
				contextRoot.abvNotary = "btc"
				break;
			case "3":
				contextRoot.abvNotary = "bch"
				break;
			case "7":
				contextRoot.abvNotary = "ltc"
				break;
			case "9":
				contextRoot.abvNotary = "pkt"
				break;
			// Testnets:
			case "2":
				contextRoot.abvNotary = "test_nets/btc"
				break;
			case "4":
				contextRoot.abvNotary = "test_nets/bch"
				break;
			case "8":
				contextRoot.abvNotary = "test_nets/ltc"
				break;
			default:
				console.log("Warn: manual blockchain unit/type id not included.")
			}
			if (contextRoot.abvNotary.length > 0) {
				cryptoIconImage.source = "qrc:/crypto-svg/" + contextRoot.abvNotary
			} else {
			  console.log("Warn: Blockchain icon:", contextRoot.notaryType, contextRoot.abvNotary)
			}
			return;
		// the notary/unitname was provided
		} else if (contextRoot.abvNotary.length > 0) {
      var abv_notary = contextRoot.abvNotary
    } else {
			//console.log("Warn: Blockchain image could not be resolved.")
		}
		// if have an 'abv_notary' use it to build icon url
		if (abv_notary !== undefined) {
			// is testnet blockchain notary
			if (abv_notary.includes('tn')) {
				abv_notary = abv_notary.replace(/tn/g, "test_nets/")
			} else if (abv_notary.includes('t')) { // unitname
				abv_notary = abv_notary.replace(/t/g, "test_nets/")
			}
			abv_notary = abv_notary.toLowerCase()
			cryptoIconImage.source = "qrc:/crypto-svg/" + abv_notary
		}
		//debugger:
		//console.log("BlockChain icon using file:", cryptoIconImage.source)
	}

  //-----------------------------------------------------------------------------
	// Main 'body' Deligate.
	Rectangle {
		id: body
		width: contextRoot.width
		height: contextRoot.height
		color: DawgsStyle.page_bg
		radius: height / 2
    anchors.centerIn: parent
		//----------------------
		// Use placeholder if no icon was found:
		Rectangle {
			id: defaultPlaceholderImage
			width: body.width * 0.9
			height: body.height * 0.9
      color: DawgsStyle.norm_bg
			anchors.centerIn: parent

      Text {
        text: qsTr("Null.")
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_accent
        anchors.centerIn: parent
      }

      layer.enabled: true
			layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
				maskSource: mask
			}
		}
		//----------------------
		// Retrive the Avatar, then draw it:
		Image {
			id: cryptoIconImage
			source: ""
			width: body.width
			height: body.height
			sourceSize.width: body.width
			sourceSize.height: body.height
			fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
			smooth: true
      anchors.centerIn: parent

			layer.enabled: true
			layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
				maskSource: mask
			}

			onCacheChanged: {
				if (contextRoot.abvNotary.length > 0) {
					defaultPlaceholderImage.visible = false
				}
			}
		}
		//----------------------
		// Rounding image mask used
		Rectangle {
			id: mask
			width: 240
			height: 240
			radius: width / 2
			visible: false
		}
  }//end 'body'

//-----------------------------------------------------------------------------
}//end 'contextRoot'