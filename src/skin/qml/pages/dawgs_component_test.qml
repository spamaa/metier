import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Pust most to all the Dawgs custom design conponents onto the screen for
// a quick over view of their design presence.
//-----------------------------------------------------------------------------
Page {
	id: pageRoot
	width: rootAppPage.width
	height: rootAppPage.height
	title: qsTr("Component Testing")
	objectName: "component_testing"
	background: null //Qt.transparent

	//-----------------------------------------------------------------------------
	function onButton(button_index) {
		console.log("Button Test, cicked:", button_index)
	}

	//-----------------------------------------------------------------------------
	Column {
		id: body
    width: parent.width - (DawgsStyle.horizontalMargin * 2)
    height: parent.height
    spacing: 8
		anchors {
			leftMargin:  DawgsStyle.horizontalMargin
			rightMargin: DawgsStyle.horizontalMargin 
			horizontalCenter: parent.horizontalCenter
		}

    //----------------------
    // Titles:
		Dawgs_AccentTitle {
      accentText: qsTr("SpaceDawgs")
      titleText: qsTr("All Components.")
    }

    Dawgs_CenteredTitle {
      textTitle: qsTr("Centered Title")
    }

    //----------------------
    // Toggles:
    Dawgs_YesNoToggle {
      onToggled: {
        console.log("Yes/No Toggled:", selectedIndex)
      }
    }

    //----------------------
    // Radio Button Group:
    ButtonGroup { 
      id: radiogroup
      exclusive: true

      property var selected_item: null

      onClicked: {
        if (selected_item !== button.text) {
          selected_item = button.text
          console.log("Radio Selected:", radiogroup.selected_item)
          if (selected_item == "Dark") {
            DawgsStyle.set_display_mode("dark")
          } else {
            DawgsStyle.set_display_mode("light")
          }
        } else {
          button.checked = false
          selected_item = null
          console.log("Radio Deselect.")
        }
      }
    }

    Column {
      id: radioButtonColumn
      width: parent.width
      spacing: 8

      Dawgs_RadioButton {
        id: firstRadioButton
        text: qsTr("Dark")
        accentText: qsTr("darkmode test display")
        ButtonGroup.group: radiogroup
      }

      Dawgs_RadioButton {
        text: qsTr("Light")
        accentText: qsTr("lightmode test the looks")
        ButtonGroup.group: radiogroup
      }
    }

    Dawgs_TextField {
      placeholderText: "name a theme.."
      onTextChanged: {
        console.log("TextInput is:", text)
        //DawgsStyle.change_theme(text, true)
      }
    }

    //----------------------
    // Button Styles:
    Row {
      spacing: 12
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_Button {
        topPadding: 18
        displayText: qsTr("Test 1")
        onClicked: pageRoot.onButton(0)
      }

      Dawgs_Button {
        topPadding: 18
        enabled: false
        fontIcon: IconIndex.fa_check
        fontFamily: Fonts.icons_solid
        displayText: qsTr("Test 2")
        onClicked: pageRoot.onButton(1)
      }
    }
    
    /*
    Row {
      spacing: 12
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_Button {
        topPadding: 18
        displayText: qsTr("Test 3")
        buttonType: "Active"
        fontIcon: IconIndex.sd_chevron_right
        onClicked: pageRoot.onButton(2)
      }

      Dawgs_Button {
        topPadding: 18
        displayText: qsTr("Test 4")
        buttonType: "Active"
        onClicked: pageRoot.onButton(3)
      }
    }
    */

    //----------------------
    // Url clickable link:
    Dawgs_TextButton {
      id: importWalletInsteadButton
      text_name: qsTr("url text test")
      qrc_url: "qrc:/pages/blank.qml"
      onLinkActivated: {
        console.log("Hyper linked text activated.", link)
      }
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // Test ToolTips and Context popups.
    Row {
      id: toolContextRow
      spacing: pageRoot.width - 92

      FontIconButton {
        id: callAlertTest
        onAction: {
          callAlertTimer.start()
          dawgsAlertTest.visible = true
        }
        // Display the Alert
        Dawgs_Alert {
          id: dawgsAlertTest
          text: qsTr("Alert Testing.")
          // Display for a period of time?
          Timer {
            id: callAlertTimer
            interval: 2000
            running: false
            onTriggered: {
              dawgsAlertTest.visible = false
            }
          }
        }
      }

      Dawgs_ContextualHelp {
        id: contextualHelp
        text: qsTr("This is a contextual pop up element that always grows left and down.")
      }
    }//end 'toolContextRow'


    //----------------------
    // Footers:
    Dawgs_ActionFooter {
      buttonTextOne: qsTr("Splash")
      buttonIconOne: ""
      buttonTypeOne: "Secondary"
      buttonTextTwo: qsTr("Cards")
      buttonIconTwo: IconIndex.sd_chevron_right
      buttonTypeTwo: "Active"
      onButtonAction: {
        console.log("Footer Button pressed:", butindex)
        if (butindex === 0) {        // 'Back'
          rootAppPage.clearStackHome("pages/splash.qml")
        } else if (butindex === 1) { // 'Next'
          rootAppPage.pushPage("pages/onboardingflow/onboard_card_frame.qml")
        }
      }
    }

    Dawgs_ActionFooter {
      buttonTextOne: qsTr("Continue")
      buttonTypeOne: "Active"
      onButtonAction: {
        console.log("Single Footer pressed:", butindex)
      }
    }

    Dawgs_ActionFooter {
      buttonTextOne: qsTr("Card Styler")
      buttonTypeOne: "Active"
      buttonIconOne: IconIndex.sd_chevron_right
      singleButtonAlign: Qt.AlignRight
      onButtonAction: {
        rootAppPage.pushPage("pages/existingusers/spacedawgs_cardstyler.qml")
      }
    }

  //----------------------
	}//end 'body'

  Dawgs_Button {
    id: navBackButton
    width: 52
    x: 6
    y: parent.height - 64
    justText: true
    iconLeft: true
    manualWidth: true
    fontIcon: IconIndex.fa_chevron_left
    fontFamily: Fonts.icons_solid
    buttonType: "Plain"
    displayText: qsTr("back")
    onClicked: console.log("nav button")
  }

//-----------------------------------------------------------------------------
}