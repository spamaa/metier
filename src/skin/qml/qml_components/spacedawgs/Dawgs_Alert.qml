import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_Alert.qml
// A context popup display that can show additional information about an
// on screen action to the user.
//-----------------------------------------------------------------------------
ToolTip {
  id: contextRoot
  visible: false
  text: qsTr("Alert!")

  property bool smallMode: false // Make the text tiny to fit everything.

  contentItem: Text {
    padding: 8
    text: contextRoot.text
    font.pixelSize: (contextRoot.smallMode ? DawgsStyle.fsize_contex : DawgsStyle.fsize_alert)
    color: DawgsStyle.alert_txt
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

  background: Rectangle {
    color: DawgsStyle.alert_bg
    opacity: 0.90
    radius: 8
    OutlineSimple {
      outline_color: DawgsStyle.alert_ol
      radius: parent.radius
    }
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'