import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/nft_collection.qml"
// Displays a list of grouped NFTs for navigation into detail pages.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard View NFT Collection.")
	objectName: "dashboard_nft_collection"
	background: null //Qt.transparent
  
  property var nftCollectionModel: undefined

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  // Called when an NFT from the Grid is selected:
  function nftFromGroupSelected(index, model) {
    //debugger:
    //console.log("Clicked on nft from group", index, model)
    //QML_Debugger.listEverything(model)
    // navigate to display full details about selcted NFT from group
    pageRoot.passAlongData = model
    pageRoot.pushDash("dashboard_nft_details")
  }

  //----------------------
  // Hand off collection data:
  Component.onCompleted: {
    dashViewRoot.nftCollectionModel = pageRoot.passAlongData
    pageRoot.clear_passAlong()
    // populate the nft grid
    nftsRepeater.model = dashViewRoot.nftCollectionModel.items
    //debugger:
    //console.log("NFT collection populated:", dashViewRoot.nftCollectionModel)
    //QML_Debugger.listEverything(dashViewRoot.nftCollectionModel)
  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: header
    width: dashViewRoot.width - (DawgsStyle.horizontalMargin * 2)
    spacing: 4 //DawgsStyle.verticalMargin
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      opacity: 0.4
			justText: true
			iconLeft: true
      manualWidth: true
			fontIcon: IconIndex.fa_chevron_left
			fontFamily: Fonts.icons_solid
      buttonType: "Plain"
			displayText: qsTr("back")
			onClicked: pageRoot.popDash()
		}

    Column {
      id: titleColumn
      width: parent.width
      spacing: 4
      topPadding: 6

      Text {
        id: collectionNameText
        height: font.pixelSize
        text: dashViewRoot.nftCollectionModel.title
        font.pixelSize: DawgsStyle.fsize_title
        font.weight: Font.DemiBold
        font.family: Fonts.font_HindVadodara_bold
        bottomPadding: DawgsStyle.verticalMargin
        color: DawgsStyle.font_color
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
      }

      Text {
        id: collectionCountText
        text: dashViewRoot.nftCollectionModel.owned + qsTr(" in this collection")
        height: font.pixelSize
        font.family: Fonts.font_HindVadodara
        font.pixelSize: DawgsStyle.fsize_small
        font.weight: Font.DemiBold
        bottomPadding: DawgsStyle.verticalMargin
        color: DawgsStyle.font_color
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
      }
    }
	}//end 'header'

  //----------------------
  Rectangle {
    id: gridBGrect
    width: 338 //parent.width
    height: parent.height
    color: "transparent"
    anchors {
      horizontalCenter: parent.horizontalCenter;
      topMargin: (DawgsStyle.verticalMargin * 1.5);
      top: header.bottom;
    }
    
    // Create NFT selection Gird.
    Grid { //GridLayout
      id: nftSelectionGrid
      spacing: 8
      padding: 0
      columns: 2
      anchors.fill: parent
      anchors.centerIn: parent

      Repeater {
        id: nftsRepeater
        model: []
        // what the selection option looks like:
        Button {
          id: bgSelectionGridDeligate
          width: 165
          height: 200
          padding: 2
          enabled: (gridBGrect.visible)
          onClicked: dashViewRoot.nftFromGroupSelected(index, modelData)

          contentItem: Rectangle {
            color: "transparent"

            Text {
              id: nftNameText
              text: modelData.title
              color: DawgsStyle.font_color
              width: (parent.width * 0.90)
              wrapMode: Text.Wrap
              elide: Text.ElideRight
              lineHeight: 0.65
              font.pixelSize: DawgsStyle.fsize_accent
              font.family: Fonts.font_HindVadodara_bold
              font.weight: Font.Black
              anchors {
                bottom: parent.bottom;
                bottomMargin: DawgsStyle.verticalMargin;
                leftMargin: 10;
              }
            }
          }
          // BG
          background: Rectangle {
            id: collectionBGrect
            clip: true
            color: (hovered ? DawgsStyle.aa_hovered_bg : "transparent");
            radius: 12
            border.color: (hovered ? DawgsStyle.buta_selected : "transparent");
            border.width: 1

            Image {
              id: collectionCoverImg
              source: modelData.image
              smooth: true
              asynchronous: true
              opacity: 0.3
              width: imageMaskRect.width
              height: imageMaskRect.height
              sourceSize.width: (parent.width * 1.2)
              sourceSize.height: parent.height
              fillMode: Image.PreserveAspectCrop
              anchors.centerIn: parent
              // round image corners
              layer.enabled: true
              layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
                maskSource: imageMaskRect
              }

              Rectangle {
                id: imageMaskRect
                width: collectionBGrect.width
                height: collectionBGrect.height
                radius: 12
                visible: false
                anchors.centerIn: parent
              }
            }//end 'collectionCoverImg'
            
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
        }//end 'bgSelectionGridDeligate'
      }//end 'nftsRepeater'

      //----------------------
      // Transition on new item:
      add: Transition {
        id: addTransition
        SequentialAnimation {
          // prep
          NumberAnimation { properties: "opacity"; from: 1.0; to: 0.0; duration: 0 }
          PauseAnimation {
            duration: (addTransition.ViewTransition.index * 220) + 180
          }
          // apear
          ParallelAnimation {
            NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0; 
              duration: (addTransition.ViewTransition.index * 180) + 200;
              easing.type: Easing.InQuad
            }
            NumberAnimation {
              properties: "y";
              from: addTransition.ViewTransition.destination.y + 10;
              to: addTransition.ViewTransition.destination.y;
              duration: (addTransition.ViewTransition.index * 160) + 100;
              easing.type: Easing.InOutQuad
            }
          }
        }
      }
    }//end 'nftSelectionGrid'
  }//end 'gridBGrect'

//-----------------------------------------------------------------------------
}//end 'dashViewRoot'