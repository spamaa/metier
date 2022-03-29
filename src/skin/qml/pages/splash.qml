import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// Main display page portal. This is like a Root Page used for user navigation.
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("Splash")
	objectName: "splash"
	
	background: null //Qt.transparent
	//-----------------------------------------------------------------------------
	// Button Callbacks:
	function on_animationEnded() {
		// will check api signals for proper account creation step required
		// if user has left and returned in the middle of a creation state
		if (rootAppPage.mainIsReady) {
			console.log("Main: App setup state is finished.")
			rootAppPage.clearStackHome("pages/existingusers/dashboard.qml")
		} else if (rootAppPage.isFirstRun) {
			console.log("Main: App state is first run.", rootAppPage.isFirstRun)
			rootAppPage.clearStackHome("pages/onboardingflow/onboard_card_frame.qml")
		} else if (!rootAppPage.hasProfile) {
			console.log("Main: App state is in need of User Profile.")
			rootAppPage.passAlongData = { card: "qrc:/boarding_cards/finalsteps/namewallet.qml" }
			rootAppPage.clearStackHome("pages/onboardingflow/onboard_card_frame.qml")
		} else if (rootAppPage.stillNeedBlock) {
			console.log("Main: App state is still in need of BlockChain.")
			rootAppPage.clearStackHome("pages/existingusers/dashboard.qml")
		} else {
			console.log("Main: App state Un-Known. Went to \"nav404_home.qml\"")
			rootAppPage.clearStackHome() // "pages/nav404_home.qml" by default
		}
	}

	//-----------------------------------------------------------------------------
	// Main 'body' display conatainer.
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

		//----------------------
		// SpaceDawgs Head:
		LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/splash/splash.json"
			width: 160 //pageRoot.width - body.anchors.leftMargin - body.anchors.rightMargin
			height: width
			loops: 0
			running: true
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
			// called when done animating
			onFinished: {
				//console.log("Lottie animation ended.")
				splashFinishTimer.start()
			}
			// wait before next trigger
			Timer {
				id: splashFinishTimer
				interval: 1000
				running: false
				onTriggered: {
					// prep user's chosen theme
					DawgsStyle.load_cached_theme()
					if (DawgsStyle.splash_qml_firstpage.length > 0) {
						rootAppPage.clearStackHome(DawgsStyle.splash_qml_firstpage)
					} else {
						pageRoot.on_animationEnded()
					}
				}
			}
			// get true bottom screen location
			function bottomY() {
				return y + height
			}
		}

		//----------------------
		// Animated splashtype logo:
		Image {
			id: logotypeImage
			source: "qrc:/assets/splash/logotype.svg"
			smooth: true
			opacity: 0.0
			sourceSize.width: 328
			sourceSize.height: 48
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
			// animate the aperance into view
			ParallelAnimation {
				id: logotypeAnimation
        running: false
        YAnimator { target: logotypeImage       // move up
					from: lottieLogo.bottomY() + 80; to: lottieLogo.bottomY()
					easing.type: Easing.OutBack; duration: 500
				}
        OpacityAnimator { target: logotypeImage // fade in
				  from: 0.0; to: 1.0; duration: 500
					easing.type: Easing.OutBack
				}
    	}
			// wait this long before trigger
			Timer {
				id: logotypeTimer
				interval: 500
				running: true
				onTriggered: {
					logotypeAnimation.running = true
				}
			}
		}


		//----------------------
		// Bypassing splash during a test?
		Component.onCompleted: {
			if (DawgsStyle.qml_skip_splash === true) {
				skipSplashTimer.start()
			}
		}

		Timer {
			id: skipSplashTimer
			interval: 50
			running: false
			onTriggered: {
				console.log("Skipping Splash Screen..")
				// prep user's chosen theme
				DawgsStyle.load_cached_theme()
				DawgsStyle.qml_skip_splash = false // only skip once
				if (DawgsStyle.splash_qml_firstpage.length > 0) {
					rootAppPage.clearStackHome(DawgsStyle.splash_qml_firstpage)
				} else {
					pageRoot.on_animationEnded()
				}
			}
		}

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'pageRoot'
