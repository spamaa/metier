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
// Main wallet display page, shows accounts summary, transactions, contacts.
// Centered highlight is customizable flipable spacecard Component.
//-----------------------------------------------------------------------------
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("User Dashboard")
	objectName: "wallet_dashboard"
	background: null //Qt.transparent

	property var passAlongData: undefined // used to share models between stack views.

	Component.onCompleted: {
		// If set to debug view for dashboard page component, display that page for DashView.
		if (DawgsStyle.debug_dashboard_frame !== "") {
			console.log("Debug navigation for DashView to:", DawgsStyle.debug_dashboard_frame)
			pageRoot.pushDash(DawgsStyle.debug_dashboard_frame)
		}
	}
	//----------------------
	// In order to better manage items in the stack for preventing duplications
	// item's are checked by their objectName properties for existance when pushing.
	readonly property var qmlViews_toNames: {
		'dashboard_activity_details':  "qrc:/dashviews/activity_details.qml",
		'dashboard_add_token':         "qrc:/dashviews/add_tokens.qml",
		'dashboard_asset_choice':			 "qrc:/dashviews/asset_choice.qml",
		'dashboard_asset_view_address':"qrc:/dashviews/view_asset_address.qml",
		'dashboard_change_profile': 	 "qrc:/dashviews/change_profile.qml",
		'dashboard_contact_details':   "qrc:/dashviews/contact_details.qml",
		'dashboard_create_contact':    "qrc:/dashviews/create_contact.qml",
		'dashboard_link_spacecard': 	 "qrc:/dashviews/link_spacecard.qml",
		'dashboard_lost_spacecard':    "qrc:/dashviews/lost_spacecard.qml",
		'dashboard_manage_assets':     "qrc:/dashviews/manage_assets.qml",
		'dashboard_nft_collection':		 "qrc:/dashviews/nft_collection.qml",
		'dashboard_nft_details':			 "qrc:/dashviews/nft_details.qml",
		'dashboard_nym_create':				 "qrc:/dashviews/nym_create.qml",
		'dashboard_nym_restore':			 "qrc:/dashviews/nym_restore.qml",
		'dashboard_rename_wallet':     "qrc:/dashviews/rename_wallet.qml",
		'dashboard_root':  					   "qrc:/dashviews/root.qml",
		'dashboard_send_funds':        "qrc:/dashviews/send_funds.qml",
		'dashboard_view_seedphrase':   "qrc:/dashviews/view_seedphrase.qml",
		'advanced_wallet_details':     "qrc:/pages/existingusers/advanced_wallet_details.qml"
	}

	// clear the temp data pointer used to pass information with in navigation routes:
	function clear_passAlong() {
		pageRoot.passAlongData = undefined
	}

	//-----------------------------------------------------------------------------
	property int dashStackViewlength: 0
	// Current section display management. These are accessed via 'pageRoot'.
	function pushDash(dashqml_objectname) {
		// make sure to not duplicate views when adding to the stack.
		var existing_index = -1
		var existing_item = dashStackView.find( function(item, index) {
			if (item.objectName === dashqml_objectname) {
				existing_index = index
				return true
			}
			return false
		});
		// create a new view and display
		var dash_qmlfile = qmlViews_toNames[dashqml_objectname]
		if (dash_qmlfile !== undefined) {
			//console.log("Dash ViewStack pushing new view.", dash_qmlfile)
			var dashroot_item = dashStackView.find( function(item, index) {
				// if item is dash root, clear any context display elment variables for returning.
				if (item.objectName === "dashboard_root") {
					item.prepDashStackViewChange()
					return true
				}
			});
			dashStackView.push(dash_qmlfile)
		} else {
			console.log("Error: dashview stack requires that views be key'd by objectName.", dashqml_objectname)
		}
		// remove exisiting to create new at last index for current viewstack
		if (existing_item !== null) {
			//console.log("Removing existing item from the dashboard stack view.", existing_index, existing_item)
			dashStackView.pop(existing_item)
		}
		pageRoot.dashStackViewlength = dashStackView.depth
	}
	//----------------------
	// navigate back a dash view in stack and remove last view from stack.
	function popDash() {
		//console.log("Dash ViewStack popping current.")
		dashStackView.pop()
		pageRoot.dashStackViewlength = dashStackView.depth
	}
	//----------------------
	// clear entire stackview and set root dispaly to arg passed:
	function clearDashHome(dash_qmlfile = "dashboard_root") {
		//console.log("Dash ViewStack re-rooted to:", dash_qmlfile)
		dashStackView.clear()
		pageRoot.pushDash(dash_qmlfile)
	}

	//-----------------------------------------------------------------------------
	// Set the page header as the 
	header: Dashboard_HeaderBar {
		id: headerToolBar
		displayText: (OTidentity.profile_OTModel.displayName)
	}

	//-----------------------------------------------------------------------------
	// Current section deligate handler:
	StackView {
		id: dashStackView
		y: 2
		width: parent.width
		height: parent.height - y
		initialItem: "qrc:/dashviews/root.qml"
		anchors.horizontalCenter: parent.horizontalCenter
		//----------------------
		background: Rectangle {
			id: bgFiller
			width: parent.width
			height: parent.height
			color: "transparent"
		}
		//----------------------
		// Tranisition to new card shown:
		pushEnter: Transition {
			YAnimator {
				from: dashStackView.height;	to: 0
				duration: 400;
				easing.type: Easing.OutQuint
			}
		}
		// remove last on enter new
		pushExit: Transition {
			OpacityAnimator {
				from: 1.0; to: 0.0; duration: 400
				easing.type: Easing.OutQuint
			}
		}
		// on popping current, fade last back
		popEnter: Transition {
			OpacityAnimator {
				from: 0.0; to: 1.0; duration: 400
				easing.type: Easing.OutQuint
			}
		}
		// fade away when done with popping
		popExit: Transition {
			YAnimator {
				from: 0; to: dashStackView.height
				duration: 400;
				easing.type: Easing.OutQuint
			}
		}
	}//end 'dashStackView'

	//-----------------------------------------------------------------------------
	// Seprate additional OS windows to show:
	/*
	function showAdvancedDetailsWindow() {
		advancedAccountDetailsWindow.load_qml_file()
		advancedAccountDetailsWindow.show()
		advancedAccountDetailsWindow.requestActivate()
	}

	NewWindow {
		id: advancedAccountDetailsWindow
		visible: false
		loaded_qml_file: "qrc:/pages/existingusers/advanced_wallet_details.qml"

		onClosing: {
			console.log("AccountDetails window was closed.")
		}
	}
	*/
//-----------------------------------------------------------------------------
}//end 'pageRoot'