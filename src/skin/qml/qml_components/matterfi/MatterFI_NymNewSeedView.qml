import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// MatterFI_NymNewSeedView.qml
// Provides interaction point for generating a seed phrase for a new nym.
//
// TODO: review usage for SeedTree OT model to subdivide wallet into multiple
//  nym identities.
//
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: body.height

  property bool showAdvancedOptions: true // type, lang, password. OT's additonal options.

  Component.onCompleted: {
    contextRoot.recalibrateVectors()
  }

  // provide the a new recovery word list:
  property var requiredWordCount: 12
  property var longestWord: 8
  property var recoveryWords: []
  function fetchWords() {
    var seedtype_int = encryption_CB.currentIndex + 1
    var seedlang_int = language_CB.currentIndex + 1
    var strength_int = 128  // [128 || 256]
    contextRoot.recoveryWords = api.createNewSeed(seedtype_int, seedlang_int, strength_int);
    UIUX_UserCache.temp.createdNewSeed = true
    console.log("Made a new set of recovery words.")
  }

  // clear all the user defiend settings and reset the word entry fields
  // this is where the generation settings are applied.
  function recalibrateVectors() {
    encryption_CB.refresh()
    language_CB.refresh()
    seedsize_CB.refresh()
    contextRoot.requiredWordCount = seedsize_CB.getWordCount()
    contextRoot.longestWord = api.longestSeedWord
    contextRoot.recoveryWords = []
    contextRoot.fetchWords()
    //debugger:
    console.log("Seed options changed.", contextRoot.requiredWordCount, contextRoot.longestWord)
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    //height: parent.height - DawgsStyle.verticalMargin
    clip: true
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    // recovery options:
    Rectangle {
      id: optionboxes
      height: 32
      visible: (contextRoot.showAdvancedOptions)
      width: body.width
      color: "transparent"
      anchors.horizontalCenter: parent.horizontalCenter
      // import seed type selection configuration
      Row {
        spacing: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        // Show Encryption type selection:
        MatterFi_SeedTypeComboBox {
          id: encryption_CB
          currentIndex: 0
          width: optionboxes.width / 3
          model: api.seedTypeModelQML()
          onInteraction: contextRoot.recalibrateVectors()
        }
        // Show SeedLang selection:
        MatterFi_SeedLangComboBox {
          id: language_CB
          currentIndex: 0
          width: optionboxes.width / 4
          model: api.seedLanguageModelQML(encryption_CB.currentIndex + 1)
          onInteraction: contextRoot.recalibrateVectors()
        }
        // Show SeedSize selection:
        MatterFi_SeedSizeComboBox {
          id: seedsize_CB
          width: optionboxes.width / 4
          model: api.seedSizeModelQML(encryption_CB.currentIndex + 1)
          onInteraction: contextRoot.recalibrateVectors()
        }
      }
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
          model: (contextRoot.recoveryWords)

          MatterFi_RecoveryWordInput {
            width: wordGridModelView.square_size
            height: 40
            longestWord: contextRoot.longestWord
            display_index: index
            displayOnly: true
            text: modelData
          }
        }
      }//end 'wordGridModelView'
    }//end 'displayBackupWords'
	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'contextRoot'