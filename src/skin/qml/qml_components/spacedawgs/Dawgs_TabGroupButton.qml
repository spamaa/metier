import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TabGroupButton.qml
// Utilizes a QML ButtonGroup parent to draw a single selection styled component.
//-----------------------------------------------------------------------------
RadioButton {
  id: contextRoot
  height: 32
  checked: false

  text: qsTr("TabButton")       // display text.
  property int textPadding: 5   // additional horizontal padding.

  //----------------------
  // Background indicates selection in Button Group:
  background: Rectangle {
    id: bgRectangle
    height: parent.height
    width: parent.width
    radius: height / 2
    color: (contextRoot.checked ? DawgsStyle.buta_selected : 
      (contextRoot.hovered ? DawgsStyle.aa_selected_bg : "transparent")
    );
  }

  //----------------------
  // Doesn't use an indicator, just taking advantage of ButtonGroup single
  // selection management and to organize call signals for display response.
  indicator: Rectangle { color: "transparent" }

  //----------------------
  // What the lable text looks like:
  contentItem: Text {
    id: displayText
    text: contextRoot.text
    padding: 5
    leftPadding: contextRoot.textPadding
    rightPadding: leftPadding
    opacity: enabled ? 1.0 : 0.3
    font.pixelSize: DawgsStyle.fsize_lable
    font.weight: Font.DemiBold
    color: DawgsStyle.but_txtnorm
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
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