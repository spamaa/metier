import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
import "qrc:/assets/lottie"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/manage_assets.qml"
// Display details about an Asset held in the user's AccountList OT model.
//
// Also part of OT initial setup, to see if can proceed with user blockchains,
// call 'api.checkStartupConditions()' to check.
//
// Blockchain Functions:
//    enabledCount
//
//    chainEnabled(int chain)
//    chainDisabled(int chain)
//    enabledChanged(int enabledCount)
//    disableChain(int chain)
//    enableChain(int chain)
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard Manage Assets.")
	objectName: "dashboard_manage_assets"

  property var blockChainList_OT: []    // Holds onto test/live displayed OT Blockchain list Model.
  property bool performing_work: false  // Limits enable/disable to single blockchain changes at a time.

  //----------------------
  Component.onCompleted: {
    api.chainsChanged.connect(dashViewRoot.blockChainChanged)
    dashViewRoot.populateBlockChains()
  }

  Component.onDestruction: {
    api.chainsChanged.disconnect(dashViewRoot.blockChainChanged)
  }

  //----------------------
  // make the display list of available blockchains:
  property bool show_testnet_chains: false // Default blockchain live/test state.
  function populateBlockChains(istest_chains = false) {
    dashViewRoot.blockChainList_OT = api.blockchainChooserModelQML(istest_chains)
    dashViewRoot.show_testnet_chains = istest_chains
    // debugger:
    //console.log("Blockchain ListModel:", dashViewRoot.blockChainList_OT)
    //QML_Debugger.listEverything(dashViewRoot.blockChainList_OT)
  }

  //----------------------
  // detected a user change to the block chain list
  function blockChainChanged(new_count) {
    //debugger:
    //console.log("Block Chain Chooser: blockchains changed, Active:", new_count)
  }

  //----------------------
  // called when a block chian is selected from the list
  function onBlockChainSelection(block_model) {
    // debugger:
    //console.log("Individual Blockchain model details:", block_model)
    //QML_Debugger.listEverything(block_model)
  }

  //----------------------
  // Called on drag drop finish
  function swapChainIndexes(from_index, to_index) {
    // TODO: TypeError: Property 'move' of object opentxs::ui::BlockchainSelectionQt(0x7fae5ac59440) is not a function
    // https://doc.qt.io/qt-5/qlist.html#move
    // https://doc.qt.io/qt-5/qlist.html#swapItemsAt
    //blockChainListView.model.move(from_index, to_index) // <- not a function
    //blockChainListView.model.swapItemsAt(from_index, to_index)// <- not a function
    //blockChainListView.model.beginMoveRows(blockChainListView.model, from_index, from_index, blockChainListView.model, to_index);
    //debugger:
    //QML_Debugger.listEverything(blockChainListView.model)
    console.log("Swapping blockchain list indexes:", from_index, to_index)
  }

  //----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 3)
    height: dashViewRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      opacity: 0.4
      x: parent.width - width
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("close")
			onClicked: {
        // remove connections
        api.chainsChanged.disconnect(dashViewRoot.blockChainChanged)
        pageRoot.popDash()
      }
		}

    Text {
      text: qsTr("Manage assets")
      font.pixelSize: DawgsStyle.fsize_title
      font.weight: Font.Bold
      color: DawgsStyle.font_color
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
    }
    //----------------------
    // Toggle on/off testNet
    ButtonGroup { 
      id: listOptions
      exclusive: false
    }
    Dawgs_RadioButton {
      id: enableBlockchainButton
      checked: dashViewRoot.show_testnet_chains
      width: parent.width
      onlyBox: false
      text: qsTr("Display Testnet.")
      accentText: qsTr("Toggle display between live and test nets")
      onToggled: {
        dashViewRoot.populateBlockChains(!dashViewRoot.show_testnet_chains)
        //console.log("Using test blockchain net?", dashViewRoot.show_testnet_chains)
      }
      ButtonGroup.group: listOptions
      anchors.horizontalCenter: parent.horizontalCenter
    }
    //----------------------
    // Change sync (blockchain enable/disable) and app Asset list display.
		Row {
			id: managementTypeTabContextButtons
			height: tabHideShow.height
			spacing: 0
			anchors.horizontalCenter: parent.horizontalCenter
			// Set Tab view options:
			Dawgs_TabGroupButton {
				id: tabHideShow
				text: qsTr("Hide/Show") // also enable/disables chain sync
        textPadding: 56
				checked: true
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
			Dawgs_TabGroupButton {
				id: tabOrder
				text: qsTr("Order")
        textPadding: 38
				ButtonGroup.group: tabDisplayBeltButtonGroup
			}
		}
		// Manage display updates depending on selection context Tab for viewing associated data.
		ButtonGroup { 
      id: tabDisplayBeltButtonGroup
      exclusive: true
      property var selected_item: tabHideShow.text
      property int managementMode: 0 // [0 Hide/Show, 1 Order]

      onClicked: {
        if (selected_item !== button.text) {
					selected_item = button.text
          // when tab option has changed, update quick select list model
          switch (selected_item) {
            case "Hide/Show":
              managementMode = 0
              break;
            case "Order":
              managementMode = 1
              break;
            default:
              managementMode = -1
          }
        }
      }
    }

    //-----------------------------------------------------------------------------
    // Display list of available block chaings to choose from.
    Component {
      id: blockListDelegate
      Rectangle {
        id: deligateRoot
        width: body.width
        height: 70
        color: "transparent"
        //debugger:
        //Component.onCompleted: {
        //  console.log("Blockchain management list model:", model)
        //  QML_Debugger.listEverything(model)
        //}
        // Create Dragable item:
        Rectangle {
          id: dragableRectDeligate
          width: body.width
          height: deligateRoot.height
          color: (model.enabled ? DawgsStyle.aa_selected_bg : "transparent")
          radius: 12
          border.color: (model.enabled ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol)
          border.width: 1
          property int dragItemIndex: index

          // Create deligate body:
          Row {
            width: parent.width
            height: parent.height
            leftPadding: 8
            spacing: DawgsStyle.horizontalMargin
            // Display blockchain icon:
            MatterFi_BlockChainIcon {
              id: blockchainIconImage
              height: parent.height - 16
              width: blockchainIconImage.height
              anchors.verticalCenter: parent.verticalCenter

              Component.onCompleted: {
                // has to wait until model is ready to get data from it
                blockchainIconImage.notaryType = model.type
                blockchainIconImage.setIconFile()
              }
            }

            // Display blockchain abbreviated and full name
            Column {
              width: parent.width - switchOutlineRect.width - blockchainIconImage.width - 42
              spacing: 2
              anchors.verticalCenter: parent.verticalCenter
              // Abbreviation
              Text {
                id: typeText
                text: model.type
                width: parent.width
                color: DawgsStyle.font_color
                font.pixelSize: DawgsStyle.fsize_normal
                font.weight: Font.Bold
              }
              // Fullname
              Text {
                id: nameText
                text: model.name
                width: parent.width
                color: DawgsStyle.text_descrip
                font.pixelSize: DawgsStyle.fsize_small
              }
            }
            // Crate enable/disable [Hide/Show] interaction component
            Rectangle {
              id: switchOutlineRect
              height: parent.height * 0.45
              width: switchOutlineRect.height * 1.7
              implicitHeight: parent.height * 0.45
              implicitWidth: implicitHeight * 2
              radius: height / 2
              color: (model.enabled ? DawgsStyle.aa_selected_bg : DawgsStyle.page_bg)
              visible: (tabDisplayBeltButtonGroup.managementMode === 0 && dashViewRoot.performing_work === false)
              border.color: (model.enabled ? DawgsStyle.aa_selected_ol : DawgsStyle.aa_norm_ol)
              border.width: 1
              anchors.verticalCenter: parent.verticalCenter

              // switch marker
              Rectangle {
                id: markerDeligate
                height: switchOutlineRect.height - 8
                width: markerDeligate.height
                color: parent.border.color
                radius: height / 2
                x: 4
                anchors.verticalCenter: parent.verticalCenter
              }
              // Change cursor to pointing action as configured by root os system.
              MouseArea {
                anchors.fill: parent
                focus: true
                enabled: parent.visible
                hoverEnabled: enabled
                //acceptedButtons: Qt.NoButton
                cursorShape: (containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor)
                onClicked: {
                  if (dashViewRoot.performing_work) {
                    console.log("Blockchain is already being changed.")
                    return
                  }
                  // animate untill responce from action
                  dashViewRoot.performing_work = true
                  // TODO: OT can crash sometimes here with "bus error: 10"
                  // this happens when enabling/disabling too quickly? This can also
                  // be an error related to accessing a locked Mutex.
                  if (model.enabled) {
                    dashViewRoot.blockChainList_OT.chainDisabled.connect(blockchianWorkingRect.blockchainWasDisabled)
                    dashViewRoot.blockChainList_OT.disableChain(model.type)
                  } else {
                    dashViewRoot.blockChainList_OT.chainEnabled.connect(blockchianWorkingRect.blockchainWasEnabled)
                    dashViewRoot.blockChainList_OT.enableChain(model.type)
                  }
                  // debugger:
                  console.log("Changing blockchain enabled:", model.type, model.name, model.enabled)
                }
                onPressed: { }
                onReleased: { }
                onEntered: { }
                onExited: { }
              }
              // Animation state:
              states: [
                State {
                  when: model.enabled
                  PropertyChanges {
                    target: markerDeligate
                    x: switchOutlineRect.width - markerDeligate.width - 4
                  }
                }
              ]
            }
            // change in sync status working animation
            Rectangle {
              id: blockchianWorkingRect
              height: parent.height
              width: height
              color: "transparent"
              visible: (dashViewRoot.performing_work)
              anchors.verticalCenter: parent.verticalCenter
              // Signal watching for when a chain was enabled:
              function blockchainWasEnabled(chain_int) {
                if (model.type === chain_int) {
                  dashViewRoot.blockChainList_OT.chainEnabled.disconnect(blockchianWorkingRect.blockchainWasEnabled)
                  workingchangeTimeoutTimer.restart()
                  //debugger:
                  console.log("Block Chain Chooser: blockchain enabled:", chain_int)
                }
              }
              // Signal watching for when a chain was disabled:
              function blockchainWasDisabled(chain_int) {
                if (model.type === chain_int) {
                  dashViewRoot.blockChainList_OT.chainDisabled.disconnect(blockchianWorkingRect.blockchainWasDisabled)
                  workingchangeTimeoutTimer.restart()
                  //debugger:
                  console.log("Block Chain Chooser: blockchain disabled:", chain_int)
                }
              }
              // disconnect the work signals if component is disposed while waiting attached to a signal
              Component.onDestruction: {
                if (dashViewRoot.blockChainList_OT !== undefined) {
                  dashViewRoot.blockChainList_OT.chainEnabled.disconnect(blockchianWorkingRect.blockchainWasEnabled)
                  dashViewRoot.blockChainList_OT.chainDisabled.disconnect(blockchianWorkingRect.blockchainWasDisabled)
                }
              }
              // Prevent further blockchain changes and display busy working indication
              BusyIndicator {
                id: awaitingWorkBusyIndicator
                visible: (parent.visible)
                running: visible
                scale: 0.8
                palette.dark: DawgsStyle.page_bg
                anchors.centerIn: parent
              }
            }
          }
          //----------------------
          // Draggable animation states:
          states: [
            State {
              when: dragableRectDeligate.Drag.active
              ParentChange {
                target: dragableRectDeligate
                parent: blockChainListView
              }
              AnchorChanges {
                target: dragableRectDeligate
                anchors.horizontalCenter: undefined
                anchors.verticalCenter: undefined
              }
            }
          ]
          // Make Rect container Draggable interactive:
          MouseArea {
            id: mouseArea
            enabled: (!switchOutlineRect.visible)
            anchors.fill: parent
            drag.target: dragableRectDeligate
            drag.onActiveChanged: {
              if (mouseArea.drag.active) {
                blockChainListView.dragItemIndex = index
              }
            }
          }
          // Drag component upkeep:
          Drag.active: (tabDisplayBeltButtonGroup.managementMode === 1 && mouseArea.drag.active)
          Drag.hotSpot.x: dragableRectDeligate.width / 2
          Drag.hotSpot.y: dragableRectDeligate.height / 2
          Drag.onDragFinished: {
            // drag.source.dragItemIndex
            console.log("Drag over:", drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
            dashViewRoot.swapChainIndexes(drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
          }
        }
        // Create stationary index drop draggable recieving zone.
        Rectangle {
          width: parent.width
          height: parent.height
          anchors.fill: parent
          color: "transparent"

          DropArea {
            enabled: (blockChainListView.dragItemIndex !== dragableRectDeligate.dragItemIndex)
            width: parent.width
            height: parent.height 
            anchors.fill: parent
            // [drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex]
            onEntered: {
              // debugger:
              console.log("Swap indexes with:", drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
              dashViewRoot.swapChainIndexes(drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
            }
            /*
            onDropped: {
              console.log("Drag over:", drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
              dashViewRoot.swapChainIndexes(drag.source.dragItemIndex, dragableRectDeligate.dragItemIndex)
            }
            */
          }
        }
        // add in a time buffer between acceptible blockchain sync setting changes
        Timer {
          id: workingchangeTimeoutTimer
          interval: 600
          running: false
          onTriggered: {
            dashViewRoot.performing_work = false
          }
        }
      }//end 'dragableRectDeligate'
    }//end 'blockListDelegate'

    //----------------------
    // show the blockchains list:
    ListView {
      id: blockChainListView
      model: dashViewRoot.blockChainList_OT
      delegate: blockListDelegate
      width: parent.width
      height: (body.height - 224)
      spacing: 10
      clip: true
      property int dragItemIndex: -1

      anchors {
        topMargin: 16;
        horizontalCenter: parent.horizontalCenter;
      }

      //----------------------
      // Transition Animations:
      addDisplaced: Transition {
        NumberAnimation {properties: "x,y"; duration: 120}
      }

      moveDisplaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 120 }
      }

      remove: Transition {
        NumberAnimation { properties: "x,y"; duration: 120 }
        NumberAnimation { properties: "opacity"; duration: 120 }
      }

      removeDisplaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 120 }
      }

      displaced: Transition {
        NumberAnimation {properties: "x,y"; duration: 120}
      }

    }//end 'blockChainListView'

  }//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'