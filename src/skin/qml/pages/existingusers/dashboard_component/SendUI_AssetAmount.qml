import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// SendUI_AssetAmount.qml
// Provides a selection for OT AssetList model to locate an AccountActivity
// model tied to a TextField for a send value to be entered.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: parent.height

  signal toNextStep() // called when ready for next step.

  //-----------------------------------------------------------------------------
  Column {
    id: body
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: contextRoot.height
    spacing: 6
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
      id: detailsCancelButton
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
      id: sendStepDetailsDescription
      text: qsTr("Details")
      font.pixelSize: DawgsStyle.fsize_title
      font.weight: Font.DemiBold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
      bottomPadding: DawgsStyle.verticalMargin * 2
    }

    //----------------------
    Text {
      text: qsTr("Asset")
      font.pixelSize: DawgsStyle.fsize_accent
      color: DawgsStyle.text_descrip
      horizontalAlignment: Text.AlignLeft
    }

    Dawgs_AssetSelection {
      id: selectAssetDeligate
      z: 1
      onAccountActivtySelected: {
        enterAmountDeligate.clear()
        enterAmountDeligate.usd_mode = false
        enterAmountDeligate.enabled = true
        OTidentity.setAccountActivityFocus(selectAssetDeligate.accountID)
      }
      onMenuOpened: {
        enterAmountDeligate.enabled = false
      }
      onMenuClosed: {
        enterAmountDeligate.enabled = true
      }
    }

    //----------------------
    Text {
      text: qsTr("Amount to send")
      font.pixelSize: DawgsStyle.fsize_accent
      color: DawgsStyle.text_descrip
      horizontalAlignment: Text.AlignLeft
      topPadding: DawgsStyle.verticalMargin + parent.spacing
    }

    Dawgs_SendAmount {
      id: enterAmountDeligate
      z: 0
      enabled: true
      onValidAmount: nextStepButton.enabled = true
      onInvalidAmount: nextStepButton.enabled = false

      // Alert invalid blockchain amount
      Dawgs_Alert {
        id: valueEnteredAlert
        text: qsTr("Value incompatable with current blockchain.")
        // Display for a period of time?
        Timer {
          id: callAlertTimer
          interval: 2000
          running: false
          onTriggered: {
            dawgsAlertTest.visible = false
          }
        }
      }
    }

    Dawgs_TranslucentButton {
      id: amountTextTools
      width: 164
      enabled: (DawgsStyle.ot_exchanges && enterAmountDeligate.enabled)
      visible: (enabled)
      x: parent.width - width
      displayText: qsTr("Switch")
      // toggles amount display in coin to USD
      onClicked: {
        enterAmountDeligate.clear()
        enterAmountDeligate.usd_mode = !enterAmountDeligate.usd_mode
      }
    }
  }//end 'body'

  //-----------------------------------------------------------------------------
  // Footer button:
  Dawgs_Button {
    id: nextStepButton
    displayText: qsTr("Next")
    buttonType: "Active"
    enabled: false

    anchors {
      bottom: parent.bottom;
      bottomMargin: DawgsStyle.verticalMargin * 2;
      horizontalCenter: parent.horizontalCenter;
    }

    onClicked: {
      // ready to send, just need final review
      var validatedString = enterAmountDeligate.getBlockchainAmount()
      if (validatedString !== null) {
        dashViewRoot.amountToSend_validated = validatedString
        contextRoot.toNextStep()
        //debugger:
        //console.log("SendUI, amount validated:", validatedString)
      } else {
        console.log("SendUI_AssetAmount invalid amount supplied, can't continue.")
        nextStepButton.enabled = false
        callAlertTimer.start()
        valueEnteredAlert.visible = true
      }
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'