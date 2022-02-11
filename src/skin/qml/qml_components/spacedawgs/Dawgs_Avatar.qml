import QtQuick 2.15
import QtQuick.Controls 2.15

import QtGraphicalEffects 1.12

import "qrc:/styling"
//-----------------------------------------------------------------------------
// Dawgs_Avatar.qml
// Used when for displaying any OT Profile weather that be User or a Contact.
//-----------------------------------------------------------------------------
Item {
	id: contextRoot
	width: 80
	height: 80

	property string avatarUrl: ""   // what svg image to display, or base64 string.
	property string paymentCode: "" // used to seed a random dawgs avatar.

	property int bgColorIndex: 0 // index of dawgs bg listed colors.
	property color bgcolor: DawgsStyle.faceBGcolors[bgColorIndex]

	property int faceIndex: 0   // index of dawgs face.svg lised file names.
	property string faceName: DawgsStyle.faceFileNames[faceIndex]

	//----------------------
	// Using 'paymentCode' string pick an index for both BG color and Face svg file.
	function seedPayentCodeFace() {
		var faceSeed = 0
		for (var i=0; i < paymentCode.length; i++) {
			var charValue = paymentCode.charCodeAt(i)
			faceSeed += charValue
		}
		faceSeed = faceSeed % 1000
		contextRoot.faceIndex = faceSeed % DawgsStyle.faceFileNames.length
		contextRoot.bgColorIndex = (faceSeed / 5) % DawgsStyle.faceBGcolors.length
		contextRoot.faceName = DawgsStyle.faceFileNames[faceIndex]
		contextRoot.bgcolor = DawgsStyle.faceBGcolors[bgColorIndex]
		// debugger:
		//console.log("Dawgs Face:", faceName, bgcolor, faceSeed, paymentCode)
	}

	Component.onCompleted: {
		if (paymentCode.length > 0) {
			contextRoot.seedPayentCodeFace()
		}
	}

	//-----------------------------------------------------------------------------
	// Main 'body' Deligate.
	Rectangle {
		id: body
		width: contextRoot.width
		height: width
		color: contextRoot.bgcolor
		//border.color: DawgsStyle.buta_selected // DawgsStyle.faceBGcolors[0]
    //border.width: 2
		radius: height / 2
		anchors.centerIn: parent

		//----------------------
		// Use placeholder if no avatar was loaded:
		Rectangle {
			width: defaultPlaceholderImage.width
			height: defaultPlaceholderImage.height
			color: "transparent"
			anchors.centerIn: parent

			Image {
				id: defaultPlaceholderImage
				width:  contextRoot.width  * 1.3
				height: contextRoot.height * 1.3
				x: 0 - width / 64
				sourceSize.width:  150
				sourceSize.height: 150
				source: "qrc:/assets/faces/" + contextRoot.faceName + ".svg"
				fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
				//smooth: true
				mipmap: true
			}
		}
		//----------------------
		// Retrive the Avatar, then draw it:
		Image {
			id: avatarImage
			property string imgUrl: contextRoot.avatarUrl.trim()
			source: imgUrl
			width: contextRoot.width
			height: contextRoot.height
			sourceSize.width: contextRoot.width
			sourceSize.height: contextRoot.height
			fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
			smooth: true

			onCacheChanged: {
				if (contextRoot.avatarUrl.length > 0) {
					defaultPlaceholderImage.visible = false
				}
			}
		}
		//----------------------
		// Rounding image mask used
		layer.enabled: true
		layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
			maskSource: mask
		}

		Rectangle {
			id: mask
			width: 150
			height: 150
			radius: width / 2
			visible: false
		}

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'contextRoot'
