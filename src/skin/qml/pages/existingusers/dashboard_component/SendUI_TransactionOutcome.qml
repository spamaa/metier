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
/*
  OT Contact ActivityThread model:
pay:function(QString& amount, QString& sourceAccount,QString& memo) { [native code] }
qml: paymentCode

  OT AccountActivityQt:
qml: transactionSendResult: function()
qml: sendToAddress: function()
qml: sendToContact: function(QString& contactID, QString& amount, QString& memo)
qml: validateAddress: function()
qml: validateAmount: function()
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: parent.height

  signal returnToDashboard() // ready to return to dashboard now.

  property bool wasError: true
  property string errorString: "null"
  property bool isfor_contactsend: false

  //----------------------
  // Attach signal to watch for transaction results in order to respond to them.
  Component.onCompleted: {
    if (OTidentity.focusedAccountActivity_OTModel === undefined) {
      contextRoot.wasError = true
      contextRoot.errorString = "No account in focus."
      nextStepButton.forceRefresh()
      console.log("Error: SendUI transaction does not have an AccountActivity model for outcome.")
      return
    } else {
      OTidentity.focusedAccountActivity_OTModel.transactionSendResult.connect(transactionSendResult)
    }
    //debugger:
    console.log("SendUI Transaction is ready to send.")
    // Transaction memo.
    var memo = ""
    // The final review aproval should have set the AccountActivity when an asset amount
    // was entered and verified. If a contact ID then was provided, use the focused 
    // OT ActivityThread in combination with the AccountActivity model to perform the transaction.
    if (dashViewRoot.sendtoContactID !== "") {
      contextRoot.isfor_contactsend = true
      // make the contact payment

      //TODO: function lacks accountID support. BugZilla#334
      //dashViewRoot.txRequestIndex = OTidentity.contactActivityThread_OTModel.pay(
      //  amountToSend_validated, OTidentity.focusedAccountActivity_OTModel.accountID, memo)

      //TODO: returns the function as object and not the string value. BugZilla#332
      //var mattercode = OTidentity.contactActivityThread_OTModel.paymentCode
      //console.log("SendUI Transaction for contact MatterCode:", mattercode)

      // make the account asset payment via contact: BugZilla#333
      dashViewRoot.txRequestIndex = OTidentity.focusedAccountActivity_OTModel.sendToContact(
        dashViewRoot.sendtoContactID, amountToSend_validated, memo)

      contextRoot.wasError = true
      contextRoot.errorString = "Payments via contact model not yet supported in UI. txid:" + dashViewRoot.txRequestIndex
      nextStepButton.forceRefresh()

      //debugger:
      console.log("SendUI Transaction is for a contact:", dashViewRoot.sendtoContactID, dashViewRoot.txRequestIndex)
      //console.log("TX models:", OTidentity.contactActivityThread_OTModel, OTidentity.focusedAccountActivity_OTModel)
      //QML_Debugger.listEverything(OTidentity.contactActivityThread_OTModel)
      //QML_Debugger.listEverything(OTidentity.focusedAccountActivity_OTModel)
    } else {
      // make the account asset payment via address:
      dashViewRoot.txRequestIndex = OTidentity.focusedAccountActivity_OTModel.sendToAddress(
        sendtoMatterCodeID, amountToSend_validated, memo);
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