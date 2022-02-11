import QtQuick.Window 2.13
import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// NewWindow.qml
// Handles laoding and calling a new Window to be shown in the OS environment.
//-----------------------------------------------------------------------------
Window {
  id: newWindowRoot
  // Width constraints
  minimumWidth:  600
  width:         800 //<- starting value
  maximumWidth: 1024
  // Height constraints
  minimumHeight: 400
  height:        600 //<- starting value
  maximumHeight: 768
  //flags: Qt.FramelessWindowHint // draw window with no frame around it.
  visible: true
  color: DawgsStyle.norm_bg

  property var loaded_qml_file: ""
  //----------------------
  // Called to start loading the qml file into Loader component
  function load_qml_file() {
    console.log("Loading NewWindow Source qml file.")
    loader.source = newWindowRoot.loaded_qml_file
  }

  //-----------------------------------------------------------------------------
  // Display 'body'
  Rectangle {
    id: body
    width: parent.width
    height: parent.height
    color: "transparent"
    //----------------------
    // What prepares the QML file requested to be display in the new window:
    Loader {
      id: loader
      anchors.fill: parent
      source: ""

      onSourceChanged: {
        animation.running = true
      }

      NumberAnimation {
        id: animation
        target: loader.item
        duration: 500
        property: "opacity"
        from: 0
        to: 255
        easing.type: Easing.InExpo
      }
    }
    //----------------------
    // Busy loading qml file:
    BusyIndicator {
      id: pendingBusyIndicator
      scale: 1.0
      visible: (loader.status == Loader.Loading)
      anchors.centerIn: parent
    }

  }//end 'body'
//-----------------------------------------------------------------------------
}//end 'newWindowRoot'