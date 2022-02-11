import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// SendUI_TransactionOutcome.qml
// Provides a Component for the blockchain outcome event. ('success' or 'not')
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: parent.height

  signal returnToDashboard() // ready to return to dashboard now.

  property bool wasError: false
  property string errorString: ""

  //----------------------
  // Attach signal to watch for transaction results in order to respond to them.
  Component.onCompleted: {
    if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
      OTidentity.focusedAccountActivity_OTModel.transactionSendResult.connect(transactionSendResult)
      // go foreword with OT send request
      var memo = ""
      dashViewRoot.txRequestIndex = OTidentity.focusedAccountActivity_OTModel.sendToAddress(
        sendtoMatterCodeID, amountToSend_validated, memo);
    } else {
      console.log("Error: SendUI transaction does not have an AccountActivity model for outcome.")
      contextRoot.wasError = true
    }
  }

  Component.onDestruction: {
    if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
      OTidentity.focusedAccountActivity_OTModel.transactionSendResult.disconnect(transactionSendResult)
    }
  }

  //----------------------
  // Track recent activity transactions to watch for any send errors:
  function transactionSendResult(request_index, blockchain_result, txid) {
    if (dashViewRoot.txRequestIndex === request_index) {
      // debugger:
      console.log("Transaction was related to this instance.", txid)

      //TODO: atm it seems only PKT responds with a blockchain result,
      // need to confirm this and find a way for other blockchains.

      // check to see if transaction results was an error or not
      if (txid === "0000000000000000000000000000000000000000000000000000000000000000") {
        console.log("SendUI transaction reported Error:", dashViewRoot.txRequestIndex)
        contextRoot.wasError = true
        contextRoot.errorString = blockchain_result
        nextStepButton.forceRefresh()
        return;
      }

      // success:
      console.log("Transaction Broadcasted to Network:", txid)
      contextRoot.wasError = false
      nextStepButton.forceRefresh()
    }
  }

  //-----------------------------------------------------------------------------
  // Send lottie animation:
  LottieAnimation {
    id: lottieSend
    source: "qrc:/assets/dash/sending.json"
    height: pageRoot.height
    width: height
    loops: 0
    speed: 1.0
    visible: (running === true)
    running: true
    fillMode: Image.PreserveAspectFit
    anchors.centerIn: parent
    //onFinished: {}
  }

  //-----------------------------------------------------------------------------
  Column {
    id: body
    visible: (!lottieSend.visible)
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: contextRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Column {
      width: parent.width
      topPadding: 48
      spacing: 4
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_CenteredTitle {
        textTitle: (!contextRoot.wasError ? qsTr("Success") : qsTr("Error"))
        height: fontPixelSize
        fontcolor: DawgsStyle.text_accent
        fontPixelSize: DawgsStyle.fsize_accent
      }

      Dawgs_CenteredTitle {
        height: fontPixelSize
        textTitle: (!contextRoot.wasError ? qsTr("Transaction sent!") :
          (contextRoot.errorString.length > 0 ? qsTr("An unexpected error occured.") :
          contextRoot.errorString
        ));
      }
    }
    //----------------------
    LottieAnimation {
			id: lottieLogo
			source: "qrc:/assets/cards/success.json"
      visible: !contextRoot.wasError
      height: 260
			width:  parent.width
      speed: 1.0
			loops: 0
			running: visible
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}
  }//end 'body'

  //-----------------------------------------------------------------------------
  // Footer button:
  Dawgs_Button {
    id: nextStepButton
    visible: (body.visible)
    displayText: (!contextRoot.wasError ? qsTr("Great") : qsTr("Exit"))
    buttonType: "Active"

    anchors {
      bottom: parent.bottom;
      bottomMargin: DawgsStyle.verticalMargin * 2;
      horizontalCenter: parent.horizontalCenter;
    }

    onClicked: contextRoot.returnToDashboard()
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'