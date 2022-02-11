import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// Dawgs_ActionFooter.qml
// Displays a group of buttons or a single button typically used for navigation
// as a footer component in the application.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: 48
  color: "transparent"

  // Sets display text used on footer buttons.
  property string buttonTextOne: "Single Button"
  property string buttonTextTwo: "" // left blank if only using one button.
  // Set button icons if any used.
  property string buttonIconOne: ""
  property string fontIconOne: Fonts.icons_spacedawgs
  property string buttonIconTwo: ""
  property string fontIconTwo: Fonts.icons_spacedawgs
  // Set button styles used.  "Active" or "Secondary"
  property string buttonTypeOne: "Active"
  property string buttonTypeTwo: "Secondary"
  // Set buttons are enabled:
  property bool buttonOneEnabled: true
  property bool buttonTwoEnabled: true

  // Button Alignment settings
  property var singleButtonAlign: Qt.AlignHCenter
  // Qt.AlignLeft  Qt.AlignHCenter  Qt.AlignRight

  // callback when button is clicked.
  signal buttonAction(int butindex)
  // Handles enable/disable of buttons.
  property alias buttonOne: firstButton
  property alias buttonTwo: secondButton

  //-----------------------------------------------------------------------------
  // Animated refresh for updating the display of button contexts.
  function forceRefresh(props) {
    // update properties
    var oneWasVisibility = false
    for (var prop in props) {
      if (contextRoot[prop] !== undefined) {
        if (prop === "visible" && props[prop] === false) {
          oneWasVisibility = true
        }
        //console.log("update| " + prop + ":" + props[prop] + " from: "  + contextRoot[prop]);
        contextRoot[prop] = props[prop]
      } else {
        console.log("ActiveFooter property not found", prop)
        console.log(prop + ":" + props[prop]);
      }
    }
    if (oneWasVisibility !== true) {
      contextRoot.visible = true
      firstButton.forceRefresh()
      secondButton.forceRefresh()
      onlyButton.forceRefresh()
    }
  }

  //----------------------
  // Main display 'body'
  Row {
    id: body
    width: parent.width
    height: parent.height
    spacing: width - firstButton.width - secondButton.width
    visible: (contextRoot.buttonTextTwo !== "")
    anchors.horizontalCenter: parent.horizontalCenter

    Dawgs_Button {
			id: firstButton
      opacity: (contextRoot.buttonTextOne !== "" ? 1.0 : 0.0)
			displayText: contextRoot.buttonTextOne
      fontIcon: contextRoot.buttonIconOne
      fontFamily: contextRoot.fontIconOne
      enabled: contextRoot.buttonOneEnabled
			buttonType: contextRoot.buttonTypeOne
			onClicked: contextRoot.buttonAction(0)
		}

		Dawgs_Button {
      id: secondButton
      //visible: contextRoot.buttonTwoVisible
			displayText: contextRoot.buttonTextTwo
      fontIcon: contextRoot.buttonIconTwo
      fontFamily: contextRoot.fontIconTwo
      enabled: contextRoot.buttonTwoEnabled
			buttonType: contextRoot.buttonTypeTwo
			onClicked: contextRoot.buttonAction(1)
		}

  }//end 'body'

  //----------------------
  // Only single button mode?
  Dawgs_Button {
    id: onlyButton
    visible: (contextRoot.buttonTextTwo === "")
    displayText: contextRoot.buttonTextOne
    fontIcon: contextRoot.buttonIconOne
    enabled: contextRoot.buttonOneEnabled
    buttonType: contextRoot.buttonTypeOne
    onClicked: contextRoot.buttonAction(0)
    x: (singleButtonAlign === Qt.AlignRight ? body.width - width : 
      singleButtonAlign === Qt.AlignHCenter ? (body.width - width) / 2 : body.x
    );
  }
  
//-----------------------------------------------------------------------------
}//end 'contextRoot'