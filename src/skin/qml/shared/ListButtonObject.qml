import QtQuick 2.15
import QtQuick.Controls.Universal 2.12


import "qrc:/styling"

//-----------------------------------------------------------------------------
// Creates a display of an icon next to a Lable text over top a desctiption.
// Its a way to present a list of items with additional description elements avaliable.
Item {
    id: widget
    height: 36

    property string txtValue: "Large Top"    // displays a large text value
    property string txtLable: "Small Bottom" // displays a small detail value
    property string svgiconName: ""          // displays a svg icon to left of text
    property bool iconIsButton: true         // the icon can be clicked on as well as the list item

    property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
    property color accentfontColor: rootAppPage.currentStyle > 0 ? CustStyle.dm_text_accent : CustStyle.lm_text_accent

    property int bottomPadding: 0
    property int topPadding: 0

    signal action() // emits was clicked/interacted with

    //-----------------------------------------------------------------------------
    // main 'body' display
    Row {
        id: body
        height: widget.height
        width: parent.width
        leftPadding: 16
        anchors.fill: parent
        bottomPadding: widget.bottomPadding
        topPadding: widget.topPadding

        // make link action button
        // To Do: update to use FontIcon insead, issues with windows and ColorOverlay for SVG images.
        SvgIconButton {
            id: paymentLinkButton
            iconFile: widget.svgiconName
            isFAicon_solid: true
            iconSize: 22
            color: widget.fontColor
            anchors.verticalCenter: parent.verticalCenter
            isEnabled: widget.iconIsButton
            onAction: widget.iconIsButton ? widget.action() : {}
        }
        // Show payment code
        Column {
            leftPadding: 32
            height: widget.height
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: paymentlinkText
                text: widget.txtValue
                color: widget.fontColor
                font.pixelSize: CustStyle.fsize_button
                smooth: true
            }

            Text {
                text: widget.txtLable
                topPadding: 4
                color: widget.accentfontColor
                font.pixelSize: CustStyle.fsize_lable
                smooth: true
            }
        }

    }//end 'body'
}//end 'widget'
