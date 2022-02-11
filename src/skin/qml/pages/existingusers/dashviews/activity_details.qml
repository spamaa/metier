import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/activity_details.qml"
// When selecting from an AccountActivity transactions list, display additional 
// details about the transaction model selected.
//-----------------------------------------------------------------------------
/* AccountActivityQt
qml: amountValidator: AmountValidator
qml: destValidator: DestinationValidator
qml: scaleModel: DisplayScaleQt
qml: accountID:
qml: balancePolarity:
qml: depositChains:
qml: displayBalance:
qml: syncPercentage:
qml: syncProgress:
qml: dataChanged: function()
qml: balanceChanged: function()
qml: balancePolarityChanged: function()
qml: transactionSendResult: function()
qml: syncPercentageUpdated: function()
qml: syncProgressUpdated: function()
qml: sendToAddress: function()
qml: sendToContact: function()
qml: getDepositAddress: function()
qml: validateAddress: function()
qml: validateAmount: function()
*/
/* QQmlDMAbstractItemModelData:
qml: index:
qml: amount:
qml: description:
qml: type:
qml: contacts:
qml: workflow:
qml: uuid:
qml: polarity:1
qml: memo:
qml: timestamp:
*/
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Activity Details.")
	objectName: "dashboard_activity_details"
	background: null //Qt.transparent

	property var activityModel_OT: ({}) // OT AccountActivityQt

	//----------------------
	Component.onCompleted: {
		// get blockchain model:
		dashViewRoot.activityModel_OT = OTidentity.focusedAccountActivity_OTModel
		// debugger:
		//console.log("Activity Details: ", dashViewRoot.activityModel_OT)
		//QML_Debugger.listEverything(dashViewRoot.activityModel_OT)
	}

	//-----------------------------------------------------------------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

	//----------------------
	Column {
		id: body
		width: parent.width
		height: parent.height
		spacing: 0
		anchors.horizontalCenter: parent.horizontalCenter

		//-----------------------------------------------------------------------------
		Rectangle {
			id: headerDisplayRect
			width: parent.width
			height: 320
			color: (transactionDetails.visible ? DawgsStyle.page_bg : "transparent")

			//----------------------
			Column {
				id: headerColumn
				width: parent.width
				height: parent.height
				spacing: 0
				visible: (!transactionDetails.visible)
				anchors.horizontalCenter: parent.horizontalCenter
				// Nav back:
				Dawgs_Button {
					id: navBackButton
					width: 52
					x: DawgsStyle.horizontalMargin
					justText: true
					iconLeft: true
					manualWidth: true
					fontIcon: IconIndex.fa_chevron_left
					fontFamily: Fonts.icons_solid
					buttonType: "Plain"
					displayText: qsTr("back")
					onClicked: pageRoot.popDash()
				}

				// Blockchain Icon:
				MatterFi_BlockChainIcon {
					id: blockChainIcon
					anchors.horizontalCenter: parent.horizontalCenter
					/*
					abvNotary: (activityModel_OT.unitname !== undefined ? 
						activityModel_OT.unitname : ""
					);
					*/
					//TODO: get AccountActivity unit name instead of balance.
					displayBalance: (activityModel_OT.displayBalance !== undefined ? 
						activityModel_OT.displayBalance : ""
					);
				}

				Text {
					id: assetBalanceText
					text: (activityModel_OT !== undefined ? activityModel_OT.displayBalance : "null")
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_title
					font.weight: Font.Bold
					topPadding: DawgsStyle.verticalMargin
					bottomPadding: 4
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
					id: assetUSDText
					text: "$00000 USD"
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_normal
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
					id: assetSyncText
					text: qsTr("Sync %") + (activityModel_OT !== undefined ? activityModel_OT.syncPercentage.toFixed(2) : "null")
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_normal
					bottomPadding: (DawgsStyle.verticalMargin )
					anchors.horizontalCenter: parent.horizontalCenter
				}

				// Send button:
				Dawgs_SendButton {
					id: quickSendButton
					anchors.horizontalCenter: parent.horizontalCenter
					onClicked: {
						pageRoot.passAlongData = { fromAccountID: dashViewRoot.activityModel_OT.accountID }
						pageRoot.pushDash("dashboard_send_funds")
					}
				}
				Text {
					text: qsTr("send")
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_normal
					topPadding: DawgsStyle.verticalMargin
					bottomPadding: DawgsStyle.verticalMargin
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}//end 'headerColumn'

			//----------------------
			// when called upon, will provide a display of a single transaction's details
			MatterFi_TransactionDetails {
				id: transactionDetails
				width: headerDisplayRect.width - (DawgsStyle.horizontalMargin * 2)
				height: headerDisplayRect.height
				activityModel: dashViewRoot.activityModel_OT
				anchors.centerIn: parent
			}
		}//end 'headerDisplayRect'

		//-----------------------------------------------------------------------------
		Rectangle {
			id: historyViewDivider
			height: 2
			width: bgRect.width
			color: DawgsStyle.aa_norm_ol
		}

		//-----------------------------------------------------------------------------
		// List all transactions:
		MatterFi_TransactionList {
			id: transactionsList
			width: dashViewRoot.width
			height: parent.height - headerDisplayRect.height
			model: dashViewRoot.activityModel_OT
			onSelectedActivity: transactionDetails.open(selectedActivityListRow)
			anchors.horizontalCenter: parent.horizontalCenter
		}

	}// end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'