import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/hard/show_seedphrase.qml"
// Shows the user thier recovery seed phrase for their wallet.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Show Seed Phrase")
	objectName: "a_card_ofmany"
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

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'