import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/view_seedphrase.qml"
// Password protected view where user can check their wallet recovery words.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard View Seed Phrase.")
	objectName: "dashboard_view_seedphrase"
	background: null //Qt.transparent

  property int longestWord: 8 // needs to be non-NOTIFYable property.
  Component.onCompleted: {
    dashViewRoot.fetchWords()
    dashViewRoot.longestWord = api.longestSeedWord
  }

  // provide the current user's recovery word list:
  property var recoveryWords: []
  function fetchWords() {
    dashViewRoot.recoveryWords = api.getRecoveryWords()
  }

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //----------------------
  // Prompt user to enter pin to continue.
  MatterFi_PinWall {
    id: promptToEnterPin
    syncTimer: false // always ask for pin to view
    anchors.horizontalCenter: parent.horizontalCenter
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    visible: (promptToEnterPin.needPin === false)
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 4)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      x: parent.width - width
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("close")
			onClicked: pageRoot.popDash()
		}

    Text {
      text: qsTr("Your seed phrase")
      font.pixelSize: DawgsStyle.fsize_accent
      font.weight: Font.DemiBold
      bottomPadding: DawgsStyle.verticalMargin
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }

    //----------------------
    // Create the word deligate grid table:
    Rectangle {
      id: displayBackupWords
      width: body.width
      height: wordGridModelView.height
      color: "transparent"
      radius: 4.0
      anchors.horizontalCenter: parent.horizontalCenter

      Grid {
        id: wordGridModelView
        columns: 3
        columnSpacing: 4
        rowSpacing: 8
        anchors.horizontalCenter: parent.horizontalCenter
        property int square_size: Math.min((parent.width / 3 - 4), 100)
        // Draw each recovery word box:
        Repeater {
          id: wordEntryBoxes
          model: (dashViewRoot.recoveryWords)

          MatterFi_RecoveryWordInput {
            width: wordGridModelView.square_size
            height: 40
            longestWord: dashViewRoot.longestWord
            display_index: index
            displayOnly: true
            text: modelData
          }
        }
      }//end 'wordGridModelView'
    }//end 'displayBackupWords'

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'