import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_Collectibles.qml
// Used for displaying a user's SpaceDawgs collectibles.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

	//-----------------------------------------------------------------------------
  // Comming Soon Prompt.
  Rectangle {
    id: comingSoonViewRect
    width: parent.width
    height: comingSoonPromptColumn.height + DawgsStyle.verticalMargin
    color: DawgsStyle.norm_bg
    radius: 12
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
      id: comingSoonPromptColumn
      width: parent.width
      spacing: 4
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_CenteredTitle {
        fontPixelSize: DawgsStyle.fsize_accent
        textTitle: qsTr("Coming soon")
      }

      MatterFi_RoundButton {
        text: qsTr("Learn more")
        anchors.horizontalCenter: parent.horizontalCenter
        border_color: DawgsStyle.buta_active
        onClicked: {
					
        }
      }
    }
  }//end 'comingSoonViewRect'

//-----------------------------------------------------------------------------
}//end 'contextRoot'