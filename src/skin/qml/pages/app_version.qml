import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Displays the current App Version.
//-----------------------------------------------------------------------------
Page {
  id: pageRoot
  title: qsTr("New Recovery Phrase")
  width: rootAppPage.width
  height: rootAppPage.height
  objectName: "new_recovery_phrase"

  background: null //Qt.transparent
  //-----------------------------------------------------------------------------
  function onDoneButton() {
    rootAppPage.popPage(); // navigate back
  }

  //-----------------------------------------------------------------------------
  // The main display 'body' object:
  Column {
    id: body
    width: pageRoot.width
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      id: headLiner
      text: qsTr("Product Version")
      color: DawgsStyle.text_accent
      smooth: true
      font.capitalization: Font.AllUppercase
      font.weight: Font.Bold
      font.pixelSize: DawgsStyle.fsize_title
      anchors.horizontalCenter: parent.horizontalCenter
      horizontalAlignment: Text.AlignHCenter
      bottomPadding: 24
      topPadding: 18
    }

    Text {
      id: selectionForReceivingTypeTextDescription
      text: (api.versionString(DawgsStyle.qml_release_version))
      bottomPadding: 24
      font.weight: Font.DemiBold
      font.pixelSize: DawgsStyle.fsize_title
      color: pageRoot.fontColor
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      anchors.horizontalCenter: body.horizontalCenter
    }

    //-----------------------------------------------------------------------------
    Dawgs_Button {
      id: done_button
      topPadding: 18
      displayText: qsTr("Go Back")
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: pageRoot.onDoneButton()
    }

  //-----------------------------------------------------------------------------
  }// display column
}// page