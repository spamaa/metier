import QtQuick 2.15
import QtQml.Models 2.1

import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_shared"
import "qrc:/styling/cust_formaters"

//-----------------------------------------------------------------------------
// Display delegate for contact activity. Creates a user ActivityThread 
// object for handeling the display of history and message drafting between a 
// user's contacts and them selves. Also displays current focused ContactModel.
//
// ActivityThread OT model notes:
//
// Roles {  }
/*
    sourceModel: QAbstractItemModel
    canMessage: boolean
    displayName: string
    draft: string
    draftValidator: opentxs::ui::implementation::DraftValidator
    participants: [string]
    threadID: string
    submit: function()
    revert: function()
*/
//-----------------------------------------------------------------------------
Item {
	id: widget

	property var contactActivity_model: ({}) // expecting 'ActivityThreadModel'
	property var currentContact_model: ({})  // expecting 'QAbstractItemModel'

	property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text

	//-----------------------------------------------------------------------------
	// Refresh the current contact display target's ActivityThread. Sets which
	// contact activity thread to deligate.
	function refresh(contactActivity, currentContact) {
		// always clear the draft text
		msgDraftTextInput.clear()

		// debugging:
		//console.log("\nContact Thread new:", contactActivity)
		//QML_Debugger.listEverything(contactActivity)
		//console.log("\nWith Contact:", currentContact)
		//QML_Debugger.listEverything(currentContact)
		// make sure that the models passed are with in expectations
		if (currentContact === undefined || contactActivity  === undefined) {
			console.log("CT issue, a provided model is null:", currentContact, contactActivity)
		} else if (currentContact.id !== contactActivity.threadID) {
			console.log("CT issue, models don't match:", currentContact, contactActivity)
			console.log("Thread issue, Contact and Activity models don't match.")
			console.log(currentContact.id, contactActivity.threadID)
		} else {
			//console.log("\nContact Thread refresh:", currentContact, contactActivity)
			widget.contactActivity_model = contactActivity
			widget.currentContact_model  = currentContact
			refreshThreadActivityModelTimer.restart()
			return; // success
		}
		// clear the models if there was an error
		widget.currentContact_model  = ({})
		widget.contactActivity_model = ({})
		// clear last display deligates
		if (widget.activityThreadModelDelegator) {
			widget.activityThreadModelDelegator.model = ({})
		}
	}

	// Called when a busy operation is being triggered.
	property bool isCurrentlyBusy: false
	function displayBusySignal() {
		//console.log("Noted busy signal received.")
		if (widget.activityThreadModelDelegator) {
			widget.activityThreadModelDelegator.model = ({})
		}
		widget.isCurrentlyBusy = true
}

	//-----------------------------------------------------------------------------
	// Called to send what ever is in the draft text space.
	function sendDraft() {
		if (widget.contactActivity_model === undefined) {
			console.log("DraftError: There is no current Activty model.")
			return;
		}
		// check if the text input deligate's hand off for draft 
		// message string input actually has text for a draft in it
		if (msgDraftTextInput.text.length < 1) {
			console.log("Current Draft is empty, can't send message.")
			return;
		}
		// send the message, multiple checks ensure that if the contact has
		// messaging disabled that to not bother sending msg, end user's power
		if (widget.contactActivity_model.canMessage) {
			console.log("Current Draft send request:", msgDraftTextInput.text)
			// set the draft string on the ActivityThread model for that user
			// and participants, then request that the draft string be sent
			widget.contactActivity_model.setDraft(msgDraftTextInput.text)
			widget.contactActivity_model.sendDraft()
			// if the draft was sent, the draft property should be clear
			console.log("Submitted ActivityThread message Draft.", widget.contactActivity_model.draft)
			// clear the container for the draft used in the TextInput deligate
			msgDraftTextInput.clear()
			// jump list to bottom of the veiw
			if (enableAutoScrolling.checked) {
					activityListView.positionViewAtEnd()
			}
		} else {
			// can not message contact, they have messageing disabled on their end
			console.log("Contact can not receive any messages.", widget.contactActivity_model.canMessage)
		}
	}

	//-----------------------------------------------------------------------------
	// Used to refresh the display deligates using the ActivityThread model.
	function updateActivityThreadDisplay() {
		if (widget.contactActivity_model !== undefined) {
			widget.contactActivity_model.dataChanged.disconnect(activityUpdated)
		}
		activityThreadModelDelegator.model = widget.contactActivity_model
		widget.contactActivity_model.dataChanged.connect(activityUpdated)
		// grab any existing message draft held with in the activity thread
		msgDraftTextInput.text = widget.contactActivity_model.draft
		// ensure that the message string entered conforms to character limitations
		//msgDraftTextInput.validator = widget.contactActivity_model.DraftValidator
		// jump list to bottom of the veiw
		if (enableAutoScrolling.checked) {
			activityListView.positionViewAtEnd()
		}
		// celar busy signal
		widget.isCurrentlyBusy = false
	}

	// called on signal that ActivityThread has had a data change.
	function activityUpdated(index, bottomRight, roles) {
		//console.log("ActivityThread had a data change:")
		// jump list to bottom of the veiw
		if (enableAutoScrolling.checked) {
			activityListView.positionViewAtEnd()
		}
	}

	//-----------------------------------------------------------------------------
	// The Main display 'body'
	Rectangle {
		id: body
		width: widget.width
		height: widget.height
		color: "transparent"

		Column {
			id: contactActivityDisplay
			width: body.width
			height: body.height
			spacing: 0
			anchors.horizontalCenter: parent.horizontalCenter
			//----------------------
			// History:
			Rectangle {
				id: chatHistoryRect
				width: parent.width
				height: parent.height - messageDraftControlSpace.height
				color: "transparent"
				anchors.horizontalCenter: parent.horizontalCenter
				// The display DelegateModel for activity thread:
				DelegateModel {
					id: activityThreadModelDelegator
					model: ({})
					//----------------------
					// draw the activitythread entries, exchanges between participants and user
					// this takes care of how the exchange is displayed onto the screen
					delegate: Column {
						id: activityDeligation
						width: chatHistoryRect.width
						height: 128
						// stagger the messages to help clearify direction of its travel
						leftPadding: (model === undefined ? 8 : !model.outgoing ? 8 : width - activityEntryBody.width - 8)
						//----------------------
						// What the activity is painted as (deligation):
						Rectangle {
							id: activityEntryBody
							// props provided by the listView: ['index', 'model']
							// props by an ActivityThread OT model list of models.
							// at this 'index' that 'model' entry has these Roles avalaible:
							/*
									type: int,         from: string,     stramount: string,  intamount: int,
									memo: string,      loading: boolean, polarity: int,      pending: boolean,
									time: time_string, text: string,     outgoing: boolean
							*/
							width: parent.width / 5 * 4
							height: parent.height
							visible: (model !== undefined)
							color: (model === undefined ? "transparent" : model.outgoing ? CustStyle.pkt_logo : CustStyle.accent_fill)
							radius: 8
							anchors.left: parent.anchors.LeftAnchor
							anchors.leftMargin: 20
							// debugger:
							//Component.onCompleted: {
							//    QML_Debugger.listEverything(model)
							//}
							//----------------------
							MatterFi_BusyIndicator {
								id: searchingBusyIndicator
								scale: 1.0
								anchors.centerIn: parent
								visible: (model === undefined ? false : model.loading)
							}
							//----------------------
							// Organize the display data
							Column {
								id: activityBody
								padding: 8
								spacing: 12
								leftPadding: 4
								height: parent.height
								width: parent.width
								visible: (!model.loading)																
								// display name and time stamp
								Row {
									id: messageDetailsRow
									height: parent.height / 4
									width: parent.width
									spacing: width - activityEntryFrom.width - 
											activityEntryTime.width - 8
									// from who
									Text {
										id: activityEntryFrom
										text: (model === undefined ? "" : model.outgoing ? "Message Sent:" : model.from)
										color: pageRoot.fontColor
										font.pixelSize: CustStyle.fsize_normal
										// if displaying a payment code, shorten the string
										Component.onCompleted: {
											var stringlength = model.from.length
											if (model.outgoing !== true && stringlength > 40) {
												var shortstring = ""
												shortstring = model.from.substr(0,15)
												shortstring = shortstring + " ... " + model.from.substr(stringlength - 8, stringlength)
												activityEntryFrom.text = shortstring
											}
										}
									}
									// at what time
									Text {
										id: activityEntryTime
										text: model.time.toLocaleString(Qt.locale(), "ddd MMM d HH:mm:ss yyyy t")
										color: pageRoot.fontColor
										font.pixelSize: CustStyle.fsize_normal
									}
							}
							// main string body display
							Text {
								width: parent.width - 32
								height: (model.amount !== undefined ? 
										32 : parent.height - messageDetailsRow.height - 32 );
								leftPadding: 8
								wrapMode: TextInput.WordWrap
								clip: true
								text: model.text
								color: pageRoot.fontColor
								font.weight: Font.DemiBold
								font.pixelSize: CustStyle.fsize_normal
								//anchors.horizontalCenter: parent.horizontalCenter;
							}
							// if was a transaction note, display amount
							Text {
								width: parent.width - 32
								height: 32
								leftPadding: 8
								wrapMode: TextInput.WordWrap
								clip: true
								visible: (model.amount !== undefined)
								text: model.amount // model.polarity
								color: pageRoot.fontColor
								font.weight: Font.DemiBold
								font.pixelSize: CustStyle.fsize_normal
								//anchors.horizontalCenter: parent.horizontalCenter;
							}
							// pending notification
							BusyIndicator {
								id: pendingBusyIndicator
								scale: 0.5
								smooth: true
								visible: (model === undefined ? false : model.outgoing && model.pending)

								ColorOverlay {
									anchors.fill: parent
									source: pendingBusyIndicator.contentItem
									color: CustStyle.pkt_logo
								}
							}
						}
					}//end 'activityEntryBody'
				}
				//----------------------
			}//end 'activityThreadModelDelegator'

			//----------------------
			// display the activity thread:
			ListView {
				id: activityListView
				clip: true
				z: 1
				width: parent.width
				height: parent.height
				spacing: 8
				model: activityThreadModelDelegator
				header: Rectangle {
					color: "transparent"
					width: parent.width
					height: 8
				}
				footer: Rectangle {
					color: "transparent"
					width: parent.width
					height: 8
				}
				anchors {
					horizontalCenter: parent.horizontalCenter;
				}
			}
			// not so instant refreshing
			Timer {
				id: refreshThreadActivityModelTimer
				interval: 50
				running: false
				onTriggered: {
					//console.log("refreshing ActivityThread model deligate.")
					widget.updateActivityThreadDisplay()
				}
			}
			// outline the contact and user's message/activity history
			OutlineSimple {
				outline_color: CustStyle.pkt_logo
				z: 2
			}
		}//end 'chatHistoryRect'

		//----------------------
		// Drafting interactions space:
		Rectangle {
				id: chatDraftTextRectBackground
				width: parent.width
				height: parent.height / 6
				color: CustStyle.accent_fill //accent_normal
				anchors.horizontalCenter: parent.horizontalCenter

				Column {
					id: messageDraftControlSpace
					width: parent.width
					height: parent.height
					topPadding: 4
					leftPadding: 24
					spacing: 4
					anchors.horizontalCenter: parent.horizontalCenter
					// outline the input box
					Rectangle {
						implicitWidth: msgDraftTextInput.width
						implicitHeight: msgDraftTextInput.height
						color: CustStyle.neutral_fill
						radius: 4
						anchors.horizontalCenter: parent.horizontalCenter
						// draft text input area
						TextInput {
							id: msgDraftTextInput
							width: messageDraftControlSpace.width - 16
							height: messageDraftControlSpace.height / 3 * 2 - messageDraftControlSpace.topPadding
							maximumLength: 256
							padding: 8

							// ToDo:
							// Unable to assign [undefined] to QValidator*
							//validator: widget.contactActivity_model.DraftValidator // is not a function

							wrapMode: TextInput.WordWrap
							clip: true
							color: widget.fontColor
							// prevent message drafting if contact has messaging disabled
							readOnly: (widget.contactActivity_model === undefined ? 
									true : widget.contactActivity_model.canMessage !== true)
							anchors.horizontalCenter: parent.horizontalCenter
							
							// send on enter pressed
							onAccepted: {
								widget.sendDraft()
							}
						}
					}
					// draw the footer of the draft display area
					Row {
						id: draftToolBoxFooter
						spacing: 16
						height: 32
						// Send button
						FontIconButton {
							id: profileContextButton
							iconChar: IconIndex.envelope
							iconSize: parent.height
							anchors.verticalCenter: parent.verticalCenter
							onAction: {
								widget.sendDraft()
							}
						}
						// auto scroll enabled?
						MatterFi_CheckBox {
							id: enableAutoScrolling
							checked: true
							text: qsTr("Auto Scroll")
							anchors.verticalCenter: parent.verticalCenter
							onToggled: {
								if (checked) {
									activityListView.positionViewAtEnd()
								}
							}
						}
					}//end 'draftToolBoxFooter'

				}//end 'messageDraftControlSpace'
			}//end 'chatDraftTextRectBackground'

			//----------------------
		}//end 'contactActivityDisplay'

	//-----------------------------------------------------------------------------
	}//end 'body'
}//end 'widget'