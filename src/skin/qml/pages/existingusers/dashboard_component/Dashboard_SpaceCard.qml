import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dashboard_SpaceCard.qml
// Deligation component for user's spacecard. Recieves customization settings
// and adopts a new display as a center piece for the Dashboard page.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: flipableSpacecardComponent.height + flipBackButton.height
  property int visibleHeight: height - flipBackButton.height

  property bool flipped: false // Change this property to trigger state show other side.
  property string userPaymentCode: "" // Used to display MatterCode™ and generate QRcode

  property bool showCustomizeOptions: false // is currently showing customize options.

  // Style choice driven properties:
  property color primaryColor: UIUX_UserCache.data.spacecardText
  property string cardstyle: UIUX_UserCache.data.spacecardStyle

  Component.onCompleted: {
    UIUX_UserCache.recached.connect(contextRoot.uiuxCacheChanged)
  }

  // keep up to date with the current UIUX persistant user settings:
  function uiuxCacheChanged() {
    contextRoot.primaryColor = UIUX_UserCache.data.spacecardText
    contextRoot.cardstyle = UIUX_UserCache.data.spacecardStyle
    spaceCardqrCodeImage.changeColor(contextRoot.primaryColor)
  }

  // return to idle deligation state.
  function resetState() {
    contextRoot.showCustomizeOptions = false
		contextRoot.flipped = false
    flipBackButton.opacity = 0.0
  }

  //-----------------------------------------------------------------------------
  // Flipable card:
  Flipable {
    id: flipableSpacecardComponent
    width: 336
    height: 192
    anchors.horizontalCenter: parent.horizontalCenter

    //-----------------------------------------------------------------------------
    // Front Side:
    front: Rectangle {
      id: cardFront
      width: parent.width
      height: parent.height
      color: "transparent"
      anchors.horizontalCenter: parent.horizontalCenter
      //----------------------
      Rectangle {
        id: frontBGpop
        width: parent.width + 1
        height: parent.height - 12
        y: + 7
        radius: 12
        color: contextRoot.primaryColor //"lightgray"
        opacity: 0.3
        anchors.horizontalCenter: parent.horizontalCenter
      }
      //----------------------
      Image {
        id: spacecardFrontImage
        source: ("qrc:/assets/spacecards/" + contextRoot.cardstyle + "-front.svg")
        smooth: true
        width: parent.width
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        // round image corners
        layer.enabled: true
        layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
          maskSource: Rectangle {
            width: spacecardFrontImage.width
            height: spacecardFrontImage.height
            radius: 12
          }
        }
      }
      //----------------------
      Text {
        x: 8
        y: 54
        visible: (DawgsStyle.ot_exchanges)
        text: "$(-+),000,000.00"
        font.pixelSize: DawgsStyle.fsize_title
        font.weight: Font.Medium //Font.DemiBold
        font.family: Fonts.font_HindVadodara_semibold
        color: contextRoot.primaryColor
      }
      //----------------------
      Button {
        id: showBackSideButton
        x: 8
        y: cardFront.height - height - 16
        padding: 4
        leftPadding: 2
        rightPadding: 6
        // Draw button Text:
        contentItem: Row {
          height: 28
          rightPadding: DawgsStyle.horizontalMargin
          spacing: 4
          // QRcode Icon:
          Text {
            id: qrIconText
            text: IconIndex.sd_qr
            color: contextRoot.primaryColor
            padding: 2
            font.pixelSize: 22 // DawgsStyle.fsize_title
            font.family: Fonts.icons_spacedawgs
            font.weight: Font.Thin
            font.styleName: "Regular"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
          }
          // Paymentcode text:
          Text {
            id: showPaymentCodeText
            height: parent.height
            text: qsTr("Show pay code")
            color: contextRoot.primaryColor
            font.pixelSize: DawgsStyle.fsize_normal
            font.weight: Font.DemiBold
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
          }
        }
        // Draw Button style:
        background: Rectangle {
          color: (contextRoot.hovered ? DawgsStyle.aa_hovered_bg : "transparent")
          border.color: contextRoot.primaryColor
          border.width: 1
          radius: 8
        }
        // Change cursor to pointing action as configured by root os system.
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.NoButton
          cursorShape: (showBackSideButton.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
        }
        // flip the card over when clicked on to show the user's MatterFi PaymentCode.
        onClicked: contextRoot.flipped = !contextRoot.flipped
      }//end 'showBackSideButton'
      //----------------------
      FontIconButton {
        x: cardFront.width - width - DawgsStyle.horizontalMargin
        y: cardFront.height - height - DawgsStyle.verticalMargin
        iconChar: IconIndex.sd_settings
        color: contextRoot,primaryColor
        fontFamilyName: Fonts.icons_spacedawgs
        onAction: contextRoot.showCustomizeOptions = !contextRoot.showCustomizeOptions
      }

    }//end 'cardFront'

    //-----------------------------------------------------------------------------
    // Back Side:
    back: Rectangle {
      id: cardBack
      width: parent.width
      height: parent.height
      color: "transparent"
      //----------------------
      Rectangle {
        id: backBGpop
        width: parent.width + 1
        height: parent.height - 12
        y: + 7
        radius: 12
        color: contextRoot.primaryColor //"lightgray"
        opacity: 0.3
        anchors.horizontalCenter: parent.horizontalCenter
      }
      //----------------------
      Image {
        id: spacecardBack
        source: ("qrc:/assets/spacecards/" + contextRoot.cardstyle + "-back.svg")
        smooth: true
        width: parent.width
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        // round image corners
        layer.enabled: true
        layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
          maskSource: Rectangle {
            width: spacecardBack.width
            height: spacecardBack.height
            radius: 12
          }
        }
      }
      //----------------------
      Row {
        width: parent.width
        height: parent.height
        y: 6 //DawgsStyle.verticalMargin
        x: DawgsStyle.horizontalMargin
        spacing: 2
        // MatterCode™ usage description
        Column {
          id: usageDescriptionColumn
          width: 185
          y: DawgsStyle.verticalMargin
          spacing: 6

          Text {
            text: qsTr("My pay code")
            width: parent.width
            color: contextRoot.primaryColor
            font.weight: Font.Black //Bold
            font.pixelSize: DawgsStyle.fsize_title
          }
          Text {
            text: qsTr("Scan with any MatterCode™ compatible wallet or tap to copy from the box below.")
            width: parent.width
            color: contextRoot.primaryColor
            wrapMode: Text.Wrap
            font.weight: Font.DemiBold
            font.pixelSize: DawgsStyle.fsize_small + 1
          }
        }
        // display user's scanable qr code
        MatterFi_QRCodeImage {
          id: spaceCardqrCodeImage
          width: 140
          primaryColor: contextRoot.primaryColor
          // need to wait a bit to ensure OT 'api' 
          // is ready to provide payment code
          Timer {
            id: callAlertTimer
            interval: 200
            running: true
            onTriggered: {
              // QR ends up as OTidentity.profile_OTModel.paymentCode
              spaceCardqrCodeImage.set_display_string(contextRoot.userPaymentCode)
            }
          }
        }
      }
      //----------------------
      MatterFi_PaymentCode {
        id: spacecardPaymentCode
        x: cardFront.width - width - DawgsStyle.horizontalMargin
        y: cardFront.height - height - DawgsStyle.verticalMargin - 2
        primaryColor: contextRoot.primaryColor
        displayLable: "" //qsTr("MatterCode™: ")
        displayText: (contextRoot.userPaymentCode !== "" ? contextRoot.userPaymentCode : "null")
      }
    }//end 'cardBack'

    //-----------------------------------------------------------------------------
    // Animations:
    transform: Rotation {
      id: flipAnimation
      origin.x: flipableSpacecardComponent.width / 2
      origin.y: flipableSpacecardComponent.height / 2
      axis.x: 0; axis.z: 0
      axis.y: 1 // Rotating around this axis
      angle: 0
    }

    states: State {
      name: "back"
      PropertyChanges { target: flipAnimation; angle: -180 }
      when: contextRoot.flipped
    }

    transitions: Transition {
      NumberAnimation { target: flipAnimation; property: "angle"; duration: 320 }
    }

    // get true bottom screen location
    function bottomY() {
      return flipableSpacecardComponent.y + flipableSpacecardComponent.height
    }

  }//end 'flipableSpacecardComponent'

  //-----------------------------------------------------------------------------
  // Clickable button to flip card back over:
  FontIconButton {
    id: flipBackButton
    iconChar: IconIndex.sd_close
    fontFamilyName: Fonts.icons_spacedawgs
    visible: (!contextRoot.showCustomizeOptions)
    enabled: (contextRoot.flipped)
    y: flipableSpacecardComponent.bottomY()
    opacity: 0.0
    anchors.horizontalCenter: parent.horizontalCenter
    onAction: {
      contextRoot.flipped = !contextRoot.flipped
      if (!contextRoot.flipped) {
        opacity = 0.0
      }
    } 
    // Apperance animation for flipBackButton
    ParallelAnimation {
      id: flipIconAnimation
      running: false
      YAnimator { target: flipBackButton
        from: flipableSpacecardComponent.bottomY() + 40
        to: flipableSpacecardComponent.bottomY()
        duration: 400
        easing.type: Easing.OutBack
      }
      OpacityAnimator { target: flipBackButton
        from: 0.0; to: 1.0;	duration: 400;
        easing.type: Easing.OutBack
      }
    }//end 'flipIconAnimation'
    Timer {
      id: cardBgAppearTimer
      interval: 250
      running: (!contextRoot.showCustomizeOptions && contextRoot.flipped)
      onTriggered: {
        flipIconAnimation.running = true
      }
    }
  }
//-----------------------------------------------------------------------------
}//end 'contextRoot'