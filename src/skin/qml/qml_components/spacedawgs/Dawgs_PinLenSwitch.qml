import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dawgs_PinLenSwitch.qml
// Offers a choice between two pin length options, and only one can be selected.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  color: "transparent"
  width: body.width
  height: body.height
  border.color: DawgsStyle.aa_norm_ol
  border.width: 1
  radius: 12

  property int pinLengthMode: (UIUX_UserCache.data.pinLengthMode)

  signal lengthChanged()

  // create display container:
  Column {
    id: body
    width: (modeoneText.width + selectorSwitch.width + modetwoText.width + DawgsStyle.horizontalMargin)
    padding: 10
    bottomPadding: 4
    spacing: 4
    anchors.centerIn: parent
    // create descriptive text:
    Text {
      id: descripText
      text: qsTr("Change pin length")
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_normal
      font.weight: Font.DemiBold
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // create switch toggler:
    Item {
      id: modeTogglerRow
      width: parent.width
      height: modeoneText.height + DawgsStyle.verticalMargin + 4
      anchors.horizontalCenter: parent.horizontalCenter

      //----------------------
      Text {
        id: modeoneText
        text: qsTr("4 digits")
        color: (contextRoot.pinLengthMode === 4 ? DawgsStyle.aa_selected_ol : contextRoot.border.color)
        font.pixelSize: DawgsStyle.fsize_normal
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
      }
      //----------------------
      Switch {
        id: selectorSwitch
        text: ""
        width: 86
        height: 38
        checked: (contextRoot.pinLengthMode === 6)
        spacing: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        indicator: Item {}

        contentItem: Item {
          id: content
          width: selectorDeligate.width
          height: modeoneText.height
          anchors.horizontalCenter: parent.horizontalCenter
          // the indicator and its position:
          Rectangle {
            id: selectorDeligate
            width: (height * 2)
            height: parent.height
            y: parent.height / 2 - height / 2
            radius: height / 2
            color: DawgsStyle.aa_selected_bg
            border.color: DawgsStyle.aa_selected_ol

            Rectangle {
              id: selector
              width: parent.height - 4
              height: width
              x: (selectorSwitch.checked ? parent.width - width - 2 : 2)
              y: 2
              radius: height / 2
              color: DawgsStyle.aa_selected_ol
              border.color: DawgsStyle.aa_selected_bg
            }
          }
        }
        // update mode selection:
        onToggled: {
          var pinlen_setting = 4
          if (selectorSwitch.checked) {
            pinlen_setting = 6
          }
          UIUX_UserCache.changeData('pinLengthMode', pinlen_setting, true)
          contextRoot.pinLengthMode = UIUX_UserCache.data.pinLengthMode
          contextRoot.lengthChanged()
        }
        // Change cursor to pointing action as configured by root os system.
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.NoButton
          cursorShape: (selectorSwitch.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
        }
      }

      //----------------------
      Text {
        id: modetwoText
        text: qsTr("6 digits")
        color: (contextRoot.pinLengthMode === 6 ? DawgsStyle.aa_selected_ol : DawgsStyle.but_disabled)
        font.pixelSize: DawgsStyle.fsize_normal
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
      }

    }//end 'modeTogglerRow'

  //----------------------
  }//end 'body'
//-----------------------------------------------------------------------------
}//end 'contextRoot'