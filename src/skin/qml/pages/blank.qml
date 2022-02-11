import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Just a Blank Page.
//-----------------------------------------------------------------------------
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("Blank")
	objectName: "blank"
	background: null //Qt.transparent

	//-----------------------------------------------------------------------------
	function onButton() {
		console.log("Button Test.")
	}

	//-----------------------------------------------------------------------------
	Column {
		id: body

		Text {
      id: selectionForReceivingTypeTextDescription
      text: "Intentionally left Blank."
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_title
      color: DawgsStyle.font_color
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      anchors.horizontalCenter: body.horizontalCenter
    }

    Dawgs_Button {
      id: done_button
      topPadding: 18
      displayText: qsTr("Test")
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: pageRoot.onButton()
    }

	}//end 'body'

//-----------------------------------------------------------------------------
}