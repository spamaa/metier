import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_RadioButton.qml
// Provides a selection object paired with descriptive text for use alone or
// when in a ButtonGroup component.
//-----------------------------------------------------------------------------
RadioButton {
  id: contextRoot
  width: parent.width
  height: 64
  leftPadding: 16
  checked: false

  property bool onlyBox: false // Hides every thing but the indicator.
  text: (onlyBox ? "" : qsTr("RadioButton") )
  property string accentText: (onlyBox ? "" : qsTr("More details about what this does.") )

  //----------------------
  // what check box looks like:
  indicator: Rectangle {
    id: markerOutlineRect
    height: contextRoot.height - 36
    width: height
    implicitHeight: contextRoot.height - 36
    implicitWidth: implicitHeight
    x: (contextRoot.onlyBox === false ? contextRoot.leftPadding : 0)
    y: contextRoot.height / 2 - height / 2
    radius: 10
    color: "transparent"
    border.color: (contextRoot.checked ? DawgsStyle.buta_active : DawgsStyle.but_txtnorm)
    border.width: 1
    anchors.verticalCenter: parent.verticalCenter
    // check marker
    Text {
      id: markerDeligate
      visible: (contextRoot.checked)
      height: markerOutlineRect.height - 8
      width: height
      text: IconIndex.fa_check
      font.family: Fonts.icons_solid
      font.styleName: "Solid"
      font.pixelSize: height / 2
      color: parent.border.color
      smooth: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      anchors.fill: parent
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }

  //----------------------
  // what the lable text next to it looks like:
  contentItem: Column {
    height: markerOutlineRect.height
    width: contextRoot.width
    spacing: 1
    topPadding: 4
    leftPadding: 8
    anchors.verticalCenter: parent.verticalCenter
    // main title Text display:
    Text {
      text: contextRoot.text
      //font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_button
      opacity: enabled ? 1.0 : 0.3
      color: DawgsStyle.but_txtnorm
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      leftPadding: contextRoot.indicator.width + contextRoot.spacing
    }
    // accent Text display:
    Text {
      text: contextRoot.accentText
      font.pixelSize: DawgsStyle.fsize_lable
      opacity: enabled ? 1.0 : 0.3
      color: DawgsStyle.text_descrip
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      leftPadding: contextRoot.indicator.width + contextRoot.spacing
    }
  }

  //----------------------
  background: Rectangle {
    color: "transparent"
    implicitHeight: parent.height
    implicitWidth: parent.width
    visible: (contextRoot.onlyBox === false)
    radius: 8
    border.color: (contextRoot.checked ? DawgsStyle.aa_selected_ol : 
      (contextRoot.hovered ? DawgsStyle.text_descrip : DawgsStyle.aa_norm_ol)
    );
    border.width: 1
    // bg filler:
    Rectangle {
      color: (contextRoot.checked ? DawgsStyle.buta_active : 
        (contextRoot.hovered ? DawgsStyle.aa_hovered_bg : "transparent")
      );
      implicitHeight: parent.height
      implicitWidth: parent.width
      opacity: (contextRoot.checked ? 0.10 : 1.0)
    }
  }

  //-----------------------------------------------------------------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'