import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "pages/onboardingflow/onboard_card_frame.qml"
// Creates a deligate frame for the displaying of Cards used to on board Users.
//-----------------------------------------------------------------------------
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("OnBoarding Cards")
	objectName: "onboard_cards"
	background: null //Qt.transparent

	//-----------------------------------------------------------------------------
	// Card display management. These are accessed via 'pageRoot' from a card.
	function pushCard(card_qmlfile) {
		//console.log("CardStack pushing new card.")
		cardStackView.push(card_qmlfile)
	}

	// navigate back a card in stack and remove last card from stack.
	function popCard() {
		//console.log("CardStack popping a card.")
		cardStackView.pop()
		cardStackView.currentItem.setActionFooterConfiguration()
	}

	// clear entire card stack and set first card to arg passed:
	function clearCardsHome(showcard) {
		//console.log("CardStack cleared for card:", showcard)
		cardStackView.clear()
		pageRoot.pushCard(showcard)
	}

	// reconfigure staic action footer controlled by current card displayed.
	function setActionFooter(props) {
		cardActionFooter.forceRefresh(props)
	}

	//-----------------------------------------------------------------------------
	// Main 'body' display container.
	Image {
		id: logotypeImage
		source: "qrc:/assets/splash/logotype.svg"
		smooth: true
		opacity: 0.0
		y: 64
		sourceSize.width: 328
		sourceSize.height: 48
		fillMode: Image.PreserveAspectFit
		anchors.horizontalCenter: parent.horizontalCenter
		// animate the aperance into view
		ParallelAnimation {
			id: logotypeAnimation
			running: false
			YAnimator { target: logotypeImage       // move up
				from: 64 + 80; to: 64
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
			interval: 100
			running: true
			onTriggered: {
				logotypeAnimation.running = true
			}
		}
	}//end 'logotypeImage'

	//-----------------------------------------------------------------------------
	// Card deligate handler:
	StackView {
		id: cardStackView
		y: 176
		width: parent.width - (DawgsStyle.horizontalMargin * 2)
		height: 400
		// Stating card to display
		initialItem: "qrc:/boarding_cards/blank_card.qml"
		anchors.horizontalCenter: parent.horizontalCenter
		background: Rectangle {
			id: bgFiller
			width: parent.width
			height: parent.height
			color: DawgsStyle.norm_bg
			radius: 12
			opacity: 0.0
			ParallelAnimation {
				id: bgFillerAppearAnimation
				running: false
				YAnimator { target: bgFiller
					from: 40;	to: 0; duration: 400;
					easing.type: Easing.OutQuint
				}
				OpacityAnimator { target: bgFiller
					from: 0.0; to: 1.0;	duration: 400;
					easing.type: Easing.OutQuint
				}
			}
			Timer {
				id: cardBgAppearTimer
				interval: 650
				running: true
				onTriggered: {
					bgFillerAppearAnimation.running = true
				}
			}
		}

		//----------------------
		// Tranisition to new card shown:
		pushEnter: Transition {
			ParallelAnimation {
				YAnimator {
					from: 40;	to: 0
					duration: 400;
					easing.type: Easing.OutQuint
				}
				NumberAnimation {
					property: "opacity";
					from: 0.0;
					to: 1.0;
					duration: 400;
					easing.type: Easing.OutQuint
				}
			}
		}
		// remove last on enter new
		pushExit: Transition {
			NumberAnimation {
				property: "opacity";
				from: 1.0;
				to: 0.0;
				duration: 200;
				easing.type: Easing.OutQuint
			}
		}
		// on popping current, fade last back
		popEnter: Transition {
			ParallelAnimation {
				YAnimator {
					from: 40;	to: 0
					duration: 400;
					easing.type: Easing.OutQuint
				}
				NumberAnimation {
					property: "opacity";
					from: 0.0;
					to: 1.0;
					duration: 400;
					easing.type: Easing.OutQuint
				}
			}
		}
		// fade away when done with popping
		popExit: Transition {
			NumberAnimation {
				property: "opacity";
				from: 1.0;
				to: 0.0;
				duration: 200;
				easing.type: Easing.OutQuint
			}
		}
	}//end 'cardStackView'

	//-----------------------------------------------------------------------------
	// Shared action footer:
	Dawgs_ActionFooter {
		id: cardActionFooter
		visible: false
		opacity: 0.0
		x: cardStackView.x + DawgsStyle.horizontalMargin
		y: cardStackView.y + cardStackView.height - cardActionFooter.height - DawgsStyle.verticalMargin
		width: cardStackView.width - (DawgsStyle.horizontalMargin * 2)
		onButtonAction: {
			if (butindex === 0) {
				if (buttonTextTwo === "") {
					cardStackView.currentItem.onButtonSingle()
				} else {
					cardStackView.currentItem.onButtonBack()
				}
			} else if (butindex === 1) {
				cardStackView.currentItem.onButtonNext()
			}
		}
		// footer aperance animator
		OpacityAnimator { target: cardActionFooter
			id: cardActionFooterAnimator; running: false
			from: 0.0; to: 1.0;	duration: 400;
			easing.type: Easing.OutQuint
		}
		Timer {
			id: cardActionFooterAppearTimer
			interval: 1000
			running: true
			onTriggered: {
				cardActionFooterAnimator.running = true
			}
		}
	}

	//-----------------------------------------------------------------------------
	// Debug Navigation Button: debugger
	/*
	Dawgs_Button {
		enabled: true
		y: pageRoot.height - 64
		displayText: qsTr("DB")
		onClicked: {
			if (cardStackView.depth > 2) {
				pageRoot.popCard()
			} else {
				if (rootAppPage.getStackDepth() === 1) {
					rootAppPage.clearStackHome("pages/dawgs_component_test.qml")
				} else {
					rootAppPage.popPage()
				}	
			}
		}
	}
*/
//-----------------------------------------------------------------------------
}//end 'pageRoot'