import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Delegate for displaying Payment codes. Adds features for click copy to
// clipboard.
//-----------------------------------------------------------------------------
Rectangle {
  id: widget
  width: accountIdLableText.implicitWidth + accountIdText.implicitWidth
  height: 18
  color: "transparent"

  property var displayLable: "null"
  property var displayText: "null"

  //-----------------------------------------------------------------------------
  // input action to copy to clipboard
  function codeWasClicked() {
    textClipBoard.text = accountIdText.text
    textClipBoard.selectAll()
    textClipBoard.copy()
    // show notification of copy
    copyPaymentCodeToolTip.visible = true
    paymentcodeCopied.start() 
  }

  //-----------------------------------------------------------------------------
  // Display a lable of the paymentcode next to its string
  Row {
    id: body
    spacing: 6
    width: widget.width
    height: widget.height
    anchors.horizontalCenter: parent.horizontalCenter
    // lable for the paymentcode string display
    Text {
      id: accountIdLableText
      color: CustStyle.theme_fontColor
      text: widget.displayLable
      font.pixelSize: CustStyle.fsize_normal
    }
    // The user's paymentcode and its interactions
    Text {
      id: accountIdText
      text: widget.displayText
      color: CustStyle.theme_fontColor
      font.pixelSize: CustStyle.fsize_normal
      verticalAlignment: Text.AlignVCenter
      // work around limitation for QClipBoard in QML not being accessible
      TextEdit {
        id: textClipBoard
        visible: false
      }
      // Display copy click notification
      ToolTip {
        id: copyPaymentCodeToolTip
        visible: false
        text: qsTr("MatterCode™ Copied!")
        // set display color palette
        palette {
          base: Universal.background // background fill
        }
        // time that the ToolTip is displayed for
        Timer {
          id: paymentcodeCopied
          interval: 2000
          running: false
          onTriggered: {
            copyPaymentCodeToolTip.visible = false
          }
        }
      }
      // When user clicks on their payment code, copy text to clipboard
      MouseArea {
        id: inputArea
        anchors.fill: parent
        hoverEnabled: true
        // copy text on user click
        onClicked: {
          widget.codeWasClicked()
        }
      }
    }
    // Additional icon to show element is click-copy action
    FontIconButton {
      iconChar: IconIndex.copy
      iconSize: 18
      width: iconSize
      height: iconSize

      onAction: {
        widget.codeWasClicked()
      }
    }

  }//end 'body'
//-----------------------------------------------------------------------------
}//end 'widget'