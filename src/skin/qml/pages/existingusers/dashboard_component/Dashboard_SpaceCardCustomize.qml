import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_SpaceCardCustomize.qml
// Displays the customization setting for the user's dashboard spacecard.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

  signal flipCard()
  signal closeSettings()

  // called when a spacecard style is chosen.
  property string selected_style: UIUX_UserCache.data.spacecardStyle
  function onIndexSelection(model) {
    contextRoot.selected_style = model.file
    // update UIUX cache
    UIUX_UserCache.changeData("spacecardStyle", contextRoot.selected_style)
    UIUX_UserCache.changeData("spacecardText", model.textColor, true)
  }

  //----------------------
  // create grid model of all avaliable spacecard styles:
  property var cardStyles: ({})
  property var jsonStyleSheet: ({})
  function loadJSONfile() {
    var rawFile = new XMLHttpRequest()
    rawFile.open("GET", "qrc:/assets/spacecards/index.json", false)
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState === 4 && (rawFile.status === 200 || rawFile.status == 0)) {
        // json data keys:  { title, textColor, file }
        contextRoot.jsonStyleSheet = JSON.parse(rawFile.responseText)
        contextRoot.cardStyles = contextRoot.jsonStyleSheet.designs
        // debugger:
        //console.log("style sheet:", contextRoot.cardStyles)
        //QML_Debugger.listEverything(contextRoot.cardStyles)
      }
    }
    // make request to open the file.
    rawFile.send(null);
  }

  Component.onCompleted: {
    contextRoot.loadJSONfile()
  }

	//-----------------------------------------------------------------------------
  Rectangle {
    id: body
    width: parent.width
    height: parent.height
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Column {
      id: customizationColumn
      width: Math.min(340, parent.width)
      height: parent.height
      anchors.horizontalCenter: parent.horizontalCenter

      //----------------------
      // style selection grid.
      Rectangle {
        id: gridBGrect
        width: parent.width
        height: parent.height - footerRow.height - DawgsStyle.verticalMargin
        color: DawgsStyle.norm_bg
        radius: 12
        anchors.horizontalCenter: parent.horizontalCenter
        // layout all the options:
        ScrollView {
          id: gridScroller
          width: parent.width
          height: parent.height - DawgsStyle.verticalMargin
          clip: true
          ScrollBar.vertical.interactive: true
          ScrollBar.vertical.policy: ScrollBar.AsNeeded // AlwaysOn
          ScrollBar.horizontal.interactive: false
          ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
          // create the grid layout:
          Grid {
            id: cardSelectionGrid
            width: gridBGrect.width
            columns: 2
            spacing: 8
            rowSpacing: spacing
            padding: spacing
            topPadding: DawgsStyle.verticalMargin
            leftPadding: DawgsStyle.horizontalMargin
            // create card option:
            Repeater {
              id: cardsRepeater
              model: contextRoot.cardStyles
              anchors.horizontalCenter: parent.horizontalCenter
              // what the selection option looks like:
              Rectangle {
                id: cardDeligate
                width: 150
                height: 83
                radius: gridBGrect.radius
                color: (is_selected ? DawgsStyle.aa_selected_ol : "transparent")
                border.color: (is_selected ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol)
                border.width: 1
                property var spacecard_model: cardsRepeater.model[index]
                property bool is_selected: (spacecard_model.file === contextRoot.selected_style)
                property string img_source: ("qrc:/assets/spacecards/" + spacecard_model.file + "-thumb.svg")
                // draw the spacecard graphic
                Image {
                  id: spacecardFrontImage
                  source: (spacecard_model.file !== undefined ? img_source : "")
                  smooth: true
                  width: (is_selected ? parent.width - 4 : parent.width - 16)
                  height: (is_selected ? parent.height - 4 : parent.height - 16)
                  sourceSize.width: (is_selected ? parent.width - 4 : parent.width - 12)
                  sourceSize.height: (is_selected ? parent.height - 4 : parent.height - 12)
                  //fillMode: Image.PreserveAspectFit
                  anchors.centerIn: parent
                  // round image corners
                  layer.enabled: true
                  layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
                    maskSource: Rectangle {
                      width: spacecardFrontImage.width
                      height: spacecardFrontImage.height
                      radius: (is_selected ? cardDeligate.radius - 2 : cardDeligate.radius - 4)
                    }
                  }
                }
                // card's name
                Rectangle {
                  x: 12
                  y: (parent.height - cardnameText.height - 12)
                  height: cardnameText.height
                  width: cardnameText.width
                  color: (is_selected ? DawgsStyle.buta_selected : DawgsStyle.page_bg)
                  radius: 4

                  Text {
                    id: cardnameText
                    text: (spacecard_model.title !== undefined ? spacecard_model.title : "")
                    font.capitalization: Font.Capitalize
                    padding: 6
                    color: (is_selected ? DawgsStyle.but_txtnorm : DawgsStyle.text_descrip)
                  }
                }
                //----------------------
                // cardDeligate as Input area.
                MouseArea {
                  id: inputArea
                  width: parent.width
                  height: parent.height
                  hoverEnabled: true
                  //enabled: true
                  cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
                  onClicked: contextRoot.onIndexSelection(cardDeligate.spacecard_model)
                  onPressed: { }
                  onReleased: { }
                  onEntered: { }
                  onExited: { }
                }
              }//end 'cardDeligate'
            }//end 'cardsRepeater'
          }//end 'cardSelectionGrid'
        }//end 'gridScroller'
      }//end 'gridBGrect'

      //-----------------------------------------------------------------------------
      Row {
        id: footerRow
        height: 96
        topPadding: 28
        bottomPadding: DawgsStyle.verticalMargin
        spacing: DawgsStyle.horizontalMargin
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        //----------------------
        Button {
          width: parent.width / 3 * 2 - DawgsStyle.horizontalMargin
          height: 52
          onClicked: contextRoot.closeSettings()
          // Draw button Text:
          contentItem: Text {
            text: qsTr("done")
            color: DawgsStyle.font_color
            font.pixelSize: DawgsStyle.fsize_accent
            //font.weight: Font.DemiBold
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
          }
          // Draw Button style:
          background: Rectangle {
            color: (parent.hovered ? DawgsStyle.buta_selected : DawgsStyle.buta_active)
            border.color: DawgsStyle.buta_active
            border.width: 1
            radius: 12
          }
          // Change cursor to pointing action as configured by root os system.
          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
          }
        }
        //----------------------
        Button {
          width: parent.width / 3
          height: 52
          onClicked: contextRoot.flipCard()
          // Draw button Text:
          contentItem: Text {
            id: flipButText
            text: qsTr("flip")
            color: DawgsStyle.font_color
            font.pixelSize: DawgsStyle.fsize_accent
            //font.weight: Font.DemiBold
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
          }
          // Draw Button style:
          background: Rectangle {
            color: (parent.hovered ? DawgsStyle.aa_selected_bg : "transparent")
            border.color: (parent.hovered ? DawgsStyle.aa_selected_ol : flipButText.color)
            border.width: 1
            radius: 12
          }
          // Change cursor to pointing action as configured by root os system.
          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
          }
        }
      }
    }//end 'customizationColumn'
  }//end 'body'

  //----------------------
  // Bottom menu animation played when flipping spacecard:
  state: "closed"
  states: [
    State {
      name: "closed"
      PropertyChanges { target: footerRow; opacity: 0.0; 
        y: (parent.height + footerRow.height)
      }
    },
    State {
      name: "open"
      PropertyChanges { target: footerRow; opacity: 1.0; 
        y: (parent.height - footerRow.height - DawgsStyle.verticalMargin)
      }
    }
  ]

  transitions: [
    Transition {
      from: "closed"; to: "open"
      NumberAnimation { target: footerRow; property: "opacity"; duration: 680 }
      NumberAnimation { target: footerRow; property: "y"; duration: 800; easing.type: Easing.OutBack }
    }
  ]

//-----------------------------------------------------------------------------
}//end 'contextRoot'