import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_ListDetailedDeligate.qml
// Provides a clickable list item with image, and four text descriptions. 
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  width: parent.width
	height: 92
  scale: contextRoot.down ? DawgsStyle.but_shrink : 1.0

  property var imageSource: "qrc:/assets/splash/logotype.svg"
  property color imageBG: DawgsStyle.page_bg
  property color border_color: "transparent"
  property string toplText: ""
  property string bottomlText: ""
  property string toprText: ""
  property string bottomrText: ""

  property bool is_selected: false

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
      x: DawgsStyle.horizontalMargin
      height: 48
      width: height
      color: contextRoot.imageBG
      radius: height / 2
      clip: true
      anchors.verticalCenter: parent.verticalCenter
      Image {
        source: contextRoot.imageSource
        smooth: true
        sourceSize.width: parent.height
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
    // Text shown:
    Column {
      id: textColumn
      x: imageDisplayed.x + imageDisplayed.width
      width: parent.width - x - (DawgsStyle.horizontalMargin * 2)
      spacing: 4
      anchors.verticalCenter: parent.verticalCenter
      // top descriptive texts shown:
      Row {
        id: descriptiveTopRow
        width: parent.width
        spacing: width - topLeftText.width - topRightText.width
        leftPadding: DawgsStyle.horizontalMargin
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
          id: topLeftText
          text: contextRoot.toplText
          color: DawgsStyle.font_color
          font.pixelSize: DawgsStyle.fsize_normal
          font.weight: Font.Bold
          anchors.verticalCenter: parent.verticalCenter
        }
        Text {
          id: topRightText
          text: contextRoot.toprText
          color: DawgsStyle.font_color
          font.pixelSize: DawgsStyle.fsize_small
          font.weight: Font.Bold
          anchors.verticalCenter: parent.verticalCenter
        }
      }
      // bottom descriptive texts shown:
      Row {
        id: descriptiveTextBottomRow
        width: parent.width
        spacing: width - bottomLeftText.width - bottomRightText.width
        leftPadding: DawgsStyle.horizontalMargin
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
          id: bottomLeftText
          text: contextRoot.bottomlText
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_contex
          anchors.verticalCenter: parent.verticalCenter
        }
        Text {
          id: bottomRightText
          text: contextRoot.bottomrText
          color: DawgsStyle.text_descrip
          font.pixelSize: DawgsStyle.fsize_contex
          anchors.verticalCenter: parent.verticalCenter
        }
      }
    }//end 'textColumn'
  }//end 'contentBody'
  //----------------------
  // Draw Button BG style:
  background: Rectangle {
    color: (contextRoot.is_selected ? DawgsStyle.aa_selected_bg : 
      (contextRoot.hovered ? DawgsStyle.aa_hovered_bg : DawgsStyle.norm_bg
    ));
    // Create bottom dividing line.
    Rectangle {
      width: parent.width
      height: 1
      color: DawgsStyle.aa_norm_ol
      anchors {
        bottom: parent.bottom;
      }
    }
  }
  //----------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: contextRoot
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

}//end 'contextRoot'