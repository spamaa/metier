import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dawgs_TextField.qml
// Styled element used for the input of text strings from the user.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: 44
  z: 1
  color: ((textInput.focus || textInput.length > 0) ?
    DawgsStyle.aa_selected_bg : DawgsStyle.aa_hovered_bg );
  radius: 8
  border.color: ((textInput.focus || textInput.length > 0) ?
    DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol );
  border.width: 1

  property bool canClickOffClose: false // Can click away from component to stop it's editing.
  property bool isSeachBox: false       // Display additional eye glass icon in side the text box.
  property bool illegalPaste: false     // The clipboard paste violates the validation of TextInput.

  //----------------------
  // extend context reach into TextInput quick object
  property alias text: textInput.text
  property alias length: textInput.length
  property alias echoMode: textInput.echoMode
  property alias passwordMaskDelay: textInput.passwordMaskDelay
  property string placeholderText: "input some text..."
  property alias maximumLength: textInput.maximumLength
  property alias rightPadding: textInput.rightPadding

  signal onTextChanged()
  
  function clear() {
    textInput.clear()
    contextRoot.illegalPaste = false
  } 

  function paste() {
    // check length diffrences for error reporting
    checkClipboard.clear()
    checkClipboard.paste()
    // true input
    textInput.paste()
    if (checkClipboard.length !== textInput.length) {
      illegalPaste = true
    } else {
      illegalPaste = false
    }
    //debugger:
    console.log("Dawgs_TextField, pasting", illegalPaste, contextRoot.text, checkClipboard.text)
  }

  TextInput {
    id: checkClipboard
    visible: false
    enabled: visible
  }

  //----------------------
  // disable focus to TextInput on click outside contextRoot
  Rectangle {
    id: mouseClickOffActionRect
    width: rootAppPage.width
    height: rootAppPage.height
    z: 0

    parent: rootAppPage
    anchors.fill: parent

    visible: (textInput.focus === true && contextRoot.canClickOffClose === true)
    color: DawgsStyle.but_disabled
    opacity: 0.1
    // create clickable area to catch interactions if enabled outside
    // of the contextRoot component.
    MouseArea {
      anchors.fill: parent
      enabled: mouseClickOffActionRect.visible
      propagateComposedEvents: true
      onClicked: {
        textInput.focus = false
        mouse.accepted = false
      }
    }
  }

  //----------------------
  // Draw search icon if requested:
  Text {
    id: searchIconText
    text: IconIndex.sd_search
    visible: (contextRoot.isSeachBox)
    width: (visible ? font.pixelSize : 0 )
    color: DawgsStyle.font_color
    smooth: true
    font.pixelSize: DawgsStyle.fsize_accent
    font.family: Fonts.icons_spacedawgs
    font.weight: Font.Black
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    anchors {
      top: parent.top;
      topMargin: 4;
      left: parent.left;
      leftMargin: (visible ? 6 : 0);
      verticalCenter: parent.verticalCenter;
    }
  }

  //----------------------
  // Draw place holder text if requested:
  Text {
    id: placeHolderText
    text: contextRoot.placeholderText
    visible: (text.length > 0 && !textInput.focus && textInput.length < 1 );
    color: DawgsStyle.font_color // DawgsStyle.aa_norm_ol
    opacity: 0.5
    smooth: true
    font.pixelSize: DawgsStyle.fsize_normal
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    anchors {
      left: parent.left;
      leftMargin: (contextRoot.isSeachBox ? searchIconText.width + DawgsStyle.horizontalMargin : 6);
      verticalCenter: parent.verticalCenter;
    }
  }

  //----------------------
  // Clip text that extends past the view for TextInput
  Rectangle {
    id: inputViewRect
    width: parent.width - clipPadding - textInput.rightPadding
    height: parent.height - 8
    z: 1
    color: "transparent"
    clip: true
    property int clipPadding: (contextRoot.isSeachBox ? searchIconText.width + DawgsStyle.horizontalMargin : 0)
    anchors { 
      verticalCenter: parent.verticalCenter;
      left: searchIconText.right;
      leftMargin: 4;
    }
    // TextInput, issues with graphemes with TextFeild.
    TextInput {
      id: textInput
      width: inputViewRect.width
      height: inputViewRect.height
      color: DawgsStyle.font_color
      echoMode: TextInput.Normal
      renderType: Text.QtRendering
      rightPadding: 4
      leftPadding: 4
      font.pixelSize: DawgsStyle.fsize_accent
      anchors.fill: inputViewRect
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft

      onTextChanged: contextRoot.onTextChanged()

      // filter input characters:
      validator: RegularExpressionValidator { regularExpression: /[0-9A-Za-z\s]+/ }

      // Supports virtual keyboards only.
      //inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhUppercaseOnly | Qt.ImhLowercaseOnly //Qt.ImhEmailCharactersOnly

      // change mouse cursor on component hovering to os system equivalent
      MouseArea {
        id: interactionArea
        hoverEnabled: true
        //acceptedButtons: Qt.NoButton
        cursorShape: (interactionArea.containsMouse ? Qt.IBeamCursor : Qt.ArrowCursor)
        onClicked: {
          textInput.forceActiveFocus()
          //debugger:
          console.log("Dawgs_TextField active focus.")
        } 
        anchors.fill: parent
      }
    }//end 'textInput'
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'