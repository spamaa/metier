import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/finalsteps/boarding_completed.qml"
// Onboarding was completed by the user.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Boarding Completed")
	objectName: "boarding_completed"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {
    rootAppPage.clearStackHome("pages/existingusers/dashboard.qml")
  }

  function onButtonNext() {  }

  function onButtonBack() {  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    pageRoot.setActionFooter({ visible: false })
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    clip: true
    spacing: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_CenteredTitle {
      textTitle: qsTr("wallet created successfully!")
    }

    LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/cards/success.json"
      height: 240
			width:  parent.width
      speed: 1.0
			loops: 0
			running: true
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter

      // called when done animating
			onFinished: {
				var props = {
          buttonTextOne: qsTr("dashboard"),
          buttonTypeOne: "Active",
          buttonIconOne: "",
          buttonTextTwo: "",
          singleButtonAlign: Qt.AlignHCenter,
          visible: true
        }
        pageRoot.setActionFooter(props)
			}
		}

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'