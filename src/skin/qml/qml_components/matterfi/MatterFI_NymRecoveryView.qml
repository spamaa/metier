import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// MatterFI_NymRecoveryView.qml
// Provides interaction point for recovery of a nym using a seed phrase.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: body.height

  Component.onCompleted: {
    contextRoot.recalibrateVectors()
  }

  Component.onDestruction: {
    if (importingBusyIndicator.running) {
      startup.displayNamePrompt.disconnect(parent.otsignalDisplayNamePrompt)
    }
  }

  // Recovery functionality:
  property bool showAdvancedOptions: true // type, lang, password. OT's additonal options.
  property var passingWords: "" // the combined chain of words used to import the user's wallet.
  property var wordErrorHighlight: undefined // used to emphasize a word input box grid index error.
  property var requiredWordCount: 12 //this is temp, it is set via combo_box
  property var longestWord: 8 //api.longestSeedWord <- can not be notifi-able, is updated at later time
  property var wordsAreValid: true // on checking word entry, are all the fields proper?
  property var words: [] // contianer for the on screen words used.

  //----------------------
  // Attempt recovery with current word input:
  function tryRecovery() {
    // if the user still needs to enter more words:
    if ( contextRoot.checkStillNeedWords() ) {
      console.log("Still need more recovery words: ", 
        contextRoot.wordErrorHighlight, contextRoot.requiredWordCount, "\n");
      moreWordsToolTip.visible = true
      stillNeedWordsToolTipTimer.start()
      return
    }
    // if the user entered all the vector words
    console.log("Import starting.")
    importingBusyIndicator.running = true
    startup.displayNamePrompt.connect(parent.otsignalDisplayNamePrompt)
    delayWorkStartTimer.restart() // to provide work 'is happening' to user
  }

  // see if the user still needs to fill all the word fields.
  function checkStillNeedWords() {
    contextRoot.passingWords = ""
    var index = 0
    var still_need_words = false
    while (index < contextRoot.requiredWordCount) {
      // make sure all indexes have a value
      if (contextRoot.words[index] === undefined || contextRoot.words[index] === "") {
        still_need_words = true
        // Can highlight index that is having the issue:
        //contextRoot.wordErrorHighlight = index
        break
      }
      // bring the Phrase together for import usage
      if (index === 0) {
        passingWords += contextRoot.words[index]
      } else {
        passingWords += " " + contextRoot.words[index]
      }
      index += 1
    }
    return still_need_words
  }

  // move cursor to the next entry location for text [tab, enter, space]
  function trynextEntryField(index, fieldReady) {
    wordEntryBoxes.itemAt(index).active_focus = false
    var nextindex = (index + 1 >= wordEntryBoxes.count) ? 0 : index + 1
    wordEntryBoxes.itemAt(nextindex).active_focus = true
    var stillneedwords = contextRoot.checkStillNeedWords()
    if (stillneedwords === false) {
      pageRoot.setActionFooter({ buttonTwoEnabled: true })
    } else {
      pageRoot.setActionFooter({ buttonTwoEnabled: false })
    }
  }

  // when verification signals change on input fields for mnemonic phrase:
  function wordentryVerified(index, text, fieldReady) {
    if (fieldReady === true) {
      contextRoot.words[index] = text
      var stillneedwords = contextRoot.checkStillNeedWords()
      if (stillneedwords === false) {
        pageRoot.setActionFooter({ buttonTwoEnabled: true })
      }
      return
    } else {// input was not validated
      contextRoot.words[index] = undefined
    }
    pageRoot.setActionFooter({ buttonTwoEnabled: false })
  }

  // clear all the user defiend settings and reset the word entry fields
  // this is where the CheckBox settings get applied.
  function recalibrateVectors() {
    contextRoot.wordErrorHighlight = undefined
    encryption_CB.refresh()
    language_CB.refresh()
    seedsize_CB.refresh()
    contextRoot.words = []
    contextRoot.requiredWordCount = seedsize_CB.getWordCount()
    contextRoot.longestWord = api.longestSeedWord
    console.log("SeedSize box changed.", contextRoot.requiredWordCount, contextRoot.longestWord)
  }

  //-----------------------------------------------------------------------------
  // Is busy importing seed display:
  Rectangle {
    id: displayIsBusyRect
    visible: (importingBusyIndicator.running === true)
    width: body.width
    height: 256
    color: "transparent"
    anchors.centerIn: parent
    // Display notification of expected pause while importing the seed
    Column {
      width: parent.width
      height: parent.height
      spacing: 16
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        text: qsTr("attempting recovery...")
        color: DawgsStyle.font_color
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: DawgsStyle.fsize_normal
      }
      
      BusyIndicator {
        id: importingBusyIndicator
        running: false
        visible: (parent.visible)
        scale: 1.0
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
    // delay the start call to give the UI time to notify the user of the work pause
    Timer {
      id: delayWorkStartTimer
      interval: 200
      running: false
      onTriggered: {
        var seedtype_int = encryption_CB.currentIndex + 1
        var seedlang_int = language_CB.currentIndex + 1
        // OT will fire a signal when ready after importing
        api.importSeed(seedtype_int, seedlang_int, 
          contextRoot.passingWords, passPhraseTextInput.text
        );
      }
    }
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    //height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    visible: (importingBusyIndicator.running === false)
    clip: true
    spacing: DawgsStyle.verticalMargin / 3
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
    // Optional password phrase usage for seed importing.
    Row {
      id: enterPassphraseRow
      width: body.width
      visible: (contextRoot.showAdvancedOptions)
      spacing: 8
      topPadding: 8
      //----------------------
      ButtonGroup { 
        id: passPhraseOptions
        exclusive: false
      }
      Dawgs_RadioButton {
        id: enablePassPhrase
        checked: false
        width: 32
        onlyBox: true
        anchors.verticalCenter: parent.verticalCenter
        onToggled: passPhraseTextInput.clear()
        ButtonGroup.group: passPhraseOptions
      }
      //----------------------
      Text {
        id: passPhraseEntryNote
        text: qsTr("Uses Password:")
        width: 108
        color: DawgsStyle.font_color
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: DawgsStyle.fsize_normal
        anchors.verticalCenter: parent.verticalCenter
      }
      //----------------------
      Dawgs_TextField {
        id: passPhraseTextInput
        placeholderText: "enter password..."
        width: (body.width - passPhraseEntryNote.width - 
          enablePassPhrase.width - DawgsStyle.horizontalMargin - 8 );
        height: 38
        enabled: (enablePassPhrase.checked)
        visible: (enabled)
        maximumLength: 32
        echoMode: TextInput.Password
        onTextChanged: { }
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    //----------------------
    // Create the word input grid table:
    Rectangle {
      id: enterBackupWords
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
        // Draw each input word box:
        Repeater {
          id: wordEntryBoxes
          model: (contextRoot.requiredWordCount)
          MatterFi_RecoveryWordInput {
            width: wordGridModelView.square_size
            height: 40
            language:   (language_CB.currentIndex + 1)
            encryption: (encryption_CB.currentIndex + 1)
            longestWord: contextRoot.longestWord
            display_index: index
            issue_at_index: (contextRoot.wordErrorHighlight)
            onNextBox: contextRoot.trynextEntryField(index, fieldReady)
            onVerificationChecked: contextRoot.wordentryVerified(index, text, fieldReady)
          }
        }
      }//end 'wordGridModelView'
    }//end 'enterBackupWords'

  //----------------------
	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'contextRoot'