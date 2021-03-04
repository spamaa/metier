import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Display delegate for ContactList.
// Roles { "id" "section", "image", "name" }
// Functions:
//-----------------------------------------------------------------------------
Item {
    id: widget

    property var listIndex: 0
    property var contact_data: ({})
    property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
    // called on click interactions
    signal action()

    //-----------------------------------------------------------------------------
    // Filtering the display:  Qt::CaseInsensitive
    property var filterString: ""
    visible: (filterString.length === 0 || (
        contact_data !== undefined && (
            contact_data.name.indexOf(filterString) !== -1 ||
            contact_data.id.indexOf(filterString) !== -1
        )
    ));
    property bool isEnabled: (widget.visible)
    height: (isEnabled ? 40 : 0)

    //-----------------------------------------------------------------------------
    // Run soon as page is ready.
    /*
    Component.onCompleted: {
        console.log("Contact List entry:", widget.contact_data)
        QML_Debugger.listEverything(widget.contact_data)
    }
    */

    //-----------------------------------------------------------------------------
    Rectangle {
        id: body
        scale: shrunk ? CustStyle.but_shrink : 1.0
        width: parent.width
        height: (widget.visible ? parent.height : 0)
        color: "transparent"
        property bool shrunk: false

        Row {
            width: body.width
            height: body.height
            leftPadding: 4

            MatterFi_Avatar {
                id: avatarImage
                width: parent.height
                height: width
                //avatarUrl: contact_data.image
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: nameText
                text: (widget.listIndex === 0 ? (contact_data.name + " (myself)") : contact_data.name)
                color: widget.fontColor
                leftPadding: 12
                font.pixelSize: CustStyle.fsize_normal
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        //-----------------------------------------------------------------------------
        // Mark area around body as Input area.
        MouseArea {
            id: inputArea
            width: body.width
            height: body.height
            hoverEnabled: false
            enabled: widget.isEnabled

            onClicked: {
                body.shrunk = true
                animationTimer.restart()
            }

            onPressed: {
                //body.color = widget.colorPress
                //body.shrunk = true
            }
            onReleased: {
                //body.color = widget.colorNormal
                //body.shrunk = false
            }
            onEntered: {
                //body.color = widget.colorHover
                //body.shrunk = true
            }
            onExited: {
                //body.color = widget.colorNormal
                //body.shrunk = false
            }

            Timer {
                id: animationTimer
                interval: 100

                onTriggered: {
                    body.shrunk = false
                    widget.action()
                }
            }
        }

    //-----------------------------------------------------------------------------
    }//end 'body'
}//end 'widget'





//-----------------------------------------------------------------------------
