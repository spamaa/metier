import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
//import QtQuick.Layouts 1.1

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Dashboard_Collectibles.qml
// Used for displaying a user's SpaceDawgs collectibles/NFTs
/*

*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

  property bool hasNFTs: false
  property var nftData: ({})

  //-----------------------------------------------------------------------------
  Component.onCompleted: {
    contextRoot.local_mockData()
  }

  // Create mock data object for view:
  function local_mockData() {
    var fileDir = "qrc:/mockdata/nfts"
    var rawFile = new XMLHttpRequest()
    rawFile.open("GET", fileDir)
    // async file read:
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState == XMLHttpRequest.DONE) {
        contextRoot.nftData = JSON.parse(rawFile.responseText)
        nftsRepeater.model = contextRoot.nftData
        contextRoot.hasNFTs = true
        // debugger:
        //console.log("Laoded NFT mock data:")
        //QML_Debugger.listProperties(contextRoot.nftData)
				return true
      }
    }
    // load file error net
    rawFile.onerror = function () {
      console.log("Error: could not load NFT mock data.")
			return false
    }
    rawFile.send(null)
  }

  // Open the collections selection page:
  function selectedCollectionIndex(model) {
    //debugger:
    //console.log("Clicked on nft group")
    // navigate to the group's nft selection page, bring the nft colection data with
    pageRoot.passAlongData = model.modelData //contextRoot.nftData[index]
    pageRoot.pushDash("dashboard_nft_collection")
  }

  //-----------------------------------------------------------------------------
  Column {
    id: body
    width: contextRoot.width - (DawgsStyle.horizontalMargin * 2)
    height: contextRoot.height
    spacing: DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Rectangle {
      id: gridBGrect
      width: 338 //parent.width
      height: parent.height - footerBody.height - 92
      color: "transparent"
      visible: (contextRoot.hasNFTs)
      anchors.horizontalCenter: parent.horizontalCenter
      
      // Create NFT groups selection Gird.
      Grid { //GridLayout
        id: nftGroupSelectionGrid
        spacing: 8
        padding: 0
        topPadding: 4
        columns: 3
        anchors.fill: parent
        anchors.centerIn: parent

        Repeater {
          id: nftsRepeater
          model: []
          // what the selection option looks like:
          Button {
            id: bgSelectionGridDeligate
            width: 107
            height: 200
            padding: 2
            opacity: 0.0 // grid 'add' transition
            enabled: (gridBGrect.visible)
            onClicked: contextRoot.selectedCollectionIndex(model)

            //Layout.preferredWidth: width
            //Layout.preferredHeight: height
            //Layout.alignment: Qt.AlignCenter

            contentItem: Rectangle {
              color: "transparent"

              Rectangle {
                id: countOwnedRect
                width: countText.height + 1
                height: width 
                radius: (width / 2)
                color: DawgsStyle.buta_active
                anchors {
                  right: parent.right;
                  top: parent.top;
                  topMargin: 2;
                }

                Text {
                  id: countText
                  text: modelData.owned
                  color: DawgsStyle.font_color
                  font.pixelSize: DawgsStyle.fsize_accent
                  font.family: Fonts.font_HindVadodara_bold
                  font.weight: Font.Bold
                  anchors.centerIn: parent
                }
              }

              Text {
                id: nftNameText
                text: modelData.title
                color: DawgsStyle.font_color
                font.pixelSize: DawgsStyle.fsize_accent
                font.family: Fonts.font_HindVadodara_bold
                font.weight: Font.Bold
                anchors {
                  bottom: parent.bottom;
                  bottomMargin: (DawgsStyle.verticalMargin / 3);
                  leftMargin: 8;
                }
              }
            }
            // BG
            background: Rectangle {
              id: collectionBGrect
              //clip: true
              color: (hovered ? DawgsStyle.aa_hovered_bg : "transparent");
              radius: 12
              clip: true
              border.color: (hovered ? DawgsStyle.buta_selected : DawgsStyle.aa_norm_ol);
              border.width: 1

              // add drop shadow effect:
              /*
              Rectangle {
                anchors.fill: parent
                anchors.centerIn: parent
                radius: 12

                DropShadow {
                  horizontalOffset: 3
                  verticalOffset: 3
                  radius: 8.0
                  samples: 2
                  color: "#80000000"
                  source: parent
                  anchors.fill: parent
                }
              }
              */

              Image {
                id: collectionCoverImg
                source: modelData.coverImage
                smooth: true
                asynchronous: true
                opacity: 0.3
                width: imageCornersMask.width
                height: imageCornersMask.height
                sourceSize.width: (bgSelectionGridDeligate.width * 1.80)
                sourceSize.height: bgSelectionGridDeligate.height
                fillMode: Image.PreserveAspectCrop
                anchors.centerIn: parent
                // round image corners
                layer.enabled: true
                layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
                  maskSource: imageCornersMask
                }
              }//end 'collectionCoverImg'
              Rectangle {
                id: imageCornersMask
                implicitWidth: bgSelectionGridDeligate.width
                implicitHeight: bgSelectionGridDeligate.height
                visible: false
                radius: 12
                anchors.centerIn: parent
              }
              
              // display loading indicator
              BusyIndicator {
                id: loadingImageBusy
                scale: 1.0
                visible: (collectionCoverImg.progress < 1.0)
                anchors.centerIn: parent
              }
            }

            // Change cursor to pointing action as configured by root os system.
            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.NoButton
              cursorShape: (bgSelectionGridDeligate.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
            }
            /*
            Component.onCompleted: {
              //debugger:
              console.log("Collectibles NFT data loaded:", index, modelData)
              QML_Debugger.listEverything(modelData)
            }
            */
          }//end 'bgSelectionGridDeligate'
        }//end 'nftsRepeater'

        add: Transition {
          id: addTransition
          SequentialAnimation {
            // prep
            NumberAnimation { properties: "opacity"; from: 1.0; to: 0.0; duration: 0 }
            PauseAnimation {
              duration: (addTransition.ViewTransition.index * 280) + 180
            }
            // apear
            ParallelAnimation {
              NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0; 
                duration: (addTransition.ViewTransition.index * 300) + 200;
                easing.type: Easing.InQuad
              }
              NumberAnimation {
                properties: "y";
                from: addTransition.ViewTransition.destination.y + 10;
                to: addTransition.ViewTransition.destination.y;
                duration: (addTransition.ViewTransition.index * 300) + 100;
                easing.type: Easing.InOutQuad
              }
            }
          }
        }

        onPositioningComplete: {
          //console.log("Collectibles ready, NFTs.")
          footerAppearnceAnimation.running = true
        }

      }//end 'nftGroupSelectionGrid'
    }//end 'gridBGrect'
      
    //-----------------------------------------------------------------------------
    // Footer:
    Rectangle {
      id: footerBody
      width: parent.width
      height: nftFooterColumn.height + DawgsStyle.verticalMargin
      color: DawgsStyle.norm_bg
      radius: 12
      anchors.horizontalCenter: parent.horizontalCenter

      Column {
        id: nftFooterColumn
        width: parent.width
        height: 96
        spacing: DawgsStyle.verticalMargin
        anchors {
          horizontalCenter: parent.horizontalCenter;
        }

        Dawgs_CenteredTitle {
          fontPixelSize: DawgsStyle.fsize_accent
          textTitle: (contextRoot.hasNFTs ? qsTr("Want to protect more collectibles?") :
            qsTr("No assets found") );
        }

        MatterFi_RoundButton {
          text: qsTr("Add nfts")
          anchors.horizontalCenter: parent.horizontalCenter
          border_color: DawgsStyle.buta_active
          onClicked: {
            console.log("WIP designs. would have shown manage assets.")
          }
        }
      }

      // Apearance animation:
      ParallelAnimation {
        id: footerAppearnceAnimation
        running: false
        NumberAnimation { target: footerBody; property: "y"; 
          from: footerBody.y; to: (gridBGrect.y + gridBGrect.height) + (DawgsStyle.verticalMargin * 2)
          duration: 600; easing.type: Easing.OutBack 
        }
        NumberAnimation { target: footerBody; property: "opacity"; 
          from: 0.0; to: 1.0; duration: 600 
        }
      }
    }//end 'footerBody'
  
  //----------------------
  }//end 'body'
//-----------------------------------------------------------------------------
}//end 'contextRoot'