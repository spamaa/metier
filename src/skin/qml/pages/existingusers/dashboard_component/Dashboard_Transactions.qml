import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_Transactions.qml
// Display delegate for OT AccountActivity for an index entry from OT AccountList.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

  //-----------------------------------------------------------------------------
  // Viewed when no transaction activity is found and user needs to create some.
  Rectangle {
    id: noActivityViewRect
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: createActivityPromptColumn.height + DawgsStyle.verticalMargin
    color: DawgsStyle.norm_bg
    radius: 12
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
      id: createActivityPromptColumn
      width: parent.width
      spacing: 4
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_CenteredTitle {
        fontPixelSize: DawgsStyle.fsize_accent
        textTitle: qsTr("No transactions yet")
      }

      MatterFi_RoundButton {
        text: qsTr("Make one")
        anchors.horizontalCenter: parent.horizontalCenter
        border_color: DawgsStyle.buta_active
        onClicked: {
          pageRoot.pushDash("dashboard_send_funds")
        }
      }
    }
  }//end 'noActivityViewRect'

//-----------------------------------------------------------------------------
}//end 'contextRoot'