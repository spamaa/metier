import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_SendAmount.qml
// Provides send box for amount validation and USD conversion display.
//-----------------------------------------------------------------------------
Item {
  id: sendContextRoot
  width: parent.width
  height: 96
  visible: true
  focus: true

  property bool usd_mode: true  // Display mode for the coin amount or USD value.
  property bool enabled: true
  
  signal validAmount()
  signal invalidAmount()

  //----------------------
  function clear() {
    amountTextField.clear()
  }

  // always returns the entered value in the selected asset blockchain value:
  function getBlockchainAmount() {
    if (OTidentity.focusedAccountActivity_OTModel !== undefined) {
      var verifiedText = OTidentity.focusedAccountActivity_OTModel.validateAmount(amountTextField.text)
      return verifiedText
    } else {
      console.log("SendAmount validation error: no focused AccountActivity OT model.")
      return undefined
    }
  }

  //-----------------------------------------------------------------------------
  Rectangle {
    id: backgroundRect
    width: parent.width
    height: parent.height - 2
    radius: 8
    color: "transparent"
    border.color: DawgsStyle.aa_norm_ol
    border.width: 1
    //----------------------
    Rectangle {
      id: amountTextLineRect
      width: parent.width - (DawgsStyle.horizontalMargin * 2)
      height: 2
      color: (amountTextField.focus && amountTextField.enabled ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol)
      anchors {
        horizontalCenter: parent.horizontalCenter;
        bottom: parent.bottom;
        bottomMargin: usdValueText.height;
      }
    }
    //----------------------
    TextField {
      id: amountTextField
      width: amountTextLineRect.width
      x: DawgsStyle.horizontalMargin
      y: 24
      maximumLength: 16
      placeholderText: qsTr("0")
      color: DawgsStyle.font_color
      enabled: (sendContextRoot.visible && sendContextRoot.enabled)
      padding: 0
      // Text display properties:
      echoMode: TextInput.Normal
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_accent
      // bg
      background: Rectangle {
        color: "transparent"
      }
      // Ensure only float value is entered as a string for amount
      validator: DoubleValidator {
        id: amountFieldValidator
        top: 10001.0000 // largest send value
        bottom:  (sendContextRoot.usd_mode ? 0.01 : 0.0001); // smallest send value
        decimals: (sendContextRoot.usd_mode ? 2 : 8);  // number of decimal places
        notation: DoubleValidator.StandardNotation // "period(.)" is a decimal notation
      }
      // update the entered value container
      onTextEdited: {
        if (amountTextField.acceptableInput) {
          sendContextRoot.validAmount()
        } else {
          sendContextRoot.invalidAmount()
        }
        //debugger:
        //console.log("SendAmount value validation:", amountTextField.text)
      }
      // on Enter pressed:
      onAccepted: {
        amountTextField.focus = false
      }
      // loose focus on esc key press:
      Keys.onEscapePressed: {
        amountTextField.focus = false
      }
      // Change hover cursor
      MouseArea {
        id: amountInputArea
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        anchors.fill: amountTextField
        cursorShape: (amountInputArea.containsMouse ? Qt.IBeamCursor : Qt.ArrowCursor)
      }
      /*
      Component.onCompleted: {
        amountTextField.forceActiveFocus()
        //debugger:
        console.log("SendAmount status:", enabled, sendContextRoot.usd_mode, focusReason)
      }
      */
    }
    //----------------------
    Text {
      id: amountDenotationText
      text: (sendContextRoot.usd_mode ? qsTr("USD") : (OTidentity.focusedAccountActivity_OTModel !== undefined ?
          (OTidentity.focusedAccountActivity_OTModel.displayBalance !== undefined ? 
          OTidentity.focusedAccountActivity_OTModel.displayBalance.split(" ")[1] : "null"
        ) : "null" ));
      color: amountTextLineRect.color
      font.pixelSize: DawgsStyle.fsize_alert
      anchors {
        top: parent.top;
        topMargin: 18;
        right: parent.right;
        rightMargin: 12;
      }
    }
    //----------------------
    // TODO: display blockchain asset USD value, bugzilla#34
    Text {
      id: usdValueText
      text: (sendContextRoot.usd_mode ? ("00.00 " + (OTidentity.focusedAccountActivity_OTModel.displayBalance !== undefined ? 
          OTidentity.focusedAccountActivity_OTModel.displayBalance.split(" ")[1] : "null" )) : "$000 USD" );
      visible: (DawgsStyle.ot_exchanges)
      color: DawgsStyle.text_descrip
      padding: DawgsStyle.horizontalMargin
      font.pixelSize: DawgsStyle.fsize_small
      anchors {
        bottom: parent.bottom;
      }
    }

  //----------------------
  }//end 'backgroundRect'

//-----------------------------------------------------------------------------
}//end 'sendContextRoot'