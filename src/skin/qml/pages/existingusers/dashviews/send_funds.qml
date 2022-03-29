import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
import "qrc:/page_components"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/send_funds.qml"
// General send transfer of user funds.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Send Funds.")
	objectName: "dashboard_send_funds"
	background: null //Qt.transparent

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  property bool matterCodeIsValid: false // MatterCode provided is valid.
  property string sendtoAddressID: "" // Recieving payment code.
  property string sendtoContactID: ""    // ID of the contact for ActivityThread.

  property string useAccountID: ""       // When send funds was summoned, was an asset chosen already.
  property string useContractID: ""      // When send funds for contact.

  // because of OT exchanges and blockchain display values, it's assumed that one only passes
  // the blockchain value amount ever for the associated model when calling on OT AccountActivity.send()
  property string amountToSend_validated: "" // String value of 'sendAssetAmountBody'

  property bool reviewForConfirmation: false // Reviewing transaction details before sending.

  //----------------------
  // Prompt user to enter pin to continue.
  MatterFi_PinWall {
    id: promptToEnterPin
    anchors.horizontalCenter: parent.horizontalCenter

    // if navigation to this dashview was supplied additional context
    onPinCorrectlyEntered: {
      if (pageRoot.passAlongData !== undefined) {
        //debugger:
        //console.log("Additional send data was provided:")
        //QML_Debugger.listEverything(pageRoot.passAlongData)
        // navigation from Asset view
        if (pageRoot.passAlongData.fromAccountID !== undefined) {
          dashViewRoot.useAccountID = pageRoot.passAlongData.fromAccountID
          currentSendStepLoader.sourceComponent = assetAmountComponent //toWhomeComponent
        } else if (pageRoot.passAlongData.contactID !== undefined) {
          // navigation from Contacts view
          dashViewRoot.sendtoContactID = pageRoot.passAlongData.contactID
          dashViewRoot.sendtoAddressID = pageRoot.passAlongData.sendMatterCode
          currentSendStepLoader.sourceComponent = assetAmountComponent
        }
        pageRoot.clear_passAlong()
      } else {
        // no additional navigation data was provided when opening send UI
        // defualt send navigation step to be shown
        currentSendStepLoader.sourceComponent = assetAmountComponent
        //debugger:
        //console.log("No additional send data for navigation was provided.")
      }
    }
  }

  //-----------------------------------------------------------------------------
  // Only show the Component for the current step in supplying
  // parameters for sending transactions:
  Loader {
    id: currentSendStepLoader
    visible: (!promptToEnterPin.needPin)
    anchors.fill: parent
    // need to show asset selection first before SendAddress is entered as
    // the AccountActivity provides an address validator
    sourceComponent: undefined //assetAmountComponent //toWhomeComponent
  }

  //----------------------
  // Provide selection and entry UI for reciving address input:
  Component {
    id: toWhomeComponent
    SendUI_ToWhome {
      id: sendToWhomeBody
      anchors.horizontalCenter: parent.horizontalCenter
      onToNextStep: {
        currentSendStepLoader.sourceComponent = finalReviewComponent //assetAmountComponent
      }
    }
  }
  // Provide selection of an asset and entry of a value amount for sending funds:
  Component {
    id: assetAmountComponent
    SendUI_AssetAmount {
      id: sendAssetAmountBody
      anchors.horizontalCenter: parent.horizontalCenter
      onToNextStep: {
        currentSendStepLoader.sourceComponent = toWhomeComponent //finalReviewComponent
      }
    }
  }
  
  //----------------------
  // Review transaction for sending: *second to last step*
  property var txRequestIndex: undefined
  Component {
    id: finalReviewComponent
    SendUI_FinalReview {
      id: reviewTransactionSendBody
      anchors.horizontalCenter: parent.horizontalCenter
      onToNextStep: currentSendStepLoader.sourceComponent = transactionOutcomeComponent
    }
  }
  // Transaction blockchain outcome: *always last as is after send()*
  Component {
    id: transactionOutcomeComponent
    SendUI_TransactionOutcome {
      id: transactionOutcomeBody
      anchors.horizontalCenter: parent.horizontalCenter
      onReturnToDashboard: {
        pageRoot.popDash()
      }
    }
  }

//-----------------------------------------------------------------------------
}//end 'dashViewRoot'