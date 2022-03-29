import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_Button.qml
// This is used to draw Typical Button used accross the application.
// Allows the styling to be applied and changed in one place.
//-----------------------------------------------------------------------------
Button {
  id: contextRoot
  width: 100
  height: 48
  scale: (contextRoot.down ? DawgsStyle.but_shrink : 1.0)
  opacity: (contextRoot.enabled ? 1.0 : DawgsStyle.but_distrans)

  property string displayText: ""         // Text drawn on the button.
  property string fontIcon:    ""         // Show additional icon after display text.
  property var fontFamily: Fonts.icons_spacedawgs
  property string buttonType: "Secondary" // "Active" or "Secondary" or "Plain" display type?

  property bool justText: false  // Do not display anything but text and icon.
  property bool iconLeft: false  // Display icon on left side text instead of right.

  property int radius: contextRoot.height / 2 // bg radius.
  property bool manualWidth: false  // parent is providing width.

  //-----------------------------------------------------------------------------
  // When ready set the button width to match display contents width.
  function setWidthtoFit() {
    contextRoot.width = (buttonContents.anchors.leftMargin * 2) + textBody.width
    contextRoot.width = (contextRoot.fontIcon !== "" && !contextRoot.iconLeft ?
      contextRoot.width + (DawgsStyle.horizontalMargin * 2) : contextRoot.width );
    if (fontIcon.visible) {
      contextRoot.width += fontIcon.width //+ buttonContents.spacing
    }
  }

  // Called forced update due to changes from parent.
  function forceRefresh() {
    contextRoot.setWidthtoFit()
    contextRoot.hoveredChanged()
    //console.log("Dawgs_Button forced refreshed.", textBody.width)
  }

  Component.onCompleted: {
    if (manualWidth) return;
    contextRoot.setWidthtoFit()
  }

  //-----------------------------------------------------------------------------
  // Hover color upkeep:
  onHoveredChanged: {
    //console.log("DawgsButton moused over.", hovered)
    if (hovered) {
      bgRect.color = (contextRoot.enabled === false || contextRoot.buttonType == "Plain" ? "transparent" : 
        contextRoot.buttonType == "Active" ? DawgsStyle.buta_selected : DawgsStyle.aa_hovered_bg
      );
      bgOutline.outline_color = (contextRoot.enabled === false || contextRoot.buttonType == "Plain" ? 
        DawgsStyle.but_disabled : contextRoot.buttonType == "Active" ?  DawgsStyle.buta_active : DawgsStyle.buts_active
      );
    } else {
      bgRect.color = (contextRoot.enabled === false || contextRoot.buttonType == "Plain" ? "transparent" : 
        contextRoot.buttonType == "Active" ? DawgsStyle.buta_active : "transparent"
      );
      bgOutline.outline_color = (contextRoot.enabled === false || contextRoot.buttonType == "Plain" ? 
        DawgsStyle.but_disabled : contextRoot.buttonType == "Active" ?  DawgsStyle.buta_active : DawgsStyle.buts_active
      );
    }
  }

  //-----------------------------------------------------------------------------
  // What fills the button's space.
  contentItem: Row {
    id: buttonContents
    width: parent.width
    height: parent.height
    spacing: 10
    topPadding: 8
    bottomPadding: 8
    anchors {
      fill: parent
      leftMargin:  (contextRoot.justText ? 0 : 24)
      rightMargin: (contextRoot.justText ? 0 : 24)
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    // Additional Icon that is Left:
    Text {
      id: fontIconLeft
      text: contextRoot.fontIcon
      visible: (contextRoot.fontIcon !== "" && contextRoot.iconLeft)
      width: (visible ? font.pixelSize / 2 : 0)
      height: parent.height
      color: textBody.color
      font.family: contextRoot.fontFamily
      font.styleName: (contextRoot.fontFamily === Fonts.icons_spacedawgs ? "" : "Solid")
      font.weight: Font.DemiBold
      font.pixelSize: (contextRoot.justText ? DawgsStyle.fsize_normal : DawgsStyle.fsize_button)
      smooth: true
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }
    // Text Body:
    Text {
      id: textBody
      text: contextRoot.displayText
      height: parent.height
      color: (parent.enabled === false ? DawgsStyle.but_disabled :
        (contextRoot.buttonType == "Plain" ? DawgsStyle.font_color :
        (contextRoot.buttonType == "Active" ? DawgsStyle.but_txtnorm : 
        contextRoot.hovered ? DawgsStyle.buts_active : DawgsStyle.buts_active)
      ));
      font.weight: Font.DemiBold
      font.pixelSize: (contextRoot.justText ? DawgsStyle.fsize_normal : DawgsStyle.fsize_button)
      smooth: true
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }
    // Additional Icon that is Right:
    Text {
      id: fontIconRight
      text: contextRoot.fontIcon
      visible: (contextRoot.fontIcon !== "" && !contextRoot.iconLeft)
      height: parent.height
      color: textBody.color
      width: (visible ? font.pixelSize : 0)
      font.family: contextRoot.fontFamily
      font.styleName: (contextRoot.fontFamily === Fonts.icons_spacedawgs ? "" : "Solid")
      font.weight: Font.DemiBold
      font.pixelSize: (contextRoot.justText ? DawgsStyle.fsize_normal : DawgsStyle.fsize_button)
      smooth: true
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }

  }//end 'buttonContents'

  //-----------------------------------------------------------------------------
  // Provide button's background style.
  background: Rectangle {
    id: bgRect
    visible: (contextRoot.justText !== true)
    implicitWidth: contextRoot.width
    implicitHeight: contextRoot.height
    radius: contextRoot.radius
    color: (contextRoot.enabled === false || contextRoot.buttonType == "Plain" ? "transparent" : 
      contextRoot.buttonType == "Active" ? DawgsStyle.buta_active : "transparent"
    );
    // Outline:
    OutlineSimple {
      id: bgOutline
      outline_color: (contextRoot.enabled === false ? DawgsStyle.but_disabled : 
        (contextRoot.buttonType == "Plain" ? "transparent" :
        contextRoot.buttonType == "Active" ?  DawgsStyle.buta_active : DawgsStyle.buts_active
      ));
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