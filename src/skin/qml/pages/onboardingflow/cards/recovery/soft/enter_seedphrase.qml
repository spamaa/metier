import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/recover_soft/enter_seedphrase.qml"
// User is recovering a software wallet using a mnemonic phrase.
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("Recoverying soft wallet")
	objectName: "object_identity_tracing_assitant"
	background: null //Qt.transparent

  property bool showAdvancedOptions: false // Shows additional recovery options.

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {
    cardDeligateRoot.tryRecovery()
  }

  function onButtonBack() {
    pageRoot.popCard()
  }

  // Listen for OT setup signal is finished importing mnemonic wallet phrase.
  function otsignalDisplayNamePrompt() {
    pageRoot.pushCard("qrc:/boarding_cards/finalsteps/namewallet.qml")
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    cardDeligateRoot.setActionFooterConfiguration()
    cardDeligateRoot.recalibrateVectors()
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: qsTr("back"),
      buttonTypeOne: "Secondary",
      buttonIconOne: "",
      buttonTextTwo: qsTr("check"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.fa_check,
      fontIconTwo: Fonts.icons_solid,
      buttonTwoEnabled: false
    }
    pageRoot.setActionFooter(props)
  }

  //-----------------------------------------------------------------------------
  // Recovery functionality:
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
    if ( cardDeligateRoot.checkStillNeedWords() ) {
      console.log("Still need more recovery words: ", 
        cardDeligateRoot.wordErrorHighlight, cardDeligateRoot.requiredWordCount, "\n");
      moreWordsToolTip.visible = true
      stillNeedWordsToolTipTimer.start()
      return
    }
    // if the user entered all the vector words
    console.log("Import starting.")
    importingBusyIndicator.running = true
    startup.displayNamePrompt.connect(cardDeligateRoot.otsignalDisplayNamePrompt);
    delayWorkStartTimer.restart() // to provide work 'is happening' to user
  }

  // see if the user still needs to fill all the word fields.
  function checkStillNeedWords() {
    cardDeligateRoot.passingWords = ""
    var index = 0
    var still_need_words = false
    while (index < cardDeligateRoot.requiredWordCount) {
      // make sure all indexes have a value
      if (cardDeligateRoot.words[index] === undefined || cardDeligateRoot.words[index] === "") {
        still_need_words = true
        // Can highlight index that is having the issue:
        //cardDeligateRoot.wordErrorHighlight = index
        break
      }
      // bring the Phrase together for import usage
      if (index === 0) {
        passingWords += cardDeligateRoot.words[index]
      } else {
        passingWords += " " + cardDeligateRoot.words[index]
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
    var stillneedwords = cardDeligateRoot.checkStillNeedWords()
    if (stillneedwords === false) {
      pageRoot.setActionFooter({ buttonTwoEnabled: true })
    } else {
      pageRoot.setActionFooter({ buttonTwoEnabled: false })
    }
  }

  // when verification signals change on input fields for mnemonic phrase:
  function wordentryVerified(index, text, fieldReady) {
    if (fieldReady === true) {
      cardDeligateRoot.words[index] = text
      var stillneedwords = cardDeligateRoot.checkStillNeedWords()
      if (stillneedwords === false) {
        pageRoot.setActionFooter({ buttonTwoEnabled: true })
      }
      return
    } else {// input was not validated
      cardDeligateRoot.words[index] = undefined
    }
    pageRoot.setActionFooter({ buttonTwoEnabled: false })
  }

  // clear all the user defiend settings and reset the word entry fields
  // this is where the CheckBox settings get applied.
  function recalibrateVectors() {
    cardDeligateRoot.wordErrorHighlight = undefined
    encryption_CB.refresh()
    language_CB.refresh()
    seedsize_CB.refresh()
    cardDeligateRoot.words = []
    cardDeligateRoot.requiredWordCount = seedsize_CB.getWordCount()
    cardDeligateRoot.longestWord = api.longestSeedWord
    console.log("SeedSize box changed.", cardDeligateRoot.requiredWordCount, cardDeligateRoot.longestWord)
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
          cardDeligateRoot.passingWords, passPhraseTextInput.text
        );
      }
    }
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    visible: (importingBusyIndicator.running === false)
    clip: true
    spacing: 8
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("recover wallet")
      titleText: qsTr("Enter seed phrase")
    }

    //----------------------
    // recovery options:
    Rectangle {
      id: optionboxes
      height: 32
      visible: (cardDeligateRoot.showAdvancedOptions)
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
          onInteraction: cardDeligateRoot.recalibrateVectors()
        }
        // Show SeedLang selection:
        MatterFi_SeedLangComboBox {
          id: language_CB
          currentIndex: 0
          width: optionboxes.width / 4
          model: api.seedLanguageModelQML(encryption_CB.currentIndex + 1)
          onInteraction: cardDeligateRoot.recalibrateVectors()
        }
        // Show SeedSize selection:
        MatterFi_SeedSizeComboBox {
          id: seedsize_CB
          width: optionboxes.width / 4
          model: api.seedSizeModelQML(encryption_CB.currentIndex + 1)
          onInteraction: cardDeligateRoot.recalibrateVectors()
        }
      }
    }

    //----------------------
    // Optional password phrase usage for seed importing.
    Row {
      id: enterPassphraseRow
      width: body.width
      visible: (cardDeligateRoot.showAdvancedOptions)
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
          model: (cardDeligateRoot.requiredWordCount)
          MatterFi_RecoveryWordInput {
            width: wordGridModelView.square_size
            height: 40
            language:   (language_CB.currentIndex + 1)
            encryption: (encryption_CB.currentIndex + 1)
            longestWord: cardDeligateRoot.longestWord
            display_index: index
            issue_at_index: (cardDeligateRoot.wordErrorHighlight)
            onNextBox: cardDeligateRoot.trynextEntryField(index, fieldReady)
            onVerificationChecked: cardDeligateRoot.wordentryVerified(index, text, fieldReady)
          }
        }
      }//end 'wordGridModelView'
    }//end 'enterBackupWords'

  //----------------------
	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'