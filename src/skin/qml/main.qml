import QtQuick 2.15
import QtQuick.Window 2.12
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
/*
  Main Application entry point. Creates the Qt5 Window Object.

  Navigation:
        Navigation is handled with 'stackView'. Most required functions
    can be found in 'rootAppPage' for page navigation stack management.

    .pushPage(page.qml)    | add a page to the top of the view/activity stack
    .popPage()             | remove the very last page (on on view top) from stack
    .replacePage(page.qml) | replace current with a new page
    .clearStackHome()      | clear stack down to new, push "nav404_home.qml" or page passed.

  In order to connect to the Open-Transactions library wrapper you need to
  utilize the 'api' rootContext. Sample:

    api.<function>.connect(qml_id.function_name)

*/
//-----------------------------------------------------------------------------
// Since not using ApplicationWindow due to wrapper, need to use equivlent component.
// that will support simular windwo 'header' and maintain pages StackView.
//-----------------------------------------------------------------------------
Page {
	id: rootAppPage

	visible: true
	title: qsTr("Stack")

	property bool drawerIsOpen: false // up keep for active focus

	// OT signal state variables. These are for judging what start up state the App is in.
	property bool isFirstRun:     true  // is the users first run threw app?
	property bool hasProfile:     false // does the user already have a profile?
	property bool mainIsReady:    false // the user has complete all start up requirements?
	property bool stillNeedBlock: false // user still needs to select a blockchain?

	// active focus debugger, which Object is receiving input? -was avaliable in AppWindow
	//onActiveFocusItemChanged: console.log("Item With Focus: ", activeFocusItem)

	property var passAlongData: ({}) // Shared container for sub page tree navigations.

	//-----------------------------------------------------------------------------
	// After splash is displayed, use these signals to set user in route to finish
	// critical setup components if left in the middle of wallet initilization.
	function otSignalFired() {
		//----------------------
		// debugger: Display current signal status:
		console.log("Main OT State Signals |",
			"MR:[",  rootAppPage.mainIsReady,         // Main is Ready
			"] FR:[", rootAppPage.isFirstRun,         // Is the Frist Run
			"] NP:[", !rootAppPage.hasProfile,        // User needs Profile
			"] NB:[", rootAppPage.stillNeedBlock, "]" // Needs a BlockChain
		);
	}

	//-----------------------------------------------------------------------------
	// Grab the current applications focused QWindow object pointer.
	property var osDisplay_window: ({})
	function focusWindowChanged(window_in_focus) {
		if (window_in_focus === null) return;
		// change the title used in the window
		rootAppPage.osDisplay_window = window_in_focus
		rootAppPage.osDisplay_window.setTitle(DawgsStyle.qml_app_name)
		rootAppPage.osDisplay_window.alert(2500) // mili seconds to flash until active
		// watch for changes in window display:
		rootAppPage.osDisplay_window.visibilityChanged.connect(rootAppPage.visibility_changed)
		// watch the active focus item with in the window:
		rootAppPage.osDisplay_window.onActiveFocusItemChanged.connect(rootAppPage.onActiveFocusItemChanged)
	}

	// if nothing is currently active focus, then set the rootAppPage as focus item for
	// Key press events.
	function onActiveFocusItemChanged(focus_item) {
		//QML_Debugger.listEverything(focus_item)
		if (rootAppPage === undefined || rootAppPage === null) return; 
		if (focus_item === undefined && !rootAppPage.drawerIsOpen) {
			focus = true
		}
		//console.log("Keyboard Window Focus Item:", focus_item)
	}

	// Detected a change in window display modes.
	function visibility_changed(visibility) {
		//console.log("Main Window Visibility Changed.", visibility)
		//if (visibility === 5) {
			// return focus to the StackView if swap was to full screen mode
			focus = true
		//}
	}

	// Return screen to Normal window mode.
	function keyEvent_normal_window_size(key_event) {
		//console.log("Test ESC key.")
		if (Qt.platform.os === "osx" || Qt.platform.os === "unix") {
			if (rootAppPage.osDisplay_window !== null) {
				// QWindow::FullScreen == 5
				if (rootAppPage.osDisplay_window.visibility == 5) {
					// if in full screen, return to normal screen
					rootAppPage.osDisplay_window.showNormal()
					key_event.accepted = true
				} else {
					key_event.accepted = false
				}
			} else {
				key_event.accepted = false
			}
		}
	}

	//-----------------------------------------------------------------------------
	// Link OT connections:
	Component.onCompleted: {
		// start persistant data cache
		UIUX_UserCache.start()
		// create app Connections
		startup.displayBlockchainChooser.connect(rootAppPage.display_blockChainChooser);
		startup.displayFirstRun.connect(rootAppPage.display_firstRun);
		startup.displayMainWindow.connect(rootAppPage.display_mainWindow);
		startup.displayNamePrompt.connect(rootAppPage.display_namePrompt);
		// get the focuse QWindow object for things like MenuBar
		metier.focusWindowChanged.connect(rootAppPage.focusWindowChanged);
		// debugger:
		console.log("Connected startup signals from OT:");
	}

	//-----------------------------------------------------------------------------
	// OT state trigger function Connections:
	function display_firstRun() {
		console.log("Startup Step 1: Choose New/Recover.");
		// default is to navigate to the Home screen where selection can be made
		rootAppPage.isFirstRun = true
		rootAppPage.mainIsReady = false
		rootAppPage.hasProfile = false
		rootAppPage.stillNeedBlock = true
	  rootAppPage.otSignalFired();
	}

	function display_blockChainChooser() {
		console.log("Startup Step 2: Choose BlockChain.");
		// if a seed is found, the app needs to jump past generating one
		// or it will fail.
		rootAppPage.mainIsReady = false
		rootAppPage.stillNeedBlock = true
		rootAppPage.isFirstRun = false
		rootAppPage.hasProfile = true
		rootAppPage.otSignalFired();
	}
	
	function display_namePrompt() {
		console.log("Startup Step 3: Ask the user to enter their name.");
		// if the user doesnt have a name, they must make a profile with one
		rootAppPage.mainIsReady = false
		rootAppPage.isFirstRun = false
		rootAppPage.hasProfile = false
		rootAppPage.otSignalFired();
	}

	function display_mainWindow() {
		console.log("Startup Step 4: Show the Main Navigator.");
		// throws user into page navigation for the wallet UI
		rootAppPage.hasProfile = true
		rootAppPage.stillNeedBlock = false
		rootAppPage.isFirstRun = false
		rootAppPage.mainIsReady = true
		rootAppPage.otSignalFired();
	}

	//-----------------------------------------------------------------------------
	// Navigation
	property bool showNavBar: false;
	property bool displaying_popup: false;

	// clear the temp data pointer used to pass information with in navigation trees.
	function clear_passAlong() {
		rootAppPage.passAlongData = ({})
	}

	//-----------------------------------------------------------------------------
	// Stack page control:
	function currentPage() {
		return stackView.currentItem.objectName
	}
	function getStackDepth() {
		return stackView.depth
	}
	// replace current page in stack:
	function replacePage(page) {
		console.log("Nav Replacing Current Page:")
		rootAppPage.popPage()
		rootAppPage.pushPage(page)
	}

	// adding page to stack
	function pushPage(page) {
		var pageName = page.split('/')
		pageName = pageName[pageName.length - 1]
		pageName = pageName.replace('.qml', '')
		if (stackView.depth >= 10) {
			console.warning("Nav StackView is getting past 10 pages! ", stackView.depth)
		}
		stackView.push(page)
		console.log("Nav Push: \"", pageName, "\" Stack depth: ", stackView.depth)
		rootAppPage.readPageDisplayProps()
	}

	// remove last from stack
	function popPage() {
		if (stackView.currentItem == null) {
			console.log("Nav Pop: \"no page to pop\" Stack depth: ", stackView.depth)
			return;
		}
		var lastpageName = stackView.currentItem.objectName.split('/')
		lastpageName = lastpageName[lastpageName.length - 1]
		lastpageName = lastpageName.replace('.qml', '')
		stackView.pop()
		var pageName = stackView.currentItem.objectName
		console.log("Nav Pop: \"", pageName, "\" Stack depth: ", stackView.depth)
		rootAppPage.readPageDisplayProps()
	}

	// clear the stack and return home
	function clearStackHome(page = null) {
		if (stackView.currentItem != null) {
			var pageName = stackView.currentItem.objectName
			console.log("Nav Stack Clearing: \"", pageName, "\" Stack depth was: ", stackView.depth)
			stackView.clear()
		}
		if (page === null) {
			stackView.push("pages/nav404_home.qml")
		} else {
			stackView.push(page)
		}
	}

	//----------------------
	// Sets up Page defined display triggers. Things like an app wide header bar or footer.
	function readPageDisplayProps() {
		// page independent settings:
		if (stackView.currentItem != null) {
			// show app wide header bar?
			if (stackView.currentItem.showNavBar) {
				rootAppPage.showNavBar = true
			} else {
				rootAppPage.showNavBar = false
			}
		// default settings:
		} else {
			rootAppPage.showNavBar = false
		}
	}

	//-----------------------------------------------------------------------------
	// Main Stack:
	StackView {
		id: stackView
		anchors.fill: parent

		// Signals from OT will help set the first page displayed. To ensure critical
		// set up information is not left out of initial account creation.
		initialItem: "pages/splash.qml"

		// Theme bg Color fill
		background: Rectangle {
			id: page_bg_fill
			color: DawgsStyle.page_bg
		}

		//----------------------
		// Tranisition Animations:
		pushEnter: Transition {
			id: pushEnter

			ParallelAnimation {
				PropertyAction {
					property: "x";
					value: pushEnter.ViewTransition.item.pos
				}
				NumberAnimation {
					properties: "y";
					from: pushEnter.ViewTransition.item.pos + stackView.offset;
					to: ( pushEnter.ViewTransition.item.pos !== undefined ? pushEnter.ViewTransition.item.pos : 0.0 );
					duration: 400;
					easing.type: Easing.OutCubic
				}
				NumberAnimation {
					property: "opacity";
					from: 0;
					to: 1;
					duration: 400;
					easing.type: Easing.OutCubic
				}
			}
		}
		// back navigation device button
		// If stackView happens to lose focus, Main window/ active focus item
		// will take over device input actions. **Be aware of this issue.
		focus: false // focus needs to be on StackView for device gesters and key press event detection.
		// if Mac os, and esc key used, exit full screen if current window mode.
		Keys.onEscapePressed: {
			rootAppPage.keyEvent_normal_window_size(event)
		}
	}//end 'stackView'

	// if esc key used, exit full screen if current window mode.
	Keys.onEscapePressed: {
		rootAppPage.keyEvent_normal_window_size(event)
	}

//-----------------------------------------------------------------------------
}//end 'pageRoot'
