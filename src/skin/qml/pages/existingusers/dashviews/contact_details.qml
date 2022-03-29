import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/contact_details.qml"
//  Displays additional contact details when a contact is interacted with.
/* QQmlDMAbstractItemModelData:
qml: index:
qml: row:
qml: column:
qml: id:
qml: section:
qml: image:
qml: name:
*/
/* ActivityThreadQt:
qml: canMessage:
qml: displayName:
qml: draft:
qml: draftValidator: DraftValidator
qml: participants:
qml: threadID:
qml: canMessageUpdate: function()
qml: displayNameUpdate: function()
qml: draftUpdate: function()
qml: setDraft: function()
qml: pay: function()
qml: paymentCode: function()
qml: sendDraft: function()
*/
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Contact Details.")
	objectName: "dashboard_contact_details"
	background: null //Qt.transparent

	property var contact_model: ({})
	property var activityModel_OT: ({})

	Component.onCompleted: {
		dashViewRoot.contact_model = pageRoot.passAlongData
		pageRoot.clear_passAlong()
		OTidentity.setContactActivityFocus(dashViewRoot.contact_model.id)
		dashViewRoot.activityModel_OT = OTidentity.contactActivityThread_OTModel
		// debugger:
		//console.log("Contact Details:", dashViewRoot.contact_model)
		//QML_Debugger.listEverything(dashViewRoot.contact_model)
		//console.log("Contact Activity:", dashViewRoot.activityModel_OT)
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
			color: "transparent" //(activityDetails.visible ? DawgsStyle.page_bg : "transparent")

			//----------------------
			Column {
				id: headerColumn
				width: parent.width
				height: parent.height
				spacing: 0
				visible: (!activityDetails.visible)
				anchors.horizontalCenter: parent.horizontalCenter
				// Nav back:
				Dawgs_Button {
					id: navBackButton
					width: 52
					opacity: 0.4
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
				// Contact image
				Dawgs_Avatar {
					id: contactAvatarImage
					height: 72
					width: height
					bgcolor: DawgsStyle.page_bg
					avatarUrl: contact_model.image
					contactID: contact_model.id
					anchors.horizontalCenter: parent.horizontalCenter
				}
				// Contact's name:
				Text {
					id: contactNameText
					text: (activityModel_OT !== undefined ? (activityModel_OT.displayName.length > 18 ? 
						activityModel_OT.displayName.slice(0, 18) + "..." : activityModel_OT.displayName ) : "null" );
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_title
					font.weight: Font.Bold
					anchors.horizontalCenter: parent.horizontalCenter
					topPadding: DawgsStyle.verticalMargin
					bottomPadding: 4
				}
				// contact created timestamp
				//TODO:  OT-216
				Text {
					id: contactCreatedText
					text: "creation time stamp"
					visible: false
					color: DawgsStyle.buts_active
					font.pixelSize: DawgsStyle.fsize_normal
					anchors.horizontalCenter: parent.horizontalCenter
					bottomPadding: (DawgsStyle.verticalMargin * 2)
				}
				Rectangle {
					id: spacerRect
					visible: (!contactCreatedText.visible)
					color: "transparent"
					height: (visible ? DawgsStyle.fsize_normal : 0)
					width: height
				}
				// Send button:
				Dawgs_SendButton {
					id: quickSendButton
					anchors.horizontalCenter: parent.horizontalCenter
					onClicked: {
						//TODO: MatterCode or contact model ID
						pageRoot.passAlongData = {
							sendMatterCode: "",
							contactID: dashViewRoot.contact_model.id
						}
						pageRoot.pushDash("dashboard_send_funds")
					}
				}
				Text {
					text: qsTr("send")
					color: DawgsStyle.font_color
					font.pixelSize: DawgsStyle.fsize_normal
					font.weight: Font.Bold
					anchors.horizontalCenter: parent.horizontalCenter
					topPadding: DawgsStyle.verticalMargin
					bottomPadding: DawgsStyle.verticalMargin
				}
			}//end 'headerColumn'

			//----------------------
			MatterFi_ActivityItemDetails {
				id: activityDetails
				width: headerDisplayRect.width
				height: headerDisplayRect.height
				ot_ActivityThread: dashViewRoot.activityModel_OT
				activityItemModel: undefined
				color: DawgsStyle.page_bg
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
		// List all current contact focused transactions/activity:
		MatterFi_ActivityList {
			id: transactionsList
			width: dashViewRoot.width
			height: parent.height - headerDisplayRect.height
			model: dashViewRoot.activityModel_OT
			onSelectedActivity: activityDetails.open(selectedActivityListRow)
			anchors.horizontalCenter: parent.horizontalCenter
		}

	}// end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'