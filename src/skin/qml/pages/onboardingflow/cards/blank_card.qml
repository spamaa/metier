import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/blank_card.qml"
// Another card for on boarding flow.  *quick template*
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Descriptive Title Shown")
	objectName: "object_identity_tracing_assitant"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {  }

  function onButtonBack() {  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      visible: false
    }
    pageRoot.setActionFooter(props)
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

    Timer {
      interval: 600
      running: true
      onTriggered: {
        if (DawgsStyle.debug_onboard_card === "") {
          if (rootAppPage.passAlongData.card !== undefined) {
            pageRoot.pushCard(rootAppPage.passAlongData.card)
            rootAppPage.clear_passAlong()
          } else {
            pageRoot.pushCard("qrc:/boarding_cards/welcome.qml")
          }
        } else {
          // debugger:
          pageRoot.pushCard(DawgsStyle.debug_onboard_card)
        } 
      }
    }
	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'