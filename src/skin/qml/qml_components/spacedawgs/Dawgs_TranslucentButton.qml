import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TranslucentButton.qml
// Provides a slightly see threw clickable button.
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  width: 100
  height: 36
  scale: (contextRoot.down ? DawgsStyle.but_shrink : 1.0)
  opacity: (contextRoot.enabled ? 1.0 : DawgsStyle.but_distrans)

  property string displayText: ""         // Text drawn on the button.
  property string fontIcon:    ""         // Show additional icon after display text.
  property var fontFamily: Fonts.icons_spacedawgs

  //-----------------------------------------------------------------------------
  // Hover color upkeep:
  onHoveredChanged: {
    if (hovered) {
      bgRect.color = (contextRoot.enabled === false ? "transparent" : DawgsStyle.aa_selected_bg);
      bgOutline.outline_color = (contextRoot.enabled === false ? 
        DawgsStyle.but_disabled : DawgsStyle.aa_selected_ol
      );
    } else {
      bgRect.color = "transparent"
      bgOutline.outline_color = (contextRoot.enabled === false ? 
        DawgsStyle.but_disabled : DawgsStyle.buta_active
      );
    }
  }

  //-----------------------------------------------------------------------------
  // What fills the button's space.
  contentItem: Item {
    id: buttonContents
    width: parent.width
    height: parent.height
    anchors {
      fill: parent
      leftMargin:  (contextRoot.displayText === "" ? 0 : 18)
      rightMargin: (contextRoot.displayText === "" ? 0 : 18)
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    // Text Body:
    Text {
      id: textBody
      text: contextRoot.displayText
      height: parent.height
      color: (parent.enabled === false ? DawgsStyle.but_disabled : DawgsStyle.but_txtnorm);
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_small
      smooth: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }
    // Additional Icon that is Right:
    Text {
      id: fontIconRight
      text: contextRoot.fontIcon
      height: parent.height
      color: textBody.color
      font.family: contextRoot.fontFamily
      font.styleName: (contextRoot.fontFamily === Fonts.icons_spacedawgs ? "" : "Solid")
      font.weight: Font.Bold
      font.pixelSize: 42 //DawgsStyle.fsize_xlarge
      smooth: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      anchors.verticalCenter: parent.verticalCenter
    }

  }//end 'buttonContents'

  //-----------------------------------------------------------------------------
  // Provide button's background style.
  background: Rectangle {
    id: bgRect
    visible: (contextRoot.justText !== true)
    implicitWidth: parent.width
    implicitHeight: parent.height
    radius: 8
    color: "transparent"
    // Outline:
    OutlineSimple {
      id: bgOutline
      outline_color: (contextRoot.enabled === false ? DawgsStyle.but_disabled : DawgsStyle.buta_active);
      implicitWidth: parent.width
      implicitHeight: parent.height
      radius: parent.radius
    }
  }

  //-----------------------------------------------------------------------------
  // Change cursor to pointing action as configured by root os system.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    cursorShape: (contextRoot.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
  }

}//end 'contextRoot'