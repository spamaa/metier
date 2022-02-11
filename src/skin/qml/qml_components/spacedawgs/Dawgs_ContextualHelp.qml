import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// Dawgs_ContextualHelp.qml
// Button component to provide a growing PopUp component with populated context.
//-----------------------------------------------------------------------------
FontIconButton {
  id: contextRoot
  iconChar: IconIndex.fa_exclamation_circle
  fontFamilyName: Fonts.icons_solid

  property string text: qsTr("Help context display string.") // what text to show.
  property bool animateToScreenRight: true  // Animate screengrowth direction.

  //-----------------------------------------------------------------------------
  onAction: {
    toolTipContainer.open()
  }

  //-----------------------------------------------------------------------------
  ToolTip {
    id: toolTipContainer
    width: 250
    height: body.height
    visible: false
    timeout: -1

    x: (animateToScreenRight ? startingX : startingX * -1 - contextRoot.width)
    y: startingY
    property int startingX: (0 - parent.width)
    property int startingY: 0 - (parent.height / 4)

    // reset starting location
    onAboutToHide: {
      contextRoot.state = "closed"
    }
    onClosed: {}

    onAboutToShow: {
      contextRoot.state = "open"
    }

    enter: Transition {}
    exit: Transition {}

    //----------------------
    // Create the PopUp component's display content:
    contentItem: Rectangle {
      id: bodyBgFiller
      width: 250
      height: body.height
      color: DawgsStyle.page_bg
      radius: 12
      // starting props:
      x: (animateToScreenRight ? bodyBgFiller.width * -1 : bodyBgFiller.width)
      y: bodyBgFiller.height  * -1;
      opacity: 0.0
      scale:   0.0

      // Organize display contents.
      Column {
        id: body
        width: parent.width
        padding: DawgsStyle.horizontalMargin
        bottomPadding: DawgsStyle.verticalMargin + 4
        spacing: 12
        // Display the title string:
        Text {
          width: body.width - DawgsStyle.horizontalMargin
          text: contextRoot.text
          wrapMode: Text.Wrap
          font.weight: Font.DemiBold
          font.pixelSize: DawgsStyle.fsize_normal
          color: DawgsStyle.font_color
        }
        // Provide closing button.
        MatterFi_RoundButton {
          id: buttonClose
          enabled: (contextRoot.state === "open")
          x: body.width - buttonClose.width - (DawgsStyle.horizontalMargin * 2) + 8
          text: qsTr("close")

          onClicked: {
            toolTipContainer.hide()
          }
        }
      }//end 'body'
    //----------------------
    }//end 'bodyBgFiller'

    background: Rectangle { color: "transparent" }
  }
  
  //-----------------------------------------------------------------------------
  // States for transitioning:
  state: "closed"
  states: [
    State { name: "closed"
      PropertyChanges {
        target: bodyBgFiller
        opacity: 0.0
        scale:   0.0
        x: (animateToScreenRight ? (bodyBgFiller.width / 2) * -1 : bodyBgFiller.width / 2)
        y: (bodyBgFiller.height / 2) * -1;
      }
    },
    State { name: "open"
      PropertyChanges {
        target: bodyBgFiller
        opacity: 1.0
        scale:   1.0
        x: contextRoot.width / 4
        y: contextRoot.width / 4
      }
    }
  ]//end 'states'

  //-----------------------------------------------------------------------------
  // Aninations played on state transitions:
  transitions: [
    Transition {
      from: "open"; to: "closed"
      ParallelAnimation {
        ScaleAnimator   { target: bodyBgFiller; duration: 400 }
        OpacityAnimator { target: bodyBgFiller; duration: 400 }
        YAnimator { target: bodyBgFiller; duration: 300 } //; easing.type: Easing.OutQuint }
        XAnimator { target: bodyBgFiller; duration: 300 } //; easing.type: Easing.OutQuint }
      }
    },
    Transition {
      from: "closed"; to: "open"
      ParallelAnimation {
        ScaleAnimator   { target: bodyBgFiller; duration: 400 }
        OpacityAnimator { target: bodyBgFiller; duration: 400 }
        YAnimator { target: bodyBgFiller; duration: 300 } //; easing.type: Easing.OutQuint }
        XAnimator { target: bodyBgFiller; duration: 300 } //; easing.type: Easing.OutQuint }
      }
    }
  ]//end 'transitions'
  
//-----------------------------------------------------------------------------
}//end 'contextRoot'