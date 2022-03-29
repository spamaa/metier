import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// "MatterFi_AccountListDelegate.qml"
// Delegate for "AccountList" model display. This is where user "AccountActivity"
//  for each Account in their wallet is displayed for selection.
//
// Roles { notary unit account balance polarity accounttype contractid }
/*
enum Columns {
    NotaryNameColumn     = 0
    DisplayUnitColumn    = 1
    AccountNameColumn    = 2
    DisplayBalanceColumn = 3
};
*/
//-----------------------------------------------------------------------------
Item {
	id: contextRoot

	property var listEntry: ({}) // an OT AccountList model, this would be a Row from that Model.
	property var indexEntry: 0   // the index of this Row display from the OT AccountList model.

	property bool isEnabled: true

	signal action() // called when clicked on (or) interacted with.

	//-----------------------------------------------------------------------------
	Component.onCompleted: {
		// debugger:
		console.log("user_accounts.qml MatterFi_AccountListDelegate: ", contextRoot.indexEntry)
		QML_Debugger.listEverything(listEntry)
		//QML_Debugger.listEverything( listEntry.index(contextRoot.indexEntry, 0) )
	}

	//-----------------------------------------------------------------------------
	// Main 'body' display container.
	Rectangle {
		id: body
		scale: shrunk ? DawgsStyle.but_shrink : 1.0
		width: parent.width
		height: parent.height
		color: DawgsStyle.norm_bg
		//gradient: DawgsStyle.accent_gradient
		radius: 4.0
		property bool shrunk: false
		
		//-----------------------------------------------------------------------------
		// Provides a layout for the contents deligating information for AccountList entry.
		Column {
			id: bodyContents
			width: body.width
			height: body.height
			spacing: 0

			Text {
				text: listEntry.account
				color: DawgsStyle.font_color
				font.pixelSize: DawgsStyle.fsize_normal
				verticalAlignment: Text.AlignVCenter
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}//end 'bodyContents'

		//-----------------------------------------------------------------------------
		// Mark area around body as Input area.
		MouseArea {
			id: inputArea
			width: body.width
			height: body.height
			hoverEnabled: false
			enabled: contextRoot.isEnabled

			onClicked: {
				body.shrunk = true
				animationTimer.restart()
			}

			onPressed: { }
			onReleased: { }
			onEntered: { }
			onExited: { }

			Timer {
				id: animationTimer
				interval: 300
				onTriggered: {
					body.shrunk = false
					contextRoot.action()
				}
			}
		}

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'contextRoot'


