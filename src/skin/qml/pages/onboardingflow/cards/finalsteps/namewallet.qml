import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/finalsteps/namewallet.qml"
// User names their wallet making it MatterCode™ compliant for display.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("New Name")
	objectName: "set_walletname_ot"
	background: null //Qt.transparent

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {
    // A blank string will 'default' name.
    delayWorkStartTimer.start()
  }

  function onButtonBack() {
    pageRoot.popCard()
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
    startup.displayMainWindow.connect(cardDeligateRoot.otsignalReadyForDashboard)
  }

  Component.onDestruction: {
    startup.displayMainWindow.disconnect(cardDeligateRoot.otsignalReadyForDashboard)
  }

  // Connect to OT setup signal that is trigged when setup is ready
  // for block chain selections.
  function otsignalReadyForDashboard() {
    pageRoot.pushCard("qrc:/boarding_cards/finalsteps/boarding_completed.qml")
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: "", //qsTr("back"),
      buttonTypeOne: "Secondary",
      buttonIconOne: "",
      buttonTextTwo: qsTr("create"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.sd_add,
      fontIconTwo: Fonts.icons_spacedawgs,
      buttonTwoEnabled: false
    }
    pageRoot.setActionFooter(props)
  }

  //-----------------------------------------------------------------------------
  // Is busy creating blockchain nym display:
  Rectangle {
    id: displayIsBusyRect
    visible: (creatingBusyIndicator.running === true)
    width: body.width
    height: 256
    color: "transparent"
    anchors.centerIn: parent
    // Display notification of expected pause while importing the seed
    Column {
      width: parent.width
      height: parent.height
      spacing: 16
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        text: qsTr("creating nym...")
        color: DawgsStyle.font_color
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: DawgsStyle.fsize_normal
      }
      
      BusyIndicator {
        id: creatingBusyIndicator
        running: false
        visible: (parent.visible)
        scale: 1.0
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
    // delay the start call to give the UI time to notify the user of the work pause
    Timer {
      id: delayWorkStartTimer
      interval: 200
      running: false
      onTriggered: {
        // TODO:
        // If importing wallet, can not create a new Nym with this OT wrap function.
        // libc++abi: terminating with uncaught exception of type std::__1::future_error: 
        // The state of the promise has already been set. Creating a new wallet does the same.
        //
        // The above noted error seems to happen when the sync service can not be reached.
        api.createNym(walletNameInputText.text)
      }
    }
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    visible: (creatingBusyIndicator.running === false)
    clip: true
    spacing: 8
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("one last thing")
      titleText: qsTr("Name your wallet")
    }

    Text {
      id: displayDescription
      color: DawgsStyle.font_color
      width: body.width
      height: 64
      wrapMode: Text.Wrap
      font.pixelSize: DawgsStyle.fsize_normal
      font.weight: Font.DemiBold
      text:  qsTr("People will see this name when transacting with this wallet in any wallet compatible with MatterCodes™.")
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Dawgs_TextField {
      id: walletNameInputText
      placeholderText: "wallet name here..."
      canClickOffClose: false
      onTextChanged: {
        pageRoot.setActionFooter({ buttonTwoEnabled: (length > 0) })
      }
      anchors.horizontalCenter: parent.horizontalCenter
    }
	}//end 'body'

//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'