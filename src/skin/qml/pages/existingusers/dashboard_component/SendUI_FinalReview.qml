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
// SendUI_FinalReview.qml 
// Provides a layout of all the send transaction details before committing.
// This is the Component that actually takes care of the AccountActivity.send()
// function call gathering all the paramiters from the 'send_funds' dashview.
/*
  OT Contact ActivityThread model:
pay:function(QString& amount, QString& sourceAccount,QString& memo) { [native code] }
qml: paymentCode
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: parent.height

  signal toNextStep() // called when ready for next step. (sending the funds)

  //-----------------------------------------------------------------------------
  property bool for_contact: false
  Component.onCompleted: {
    if (dashViewRoot.sendtoContactID !== "") {
      // ensure that the current focused ActivityThread is target Contact.
      OTidentity.setContactActivityFocus(dashViewRoot.sendtoContactID)
      contextRoot.for_contact = true
      //debugger:
      console.log("SendUI_FinalReview is for a contact:", 
        dashViewRoot.sendtoContactID, OTidentity.contactActivityThread_OTModel)
      //QML_Debugger.listEverything(OTidentity.contactActivityThread_OTModel)
      //console.log("Contact payment code:", OTidentity.contactActivityThread_OTModel.paymentCode)
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
    visible: true
    running: false
    fillMode: Image.PreserveAspectFit
    anchors.centerIn: parent
    //onFinished: {}
  }

  //-----------------------------------------------------------------------------
  Column {
    id: body
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: contextRoot.height
    spacing: 0
    topPadding: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
      id: reviewCancelButton
      x: parent.width - width
      width: 60
      opacity: 0.4
      justText: true
      iconLeft: true
      manualWidth: true
      fontIcon: IconIndex.fa_chevron_left
      fontFamily: Fonts.icons_solid
      buttonType: "Plain"
      displayText: qsTr("cancel")
      onClicked: pageRoot.popDash()
    }

    //----------------------
    Text {
      id: finalReviewDescription
      text: qsTr("Review + send")
      font.pixelSize: DawgsStyle.fsize_title
      font.weight: Font.DemiBold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
      bottomPadding: DawgsStyle.verticalMargin * 2
    }

    //-----------------------------------------------------------------------------
    // Transaction review details:
    Rectangle {
      id: transactionReviewRect
      width: body.width - (DawgsStyle.horizontalMargin * 2)
      height: (body.height * 0.25)
      color: "transparent"
      anchors.horizontalCenter: parent.horizontalCenter

      MatterFi_TransactionDetails {
        id: transactionSumary
        justDetails: true
        state: "open"
        anchors.centerIn: parent
        //activityModel: OTidentity.focusedAccountActivity_OTModel
        sumaryModel: {
          'sendreview': true,
          'fulltoAddress': (contextRoot.for_contact ?
            OTidentity.contactActivityThread_OTModel.displayName : dashViewRoot.sendtoAddressID),
          'amount': dashViewRoot.amountToSend_validated
        }

        Component.onCompleted: {
          transactionSumary.useProvidedDetails()
          transactionSumary.setTransactionType("Generic")
        }
      }
    }
    
  }//end 'body'

  //-----------------------------------------------------------------------------
  // Footer button:
  Dawgs_Button {
    id: nextStepButton
    displayText: qsTr("Send")
    buttonType: "Active"

    anchors {
      bottom: parent.bottom;
      bottomMargin: DawgsStyle.verticalMargin * 2;
      horizontalCenter: parent.horizontalCenter;
    }

    onClicked: {
      //debugger:
      console.log("Sending funds:", dashViewRoot.amountToSend_validated, "To:", dashViewRoot.sendtoAddressID,
        "Contact: ", dashViewRoot.sendtoContactID)
      transitionTimer.start()
    }
    //----------------------
    // animate the footer button to smooth transition of lottie animation
    states: State {
      name: "sendAnimation"
      PropertyChanges { target: nextStepButton; opacity: 0.0; y: 64 }
      when: transitionTimer.running
    }

    transitions: Transition {
      NumberAnimation { target: nextStepButton; properties: "opacity,y"; duration: 320 }
    }
  }

  //-----------------------------------------------------------------------------
  // Animation/Transition display states:
  states: State {
    name: "sendAnimation"
    PropertyChanges { target: transactionReviewRect; opacity: 0.0; scale: 0.0 }
    when: transitionTimer.running
  }

  transitions: Transition {
    NumberAnimation { target: transactionReviewRect; properties: "opacity,scale"; duration: 320 }
  }

  //-----------------------------------------------------------------------------
  // A bit of time to wait while animations finish up:
  Timer {
    id: transitionTimer
    interval: 310
    running: false
    onTriggered: contextRoot.toNextStep()
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'