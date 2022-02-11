import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// 'nav404_home.qml'
// Main display page portal. This is like a Root Page used for user navigation.
// If any failure with navigation between display pages or OT state, shows this
// navigation page to assist in returning to a proper screen.
//-----------------------------------------------------------------------------
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("404 Home")
	objectName: "404_home"
	
	background: null //Qt.transparent
	//-----------------------------------------------------------------------------
	Column {
		id: body
		width: parent.width - (DawgsStyle.horizontalMargin * 2 + 8)
		height: parent.height
		topPadding: 128
		spacing: 12

		anchors {
			leftMargin:  DawgsStyle.horizontalMargin + 4 // 16
			rightMargin: DawgsStyle.horizontalMargin + 4 // 16
			horizontalCenter: parent.horizontalCenter
		}

		Image {
			source: "qrc:/assets/splash/logotype.svg"
			smooth: true
			sourceSize.width: 328
			sourceSize.height: 48
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Dawgs_CenteredTitle {
      textTitle: "404"
    }


	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'pageRoot'
