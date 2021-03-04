import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Delegate for inputing Send/Receive amount values.
//-----------------------------------------------------------------------------
Row {
  id: widget
  height: 38
  spacing: 8

  property var rawText: ""
  property var realAmount: ""// gets updated with 'accountActivity_model.validateAmount()'

  signal validate()

  property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
  //----------------------
  // sync text from tumbler input, to match textinput amount field
  // used for interactive tumbers for input amount other then text feild.
  function update_fulldisplay_amount() {
    var displayAmount = "" 
    /*
    displayAmount += viTens.currentIndex > 0 ? viTens.currentIndex : ""
    displayAmount += viSingle.currentIndex
    displayAmount += "." + viTenth.currentIndex + viHundredth.currentIndex
    displayAmount += viThousandth.currentIndex
    */
    enterAmountField.text = displayAmount
    console.log("Current Amount sync'd with Tumblers:", displayAmount)
  }
  
  //----------------------
  // sync tumblers to manual text entered amount
  function update_tumblers_amount() {

  }

  //----------------------
  // Clear the current input amount
  function clearInput() {
    enterAmountField.text = ""
  }

  //----------------------
  function getAmountEntered() {
    return enterAmountField.text
  }

  //----------------------
  // input amount lable
  Text {
    id: inputAmountText
    text: qsTr("Input Amount: ")
    width: 100
    color: widget.fontColor
    font.pixelSize: CustStyle.fsize_normal
    verticalAlignment: Text.AlignVCenter
    anchors.verticalCenter: parent.verticalCenter
  }

  //----------------------
  // Tumblers
  /*
  Row {
    id: tumblerSendAmount
    height: viTens.height
    visible: false
    spacing: 2

    MatterFi_AmountTumbler {
      id: viTens
      onValueChanged: widget.update_fulldisplay_amount()
    }

    MatterFi_AmountTumbler {
      id: viSingle
      onValueChanged: widget.update_fulldisplay_amount()
    }

    Text {
      id: decimalSeperationText
      text: "."
      topPadding: 18
      color: widget.fontColor
    }

    MatterFi_AmountTumbler {
      id: viTenth
      onValueChanged: widget.update_fulldisplay_amount()
    }

    MatterFi_AmountTumbler {
      id: viHundredth
      onValueChanged: widget.update_fulldisplay_amount()
    }

    MatterFi_AmountTumbler {
      id: viThousandth
      onValueChanged: widget.update_fulldisplay_amount()
    }
  }
  */

  //----------------------
  // Manual text entry for amount to send
  TextInput {
    id: enterAmountField
    width: 100
    height: widget.height
    maximumLength: 12
    color: widget.fontColor
    padding: 8
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.verticalCenter: parent.verticalCenter
    // validate input amount
    //inputMask: "0.000000"
    validator: DoubleValidator {
      id: amountFieldValidator
      top:        101.0;  // largest send value
      bottom:      0.00;  // smallest send value
      decimals:       2;  // number of decimal places
      notation: DoubleValidator.StandardNotation
    }
    // ensure that a proper double value is being entered
    property real maximumValue: amountFieldValidator.top
    property real minimumValue: amountFieldValidator.bottom
    property string previousText: ""
    onTextChanged: {
      var numericValue = getValue()
      if (numericValue > maximumValue || numericValue < minimumValue) {
        text = previousText
        amountToolTip.visible = true
        amountToolTipTimer.start()
      }
      previousText = text
      widget.rawText = text
      widget.validate()
    }
    function getValue() {
      return Number(text)
    }
    // on key press event:
    Keys.onPressed: {
      widget.handleKeyStrokeEvents(event)
    }
    // outline the input box
    OutlineSimple {
      outline_color: CustStyle.accent_outline
    }
    // Display notification when still in need of more words
    ToolTip {
      id: amountToolTip
      visible: false
      text: (// assemble tool top help text
        qsTr("Please enter a value between \'") +
        amountFieldValidator.top.toFixed(1) + 
        qsTr("\' and \'") + 
        amountFieldValidator.bottom.toFixed(amountFieldValidator.decimals) + 
        qsTr("\'")
      );
      palette {
        base: Universal.background // background fill
      }
      // time that the ToolTip is displayed for
      Timer {
        id: amountToolTipTimer
        interval: 2000
        running: false
        onTriggered: {
          amountToolTip.visible = false
        }
      }
    }
  }

  //----------------------
  // What happens on certain key usage events:
  function handleKeyStrokeEvents(event) {
    if (enterAmountField === null) return;
    // action based on what key event was detected
    switch(event.key) {
    case Qt.Key_Backspace:
      var character = ""
      var index = enterAmountField.cursorPosition
      character = enterAmountField.getText(index - 1, index) 
      //console.log("Text Field", enterAmountField, character)
      // if is decimal character, clear everything, the TextInput
      // will prevent any number higher then 11 to be entered, removing
      // the decimal will make the value higher then that which is prevented
      /*
      if (character == ".") {
        enterAmountField.text = ""
        enterAmountField.textChanged()
        return;
      }
      */
      if (enterAmountField.text.length > 0) {
        // always accept back space events
        enterAmountField.text = enterAmountField.text.slice(0, -1)
        enterAmountField.textChanged()
        //if (!enterAmountField.acceptableInput) {
          amountToolTip.visible = true
          amountToolTipTimer.start()
        //}
      }
      break;
    default:
      // nothing
    }
  }

  //----------------------
  // The equivlent amount in blockchain value for
  // input amount conversion
  /*
  Text {
    id: realAmountText
    text: qsTr("Value: ") + parseFloat(widget.realAmount).toFixed(2)
    width: 100
    color: widget.fontColor
    verticalAlignment: Text.AlignVCenter
    anchors.verticalCenter: parent.verticalCenter
  }
  */

//-----------------------------------------------------------------------------
}//end 'widget'