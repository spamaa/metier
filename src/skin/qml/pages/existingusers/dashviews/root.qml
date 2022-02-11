import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/page_components"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/root.qml"
// The main dashboard view. This displays the spacecard and serves as a hub.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard root hub.")
	objectName: "dashboard_root"
	background: null //Qt.transparent

	// Props in qml can not rely on notifiables, so we grab currency count a bit later:
	property int currencyCount: 0
	Component.onCompleted: {
		dashViewRoot.currencyCount = api.enabledCurrencyCount
	}

	//----------------------
	// When navigating, clear any display variables used for screen element states.
	function prepDashStackViewChange() {
		userSpacecardDeligate.resetState()
		userSpacecardDeligate.state = "idle"
	}

  //-----------------------------------------------------------------------------
	// Draw space card above the dynamic bottom half of the dashboard.
	Dashboard_SpaceCard {
		id: userSpacecardDeligate
		width: body.width
		y: 4
		userPaymentCode: OTidentity.profile_OTModel.paymentCode
		anchors.horizontalCenter: parent.horizontalCenter
	}
	
	//-----------------------------------------------------------------------------
	// Main display 'body' container.
	Column {
		id: body
		width: pageRoot.width //- (DawgsStyle.horizontalMargin * 2)
		height: pageRoot.height - headerToolBar.height
		visible: (opacity > 0)
		y: userSpacecardDeligate.visibleHeight + DawgsStyle.verticalMargin
		spacing: 12
		anchors.horizontalCenter: parent.horizontalCenter

		//-----------------------------------------------------------------------------
		// Deligate the interactive Tab button group to provide user selections:
		Row {
			id: dashboardTabContextButtons
			height: tabAssets.height
			spacing: 0
			anchors.horizontalCenter: parent.horizontalCenter
			//----------------------
			// Set Tab view options:
			Dawgs_TabGroupButton {
				id: tabAssets
				text: qsTr("Assets")
				textPadding: 10
				checked: true
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
			Dawgs_TabGroupButton {
				id: tabCollectibles
				text: qsTr("NFTs")
				textPadding: 12
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
			Dawgs_TabGroupButton {
				id: tabActivity
				text: qsTr("Activity")
				textPadding: 10
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
			Dawgs_TabGroupButton {
				id: tabContacts
				text: qsTr("Contacts")
				textPadding: 10
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
		}
		// Manage display updates depending on selection context Tab for viewing associated data.
		ButtonGroup { 
      id: tabDisplayBeltButtonGroup
      exclusive: true
      property var selected_item: tabAssets.text

      onClicked: {
        if (selected_item !== button.text) {
					selected_item = button.text
					switch (selected_item) {
						case "NFTs":
							dashboardTabViewLoader.sourceComponent = collectablesComponent
							break;
						case "Activity":
							dashboardTabViewLoader.sourceComponent = transactionsComponent
							break;
						case "Contacts":
							dashboardTabViewLoader.sourceComponent = contactsComponent
							break;
						default: // "Assets"
							dashboardTabViewLoader.sourceComponent = assetsComponent
					}
        }
      }
    }
		// Create a deligation view box to contain selected tab's context component:
		Rectangle {
			id: viewRectTabContextSelection
			width: body.width
			height: body.height - dashboardTabContextButtons.height - userSpacecardDeligate.visibleHeight - (body.spacing * 2)
			color: "transparent"
			anchors.horizontalCenter: parent.horizontalCenter

			//----------------------
			// Only load the dash component list that is in view.
			Loader {
				id: dashboardTabViewLoader
				anchors.fill: parent
				sourceComponent: assetsComponent
			}
			// Viewing wallet Account Assets:
			Component {
				id: assetsComponent
				Dashboard_Assets {
					id: walletAssets
					onAction: pageRoot.pushDash("dashboard_activity_details")
				}
			}
			// Viewing Collectibles:
			Component {
				id: collectablesComponent
				Dashboard_Collectibles {
					id: userCollectibles
				}
			}
			// Viewing Transactions:
			Component {
				id: transactionsComponent
				Dashboard_Transactions {
					id: transactionHistory
				}
			}
			// Viewing Contacts:
			Component {
				id: contactsComponent
				Dashboard_Contacts {
					id: profileContacts
					y: (contactListisEmpty ? 0 : -8)
					onAction: {
						pageRoot.passAlongData = current_contact_sel // expecting OT contact model.
						pageRoot.pushDash("dashboard_contact_details")
					}
				}
			}
		}//end 'viewRectTabContextSelection'

		//----------------------
		// Bottom menu animation played when flipping spacecard:
		state: "idle"
		states: [
			State {
				name: "idle"
			},
			State {
				name: "options"
				when: userSpacecardDeligate.showCustomizeOptions
				PropertyChanges { target: body; opacity: 0.0 }
				PropertyChanges { target: customizeSpacecard; opacity: 1.0; y: body.y; state: "open" }
			},
			State {
				name: "back"
				when: (!userSpacecardDeligate.showCustomizeOptions && userSpacecardDeligate.flipped)
				PropertyChanges { target: body; opacity: 0.0 }
			}
		]

    transitions: [
			Transition {
				NumberAnimation { target: customizeSpacecard; property: "opacity"; duration: 180 }
				NumberAnimation { target: customizeSpacecard; property: "y"; duration: 500; 
					easing.type: Easing.OutBack; easing.amplitude: 0.5; easing.period: 0.6; easing.overshoot: 1.0
				}
				NumberAnimation { target: body; property: "opacity"; duration: 400 }
			},
			Transition {
				NumberAnimation { target: body; property: "opacity"; duration: 400 }
				NumberAnimation { target: customizeSpacecard; property: "y"; duration: 500; 
					easing.type: Easing.InCubic; easing.amplitude: 0.8;
				}
			}
		]
	}//end 'body'

	//-----------------------------------------------------------------------------
	// Display spacecard customization drawer:
	Dashboard_SpaceCardCustomize {
		id: customizeSpacecard
		width: body.width
		height: dashboardTabContextButtons.height + viewRectTabContextSelection.height + DawgsStyle.verticalMargin
		y: dashViewRoot.height
		visible: (opacity > 0.1)
		opacity: 0.0
		anchors.horizontalCenter: parent.horizontalCenter

		onCloseSettings: {
			userSpacecardDeligate.flipped = false
			userSpacecardDeligate.showCustomizeOptions = false
		}

		onFlipCard: {
			userSpacecardDeligate.flipped = !userSpacecardDeligate.flipped
		}
	}

	//-----------------------------------------------------------------------------
	// Quick send funds:
	Dawgs_SendButton {
		id: quickSendButton
		x: dashViewRoot.width - width - (DawgsStyle.horizontalMargin * 2)
		y: dashViewRoot.height - height - (DawgsStyle.verticalMargin * 2)
		visible: (!customizeSpacecard.visible && dashViewRoot.currencyCount > 0)
		onClicked: pageRoot.pushDash("dashboard_send_funds")
	}

//-----------------------------------------------------------------------------
}//end 'dashViewRoot'