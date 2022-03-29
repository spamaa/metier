import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/change_pofile.qml"
// Where the user changes their personal display avatar seen by others.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Change Profile.")
	objectName: "dashboard_change_profile"
	background: null //Qt.transparent

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 2)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      opacity: 0.4
      x: parent.width - width
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("close")
			onClicked: pageRoot.popDash()
		}

    Text {
      text: qsTr("Change Profile Pic")
      font.pixelSize: DawgsStyle.fsize_accent
      font.weight: Font.Bold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    //-----------------------------------------------------------------------------
    // Create avatar BG color selection Gird.
    Grid {
      id: avatarBGSelectionGrid
      width: 320
      columns: 3
      spacing: 6
      padding: 0
      topPadding: DawgsStyle.verticalMargin
      anchors.horizontalCenter: parent.horizontalCenter
      property int selectionIndex: UIUX_UserCache.data.avatarBGIndex

      Repeater {
        id: picturesRepeater
        model: DawgsStyle.faceBGcolors
        // what the selection option looks like:
        Button {
          id: bgSelectionGridDeligate
          width: 102
          height: 108
          padding: 2
          property bool is_selected: (avatarBGSelectionGrid.selectionIndex === index)

          contentItem: Rectangle {
            color: "transparent"

            Dawgs_Avatar {
              id: avatarColor
              height: parent.height - 32
              width: height
              y: 4
              bgColorIndex: index
              faceIndex: index //UIUX_UserCache.data.avatarFileIndex
              anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
              id: face_name
              text: DawgsStyle.faceFileNames[index]
              color: DawgsStyle.font_color
              topPadding: 4
              anchors.top: avatarColor.bottom
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
        
          background: Rectangle {
            radius: 12
            color: (is_selected ? DawgsStyle.aa_selected_bg : 
              (hovered ? DawgsStyle.aa_hovered_bg : "transparent")
            );
            border.color: (is_selected ? DawgsStyle.aa_selected_ol : 
              (parent.down ? DawgsStyle.aa_selected_bg : DawgsStyle.aa_norm_ol)
            );
            border.width: 1
          }

          onClicked: {
            UIUX_UserCache.changeData("avatarBGIndex", index, true)
            avatarBGSelectionGrid.selectionIndex = index
          }

          // Change cursor to pointing action as configured by root os system.
          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: (bgSelectionGridDeligate.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
          }
        }//end 'bgSelectionGridDeligate'
      }//end 'picturesRepeater'
    }//end 'avatarBGSelectionGrid'

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'