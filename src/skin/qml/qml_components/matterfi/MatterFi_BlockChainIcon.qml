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

  property string abvNotary: "" // ID (type) of block notary to load associated image file.
	property string displayBalance: "" // Alternative method to providing an 'abvNotary' value.

  // On completed, attempt to load svg icon image.
  Component.onCompleted: {
    contextRoot.setIconFile()
  }

	// load the image used for the blockchain icon:
	function setIconFile() {
		if (abvNotary.length > 0) {

      cryptoIconImage.source = "qrc:/crypto-svg/" + contextRoot.abvNotary.toLowerCase()
    } else {
			
			// TODO: confirm with OT that blockchain types will fit here.
			// Abrivated blockchain notory names should be ok if avaliable.
			// *seen 'unitname' on AccountAsset model.
			var fulldisplaybalance = contextRoot.displayBalance
			var abv_notary = fulldisplaybalance.split(" ")[1]
			if (abv_notary !== undefined) {
				// is testnet blockchain notary
				if (abv_notary.includes('t')) {
					abv_notary = abv_notary.replace(/t/g, "test_nets/")
				} else if (abv_notary.includes('tn')) { // unitname
					abv_notary = abv_notary.replace(/tn/g, "test_nets/")
				}
				abv_notary = abv_notary.toLowerCase()
				//contextRoot.abvNotary = abv_notary.toLowerCase()
				cryptoIconImage.source = "qrc:/crypto-svg/" + abv_notary
			} else {
				abv_notary = ""
			}
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