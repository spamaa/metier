import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dashboard_ListDeligate.qml
// Provides a clickable list item with image, text description, and icon. 
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  width: parent.width
	height: 64
  scale: contextRoot.down ? DawgsStyle.but_shrink : 1.0

  property var imageSource: ""
  property string contactPaymentCode: ""
  property string notaryIcon: ""
  property color imageBG: DawgsStyle.page_bg
  property string topText: qsTr("Text above")
  property string bottomText: qsTr("Text bellow")
  property color border_color: "transparent"
  property int item_index: -1

  //----------------------
  // Draw button Text:
  contentItem: Rectangle {
    id: contentBody
    width: contextRoot.width
    height: contextRoot.height
    color: "transparent"
    anchors.verticalCenter: parent.verticalCenter
    // image displayed:
    Rectangle {
      id: imageDisplayed
      color: contextRoot.imageBG
      width: parent.height
      height: parent.height
      radius: height / 2
      clip: true
      anchors.verticalCenter: parent.verticalCenter

      MatterFi_BlockChainIcon {
        id: blockchainIcon
        visible: (contextRoot.notaryIcon.length > 0)
        height: parent.height
        width: blockchainIcon.height
        abvNotary: (contextRoot.notaryIcon !== undefined ? contextRoot.notaryIcon : "")
        anchors.verticalCenter: parent.verticalCenter
      }

      Image {
        id: avatarImage
        visible: (contextRoot.imageSource.length > 0)
        source: contextRoot.imageSource
        smooth: true
        width: contextRoot.height - DawgsStyle.verticalMargin
        height: contextRoot.height - DawgsStyle.verticalMargin
        sourceSize.width: contextRoot.height - DawgsStyle.verticalMargin
        sourceSize.height: contextRoot.height - DawgsStyle.verticalMargin
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        // round circle image
        layer.enabled: true
        layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
          maskSource: Rectangle {
            width: avatarImage.width
            height: avatarImage.height
            radius: imageDisplayed.radius
          }
        }
      }

      Dawgs_Avatar {
        height: contextRoot.height - DawgsStyle.verticalMargin
        width:  contextRoot.height - DawgsStyle.verticalMargin
        bgcolor: DawgsStyle.page_bg
        avatarUrl: "" // TODO: use contact_model.image
        visible: (contactPaymentCode.length > 0)
        paymentCode: contactPaymentCode
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }//end 'imageDisplayed'

    
    // over under descriptive text shown:
    Column {
      id: descriptiveTextColumn
      spacing: 0
      leftPadding: 12
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: imageDisplayed.right

      Text {
        text: contextRoot.topText
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_accent
        font.family: Fonts.font_HindVadodara_semibold
        font.weight: Font.DemiBold
      }
      Text {
        text: contextRoot.bottomText
        color: DawgsStyle.text_descrip
        font.pixelSize: DawgsStyle.fsize_lable
        font.family: Fonts.font_HindVadodara_semibold
        font.weight: Font.DemiBold
      }
    }
    // complement icon:
    Text {
      text: IconIndex.sd_more
      color: DawgsStyle.text_descrip
      font.pixelSize: DawgsStyle.fsize_xlarge
      font.family: Fonts.icons_spacedawgs
      font.weight: Font.Black
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: contentBody.right
    }
  }//end 'contentBody'
  //----------------------
  // Draw Button BG style:
  background: Rectangle {
    color: DawgsStyle.norm_bg
    border.color: (contextRoot.hovered ? DawgsStyle.aa_norm_ol : "transparent")
    border.width: 1
    radius: 12
  }
  //----------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    id: mouseHoverArea
    anchors.fill: contextRoot
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

}//end 'contextRoot'