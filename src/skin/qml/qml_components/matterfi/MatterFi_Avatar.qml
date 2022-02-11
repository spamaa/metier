import QtQuick 2.15
import QtQuick.Controls 2.15

import QtGraphicalEffects 1.12

import "qrc:/styling"
//-----------------------------------------------------------------------------
// MatterFi_Avatar.qml
// Used when a profile has an image attatched to the user's contacts list.
//-----------------------------------------------------------------------------
Item {
	id: contextRoot
	width: 80
	height: 80

	property string avatarUrl: ""
	property color bgcolor: "transparent"

	//-----------------------------------------------------------------------------
	// Main 'body' Deligate.
	Rectangle {
		id: body
		width: contextRoot.width
		height: contextRoot.height
		color: contextRoot.bgcolor
		radius: height / 2
		//----------------------
		// Use placeholder if no avatar was loaded:
		Image {
			id: defaultPlaceholderImage
			width: body.width * 0.9
			height: body.height * 0.9
			sourceSize.width: body.width
			sourceSize.height: body.height
			source: "qrc:/assets/matterfi/Matterfi-normal.svg"
			fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
			smooth: true
			layer.enabled: true
			layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
				maskSource: mask
			}
			anchors.centerIn : parent
		}
		//----------------------
		// Retrive the Avatar, then draw it:
		Image {
			id: avatarImage
			property string imgUrl: contextRoot.avatarUrl.trim()
			source: imgUrl
			width: body.width
			height: body.height
			sourceSize.width: body.width
			sourceSize.height: body.height
			fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
			smooth: true

			layer.enabled: true
			layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
				maskSource: mask
			}

			onCacheChanged: {
				if (contextRoot.avatarUrl.length > 0) {
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
