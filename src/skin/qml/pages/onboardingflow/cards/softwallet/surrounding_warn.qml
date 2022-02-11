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

  function onButtonNext() { 
    pageRoot.pushCard("qrc:/boarding_cards/softwallet/show_newseed.qml")
  }

  function onButtonBack() { 
    pageRoot.popCard()
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: qsTr("back"),
      buttonTypeOne: "Secondary",
      buttonIconOne: "",
      buttonOneEnabled: true,
      buttonTextTwo: qsTr("next"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.sd_chevron_right,
      fontIconTwo: Fonts.icons_spacedawgs,
      buttonTwoEnabled: true
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

    Dawgs_AccentTitle {
      accentText: qsTr("ATTENTION")
      titleText: qsTr("Check your surroundings")
    }

    // Alert text description with bg color fill:
    Item {
      id: bgFill
      width: parent.width
      height: warningText.height

      Rectangle {
        id: bgRectFill
        width: parent.width
        height: parent.height
        color: DawgsStyle.alert_bg
        opacity: 0.10
        radius: 8
        anchors.centerIn: parent
      }

      Rectangle {
        id: bgRectOutline
        width: parent.width
        height: parent.height
        color: "transparent"
        radius: bgRectFill.radius
        border.color: DawgsStyle.alert_ol
        border.width: 1
        anchors.centerIn: parent
      }

      Text {
        id: warningText
        width: parent.width
        text: qsTr("When you click next you will see your seed phrase,  your only tool for recovering this wallet.  Do not view in public or over an insecure connection.\n\nYOU WILL NOT SEE THIS AGAIN,\nit is strongly recommended you write it down.")
        color: DawgsStyle.alert_txt
        font.pixelSize: DawgsStyle.fsize_alert
        font.weight: Font.DemiBold
        padding: 8
        wrapMode: Text.Wrap
        anchors.centerIn: parent
      }
    }

	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'