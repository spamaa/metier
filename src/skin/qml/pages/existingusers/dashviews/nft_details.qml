import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.1

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
// "qrc:/dashviews/nft_details.qml"
// Displays details about a single NFT.
//-----------------------------------------------------------------------------
Page {
	id: dashViewRoot
	width: dashStackView.width
	height: dashStackView.height
	title: qsTr("Dashboard View NFT Details.")
	objectName: "dashboard_nft_details"
	background: null //Qt.transparent

  property var nftModel: undefined
  property bool is_profile_pic: false

	//----------------------
  Rectangle {
    id: bgRect
    width: parent.width
    height: parent.height
    color: DawgsStyle.norm_bg
  }

  //----------------------
  // Hand off collection data:
  Component.onCompleted: {
    dashViewRoot.nftModel = pageRoot.passAlongData
    pageRoot.clear_passAlong()
    // populate the nft grid
    //nftsRepeater.model = dashViewRoot.nftModel.attributes
    //debugger:
    //console.log("NFT modelData populated:", dashViewRoot.nftCollectionModel)
    //QML_Debugger.listEverything(dashViewRoot.nftCollectionModel)
  }

  //----------------------
  // Set selection as profile picture:
  function setProfilePicture() {

    //TODO: additional claim access in OT profile model for current Identity.
    console.log("WIP: Changing profile picture,", dashViewRoot.nftModel.image)

  }

  //-----------------------------------------------------------------------------
  // page contents displayed:
  Column {
    id: body
    width: dashViewRoot.width //- (DawgsStyle.horizontalMargin * 4)
    spacing: 0
    anchors.horizontalCenter: parent.horizontalCenter

    //----------------------
    Dawgs_Button {
			id: navBackButton
			width: 52
      x: DawgsStyle.horizontalMargin
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

    //-----------------------------------------------------------------------------
    Rectangle {
      id: scrollRect
      color: "transparent"
      width: dashViewRoot.width
      height: dashViewRoot.height - navBackButton.height - parent.spacing - DawgsStyle.verticalMargin
      clip: true

      ScrollView {
        id: detailsBioScrollView
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: scrollBody.height
        bottomPadding: (DawgsStyle.verticalMargin)
        anchors.horizontalCenter: parent.horizontalCenter

        // scroll bars
        ScrollBar.vertical.interactive: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.contentItem: Rectangle {
          implicitWidth: 8
          implicitHeight: 100
          radius: (width / 2)
          color: DawgsStyle.page_bg
        }
        ScrollBar.vertical.x: parent.width - DawgsStyle.horizontalMargin
        ScrollBar.horizontal.interactive: false
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        
        // Main Scroll viewing body:
        Column {
          id: scrollBody
          width: 320 //body.width
          topPadding: DawgsStyle.verticalMargin / 2
          spacing: DawgsStyle.verticalMargin
          anchors.horizontalCenter: parent.horizontalCenter

          //----------------------
          // NFT name:
          Text {
            id: nftNameText
            text: dashViewRoot.nftModel.title
            font.pixelSize: DawgsStyle.fsize_title
            font.weight: Font.Bold
            font.family: Fonts.font_HindVadodara_bold
            color: DawgsStyle.font_color
            verticalAlignment: Text.AlignVCenter
          }

          // NFT image:
          Rectangle {
            id: nftImageBGrect
            width: parent.width
            height: width
            clip: true
            color: "transparent"
            radius: 12
            border.color: (loadingImageBusy.visible ? DawgsStyle.aa_norm_ol : "transparent");
            border.width: 1

            Image {
              id: nftImage
              source: dashViewRoot.nftModel.image
              asynchronous: true
              sourceSize.width: parent.width
              sourceSize.height: parent.height
              fillMode: Image.PreserveAspectFit
              anchors.centerIn: parent
              // round image corners
              layer.enabled: true
              layer.effect: OpacityMask { // **Requires** QtGraphicalEffects
                maskSource: Rectangle {
                  width: nftImageBGrect.width
                  height: nftImageBGrect.height
                  radius: 12
                }
              }
            }//end 'nftImage'
            
            // display loading indicator
            BusyIndicator {
              id: loadingImageBusy
              scale: 1.0
              visible: (nftImage.progress < 1.0)
              anchors.centerIn: parent
            }
          }

          //----------------------
          // Bio:
          Text {
            id: bioText
            text: (dashViewRoot.nftModel.description !== undefined ? dashViewRoot.nftModel.description : "")
            visible: (dashViewRoot.nftModel.description !== undefined)
            color: DawgsStyle.font_color
            opacity: 0.4
            width: parent.width
            wrapMode: Text.WordWrap
            bottomPadding: DawgsStyle.verticalMargin
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_accent
            font.weight: Font.DemiBold
            font.family: Fonts.font_HindVadodara_bold
          }

          //----------------------
          // Buttons
          Column {
            id: interactionButtonsColumn
            width: parent.width
            spacing: 8

            Button {
              width: parent.width
              height: 48
              onClicked: {
                console.log("Send nft action, WIP.")
              }
              // Draw button Text:
              contentItem: Text {
                text: qsTr("Send")
                color: DawgsStyle.font_color
                font.pixelSize: DawgsStyle.fsize_button
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
              }
              // Draw Button style:
              background: Rectangle {
                color: (parent.hovered ? DawgsStyle.buta_selected : DawgsStyle.buta_active)
                border.color: DawgsStyle.buta_active
                border.width: 1
                radius: 8
              }
              // Change cursor to pointing
              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
              }
            }

            //----------------------
            // Change profile picture:
            Button {
              width: parent.width
              height: 48
              onClicked: {
                console.log("Setting nft as profile image.")
                dashViewRoot.is_profile_pic = true
                dashViewRoot.setProfilePicture()
              }
              enabled: (!dashViewRoot.is_profile_pic)
              // Draw button Text:
              contentItem: Text {
                text: (dashViewRoot.is_profile_pic ? qsTr("This is your profile pic") : qsTr("Use as profile pic") );
                color: (dashViewRoot.is_profile_pic ? DawgsStyle.buta_selected : DawgsStyle.font_color)
                font.pixelSize: DawgsStyle.fsize_button
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
              }
              // Draw Button style:
              background: Rectangle {
                color: (dashViewRoot.is_profile_pic ? DawgsStyle.aa_selected_bg :
                  (parent.hovered ? DawgsStyle.aa_selected_bg : "transparent") );
                border.color: (dashViewRoot.is_profile_pic ? DawgsStyle.buta_selected : DawgsStyle.aa_selected_ol );
                border.width: 1
                radius: 8
              }
              // Change cursor to pointing
              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: (parent.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor)
              }
            }
          }//end 'interactionButtonsColumn'

          //----------------------
          // Traits:
          Text {
            id: traitsText
            text: qsTr("Traits")
            visible: attributeRow.visible
            color: DawgsStyle.font_color
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_alert
            font.weight: Font.Bold
            font.family: Fonts.font_HindVadodara_bold
          }

          // Display all the traits:
          // { trait_type, value }
          Flow {
            id: attributeRow
            width: scrollBody.width
            spacing: 8
            visible: (dashViewRoot.nftModel.attributes !== undefined)

            Repeater {
              id: attributesRepeater
              model: (dashViewRoot.nftModel.attributes !== undefined ? dashViewRoot.nftModel.attributes : [])

              delegate: Rectangle {
                id: traitRect
                width: traitName.width
                height: traitName.height
                color: "transparent"
                radius: (height / 2)
                border.color: DawgsStyle.buta_active
                border.width: 1

                Text {
                  id: traitName
                  text: modelData.value
                  padding: 4
                  leftPadding: padding * 2
                  rightPadding: padding * 2
                  color: DawgsStyle.font_color
                  font.pixelSize: DawgsStyle.fsize_accent
                  font.weight: Font.DemiBold
                  font.family: Fonts.font_HindVadodara_bold
                }
              }
            }
          }//end 'attributeRow'

          //----------------------
          // Backstory:
          Text {
            id: backstoryTitleText
            text: qsTr("Backstory")
            visible: backstoryText.visible
            color: DawgsStyle.font_color
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_alert
            font.weight: Font.Bold
            font.family: Fonts.font_HindVadodara_bold
          }

          Text {
            id: backstoryText
            text: (dashViewRoot.nftModel.story !== undefined ? dashViewRoot.nftModel.story : "")
            color: DawgsStyle.font_color
            opacity: 0.4
            width: parent.width
            wrapMode: Text.WordWrap
            visible: (dashViewRoot.nftModel.story !== undefined)
            bottomPadding: DawgsStyle.verticalMargin
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_accent
            font.weight: Font.DemiBold
            font.family: Fonts.font_HindVadodara_bold
          }

          //----------------------
          // Origin:
          Text {
            id: originTitleText
            text: qsTr("Origin")
            visible: originText.visible
            color: DawgsStyle.font_color
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_alert
            font.weight: Font.Bold
            font.family: Fonts.font_HindVadodara_bold
          }

          Text {
            id: originText
            text: (dashViewRoot.nftModel.origin !== undefined ? dashViewRoot.nftModel.origin : "")
            color: DawgsStyle.font_color
            opacity: 0.4
            width: parent.width
            wrapMode: Text.WordWrap
            visible: (dashViewRoot.nftModel.origin !== undefined)
            bottomPadding: DawgsStyle.verticalMargin
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_accent
            font.weight: Font.DemiBold
            font.family: Fonts.font_HindVadodara_bold
          }

          //----------------------
          // Location:
          Text {
            id: locationTitleText
            text: qsTr("Location")
            visible: locationText.visible
            color: DawgsStyle.font_color
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_alert
            font.weight: Font.Bold
            font.family: Fonts.font_HindVadodara_bold
          }

          Text {
            id: locationText
            text: (dashViewRoot.nftModel.location !== undefined ? dashViewRoot.nftModel.location : "")
            color: DawgsStyle.font_color
            opacity: 0.4
            width: parent.width
            wrapMode: Text.WordWrap
            visible: (dashViewRoot.nftModel.location !== undefined)
            bottomPadding: DawgsStyle.verticalMargin
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: DawgsStyle.fsize_accent
            font.weight: Font.DemiBold
            font.family: Fonts.font_HindVadodara_bold
          }

        }//end 'scrollBody'
      }//end 'detailsBioScrollView'
    }//end 'scrollRect'

	}//end 'body'
//-----------------------------------------------------------------------------
}//end 'dashViewRoot'