import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// MatterFi_PaymentCode.qml
// Delegate for displaying Payment codes. Adds features for click copy to
// clipboard.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width - (DawgsStyle.horizontalMargin * 2)
  height: 32
  clip: true
  color: "transparent"

  property string displayLable: ""
  property string displayText: ""

  property color primaryColor: DawgsStyle.font_color

  border.color: contextRoot.primaryColor
	border.width: 1
	radius: 6
  //-----------------------------------------------------------------------------
  // input action to copy to clipboard
  function codeWasClicked() {
    textClipBoard.text = accountIdText.text
    textClipBoard.selectAll()
    textClipBoard.copy()
    // show notification of copy
    copiedAnimationTimer.restart()
    contextRoot.state = "copied"
  }

  //-----------------------------------------------------------------------------
  // Icon to show element is click-copy action
  Text {
    id: cloneIconText
    text: IconIndex.fa_clone
    height: parent.height
    color: contextRoot.primaryColor
    padding: 4
    leftPadding: 6
    font.pixelSize: DawgsStyle.fsize_accent
    font.family: Fonts.icons_solid
    font.weight: Font.Thin
    font.styleName: "Regular" //"Solid"
    verticalAlignment: Text.AlignVCenter
  }
  // lable for the paymentcode string display
  Text {
    id: accountIdLableText
    color: contextRoot.primaryColor
    visible: (displayLable.length > 0)
    text: contextRoot.displayLable
    font.pixelSize: DawgsStyle.fsize_normal
  }
  // The user's paymentcode and its interactions
  Rectangle {
    id: rollerAnimationClickRect
    width: parent.width
    height: parent.height
    color: "transparent"
    clip: true
    x: 30
    y: 8
    // display wallet's MatterCode™.
    Text {
      id: accountIdText
      text: (displayText.length > 0 ? contextRoot.displayText : "null")
      color: contextRoot.primaryColor
      width: parent.width - 64
      font.pixelSize: DawgsStyle.fsize_normal
      font.weight: Font.DemiBold
      elide: Text.ElideRight
      clip: true
      verticalAlignment: Text.AlignVCenter
      // work around limitation for QClipBoard in QML not being accessible
      TextEdit {
        id: textClipBoard
        visible: false
      }
      // display that string has been shortented:
      Text {
        id: accountIdWasTrimmedText
        text: "..."
        color: contextRoot.primaryColor
        x: accountIdText.width
        font.pixelSize: DawgsStyle.fsize_normal
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignVCenter
      }
    }
    // copy notification:
    Text {
      id: copiedToClipboardText
      width: accountIdText.width
      y: 64
      text: qsTr("Copied!")
      font.pixelSize: DawgsStyle.fsize_normal
      font.weight: Font.DemiBold
      color: contextRoot.primaryColor
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }
  }

  // When user clicks on their payment code, copy text to clipboard
  MouseArea {
    id: inputArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: (containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
    // copy text on user click
    onClicked: {
      contextRoot.codeWasClicked()
    }
  }

  //-----------------------------------------------------------------------------
  // States for Copy Animation:
  state: "idle"

  //----------------------
  transitions: [
    Transition {
      from: "idle"; to: "copied"
      SequentialAnimation {
        id: copiedAnimation
        NumberAnimation { target: copiedToClipboardText; property: "y"; to: 16; duration: 0 }
        OpacityAnimator { target: copiedToClipboardText; from: 0.0; to: 0.0; duration: 0 }
        ParallelAnimation {
          NumberAnimation { target: accountIdText; property: "y"; to: -32; duration: 160 }
          OpacityAnimator { target: accountIdText; from: 1.0; to: 0.0; duration: 60 }
        }
        ParallelAnimation {
          NumberAnimation { target: copiedToClipboardText; property: "y"; to: 0; duration: 160 }
          OpacityAnimator { target: copiedToClipboardText; from: 0.0; to: 1.0; duration: 60 }
        }
      }
    },

    Transition {
      from: "copied"; to: "idle"
      SequentialAnimation {
        id: returnIdleAnimation
        NumberAnimation { target: accountIdText; property: "y"; to: 16; duration: 0 }
        OpacityAnimator { target: accountIdText; from: 0.0; to: 0.0; duration: 0 }
        ParallelAnimation {
          NumberAnimation { target: copiedToClipboardText; property: "y"; to: -32; duration: 160 }
          OpacityAnimator { target: copiedToClipboardText; from: 1.0; to: 0.0; duration: 60 }
        }
        ParallelAnimation {
          NumberAnimation { target: accountIdText; property: "y"; to: 0; duration: 160 }
          OpacityAnimator { target: accountIdText; from: 0.0; to: 1.0; duration: 60 }
        }
      }      
    }
  ]//end 'transitions'

  //----------------------
  Timer {
    id: copiedAnimationTimer
    interval: 2000
    running: true
    onTriggered: {
      contextRoot.state = "idle"
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'