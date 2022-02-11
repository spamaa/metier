import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dashboard_RightDrawer.qml
// Displayed when the Dashboard's Header bar's right menu icon is interacted with.
//-----------------------------------------------------------------------------
ToolBar {
  id: contextRoot
  height: 54
  property string displayText: "'displayText'" // Value set from parent context.

  Component.onCompleted: {
    UIUX_UserCache.recached.connect(contextRoot.uiuxUpdated)
  } 

  // called when a UIUX setting change was detected.
  function uiuxUpdated() {
    userAvatarNymButtonImage.bgColorIndex = UIUX_UserCache.data.avatarBGIndex
  }

  //-----------------------------------------------------------------------------
  background: Rectangle {
    implicitHeight: parent.height
    color: DawgsStyle.norm_bg
  }

  //-----------------------------------------------------------------------------
  Row {
    id: body
    spacing: 6
    leftPadding: 6
    height: parent.height
    anchors.fill: parent
    //----------------------
    // left button
    Button {
      id: callLeftDrawerButton
      height: parent.height - 8
      width: height
      anchors.verticalCenter: parent.verticalCenter
      // show user avitar
      contentItem: Dawgs_Avatar {
        id: userAvatarNymButtonImage
        height: parent.height
        width: height
        bgColorIndex: UIUX_UserCache.data.avatarBGIndex
        faceIndex: UIUX_UserCache.data.avatarFileIndex
        anchors.centerIn: parent
      }
      background: Rectangle {
        height: parent.height - 8
        width: height
        color: DawgsStyle.norm_bg //"transparent"
        border.color: DawgsStyle.buta_selected // DawgsStyle.faceBGcolors[0]
        border.width: 2
        radius: width / 2
        anchors.centerIn: parent
      }
      onClicked: {
        console.log("Multiple wallet asset nyms are not currently fully supported, instead testing theme dark/light mode.")
        DawgsStyle.toggle_display_mode()
        //leftDrawer.open()
      }
      // Change cursor to pointing action as configured by root os system.
      /*
      MouseArea {
        anchors.fill: parent
        enabled: false
        acceptedButtons: Qt.NoButton
        cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
      }
      */
    }
    //----------------------
    // user's profile name
    Label {
      width: body.width - callLeftDrawerButton.width - callRightDrawerButton.width - (DawgsStyle.horizontalMargin * 2)
      text: contextRoot.displayText
      color: DawgsStyle.font_color
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_accent
      verticalAlignment: Qt.AlignVCenter
      elide: Label.ElideLeft
      anchors.verticalCenter: parent.verticalCenter
    }
    //----------------------
    // right button
    ToolButton {
      id: callRightDrawerButton
      height: parent.height
      enabled: (contextRoot.parent.dashStackViewlength < 2)
      contentItem: Text {
        text: IconIndex.sd_more
        opacity: enabled ? 1.0 : 0.3
        color: callRightDrawerButton.down ? DawgsStyle.but_txtnorm : DawgsStyle.but_txtnorm
        font.weight: Font.Black
        font.pixelSize: DawgsStyle.fsize_button + 2
        font.family: Fonts.icons_spacedawgs
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }
      background: Rectangle {
        height: callRightDrawerButton.height - 10
        width: height
        color: (callRightDrawerButton.hovered ? DawgsStyle.aa_hovered_bg : "transparent")
        radius: height / 2
        anchors.centerIn: parent
      }
      onClicked: rightDrawer.open()
      // Change cursor to pointing action as configured by root os system.
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: (callRightDrawerButton.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
      }
    }
  }//end 'body'
  
  //-----------------------------------------------------------------------------
  // Contained drawer objects:
  Dashboard_LeftDrawer {
    id: leftDrawer
  }
  Dashboard_RightDrawer {
    id: rightDrawer
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'