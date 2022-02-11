import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/boarding_cards/show_newseed.qml"
// Another card for on boarding flow.  *quick template*
//-----------------------------------------------------------------------------
Page {
	id: cardDeligateRoot
	width: cardStackView.width
	height: cardStackView.height
	title: qsTr("New Software Wallet Seed")
	objectName: "a_card_ofmany"
	background: null //Qt.transparent

  property bool showAdvancedOptions: false  // show seed configuration settings.

  //-----------------------------------------------------------------------------
  // ActionFooter callback functions:
  function onButtonSingle() {  }

  function onButtonNext() {
    //TODO: finish signal refactor for navigation.
    // when checking conditions, it should fire the
    // signal which will navigate to the next setup Page
    api.seedBackupFinished();
  }

  function onButtonBack() { 
    pageRoot.popCard()
  }

  //-----------------------------------------------------------------------------
  // Configure static ActionFooter shared between cards.
  Component.onCompleted: {
    startup.displayNamePrompt.connect(cardDeligateRoot.otsignalReadyForProfileName)
    cardDeligateRoot.setActionFooterConfiguration()
    cardDeligateRoot.recalibrateVectors()
    waitBeforeAlowingNextTimer.start()
  }

  Component.onDestruction: {
    startup.displayNamePrompt.disconnect(cardDeligateRoot.otsignalReadyForProfileName)
  }

  function otsignalReadyForProfileName() {
    pageRoot.pushCard("qrc:/boarding_cards/finalsteps/enterpin.qml")
  }

  function setActionFooterConfiguration() {
    var props = {
      buttonTextOne: qsTr("back"),
      buttonTypeOne: "Secondary",
      buttonIconOne: "",
      buttonOneEnabled: true,
      buttonTextTwo: qsTr("next"),
      buttonTypeTwo: "Active",
      buttonIconTwo: IconIndex.sd_chevron_right,
      fontIconTwo: Fonts.icons_spacedawgs,
      buttonTwoEnabled: false
    }
    pageRoot.setActionFooter(props)
  }

  Timer {
    id: waitBeforeAlowingNextTimer
    interval: 1400
    running: false
    onTriggered: {
      pageRoot.setActionFooter({ buttonTwoEnabled: true })
    }
  }
  
  // provide the current user's recovery word list:
  property var requiredWordCount: 12
  property var longestWord: 8
  property var recoveryWords: []
  function fetchWords() {
    // already created a set of words for this device:
    if (rootAppPage.isFirstRun === false || UIUX_UserCache.temp.createdNewSeed === true) {
      cardDeligateRoot.recoveryWords = api.getRecoveryWords()
    } else { // needs new words
      var seedtype_int = encryption_CB.currentIndex + 1
      var seedlang_int = language_CB.currentIndex + 1
      var strength_int = 128  // [128 || 256]
      cardDeligateRoot.recoveryWords = api.createNewSeed(seedtype_int, seedlang_int, strength_int);
      UIUX_UserCache.temp.createdNewSeed = true
      console.log("Made a new set of recovery words.")
    }
  }

  // clear all the user defiend settings and reset the word entry fields
  // this is where the CheckBox settings get applied.
  function recalibrateVectors() {
    encryption_CB.refresh()
    language_CB.refresh()
    seedsize_CB.refresh()
    console.log("Seed options changed.", cardDeligateRoot.requiredWordCount, cardDeligateRoot.longestWord)
    cardDeligateRoot.requiredWordCount = seedsize_CB.getWordCount()
    cardDeligateRoot.longestWord = api.longestSeedWord
    cardDeligateRoot.recoveryWords = []
    cardDeligateRoot.fetchWords()
  }

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height - DawgsStyle.verticalMargin
    topPadding: DawgsStyle.verticalMargin
    clip: true
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_AccentTitle {
      accentText: qsTr("Write this down")
      titleText: qsTr("Your seed phrase")
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
          model: (cardDeligateRoot.recoveryWords)

          MatterFi_RecoveryWordInput {
            width: wordGridModelView.square_size
            height: 40
            longestWord: cardDeligateRoot.longestWord
            display_index: index
            displayOnly: true
            text: modelData
          }
        }
      }//end 'wordGridModelView'
    }//end 'displayBackupWords'

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'cardDeligateRoot'