import QtQuick 2.15
import QtQml.Models 2.1

import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_shared"
import "qrc:/styling/cust_formaters"
import "qrc:/matterfi"


//-----------------------------------------------------------------------------
Page {
    id: pageRoot
    title: qsTr("Create New Profile")
    width: rootAppPage.width
    height: rootAppPage.height
    objectName: "create_new_profile"

    background: null //Qt.transparent or "transparent"

    property bool hideNavBar: true // hide navigation bar

    property var fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text

    // container for screen display before saving entry to data container
    property var profileDummy: {
        "name_first": '',
        "name_last": ''
    }
    // Populate the profileDummy with existing data if any held onto
    function populateDummy() {
        // we make a call for new profile data container here
        var newActiveProfile = {} //matterfi.get_active_profile(true)
        //console.log("Profile dummy created: ", JSON.stringify(newActiveProfile) )
        if ( Object.keys(newActiveProfile) < 1 ) {
            // is new, uses template data
            //pageRoot.profileDummy = newActiveProfile
        }
    }
    // run soon as page is ready
    Component.onCompleted: {
        pageRoot.populateDummy()
    }

    //-----------------------------------------------------------------------------
    function submitName(name) {
        var userName = name.split(' ');
        profileDummy.name_first = userName[0];
        profileDummy.name_last = userName[1];
        //console.log("Profile name submited.", JSON.stringify(profileDummy));
        var user_name = profileDummy.name_first + profileDummy.name_last;
        // when the name is sent, a signal is called to navigate to the next step.
        // this will dispose access to rootAppPage.
        otwrap.createNym(name);
    }
    //----------------------
    function onNextButton() {
        // if no name was custom provided, auto fill "Default"
        if (nameInput.displayText.length > 0) {
            nameInput.text = "Default"
        }
        pageRoot.submitName(nameInput.text);
        // after the user provides an account profile name, send
        // them over to pick which block chains they wish to use
        //rootAppPage.pushPage("pages/existing_user/block_chain_chooser.qml");

        // if built so that skips block chain selection and goes to account.
        //rootAppPage.clearStackHome("pages/existing_user/user_accounts.qml"); // << default
        if (rootAppPage !== undefined) {
            rootAppPage.clearStackHome("pages/existing_user/single_crypto_account_display.qml")
            // navigation is handled in 'main.qml' the
            // OT signals emited on completed setup steps
            // will navigate to the next page from that file.
        }
    }
    //----------------------
    function onCancelButton() {
        // nav back to home screen
        rootAppPage.popPage();
    }

    //-----------------------------------------------------------------------------
    // Define the main display 'body' for layout alignents and positioning.
    Column {
        id: body
        spacing: 16
        anchors.horizontalCenter: parent.horizontalCenter

        //----------------------
        // Text Header
        Label {
            id: pageTitle
            topPadding: 20
            text: qsTr("Create New Profile")
            color: fontColor
            font.weight: Font.DemiBold
            font.pixelSize: CustStyle.fsize_title
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //----------------------
        // Name input area
        Column {
            id: nameEntry
            y: pageTitle.y + pageTitle.height + 40
            topPadding: 20
            bottomPadding: 20
            spacing: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: qsTr("Enter Public Wallet Name:")
                color: CustStyle.neutral_text
                smooth: true
                font.pixelSize: CustStyle.fsize_contex
            }

            TextField {
                id: nameInput
                placeholderText: qsTr("Default")
                width: 260
                maximumLength: 64
                leftPadding: 0
                color: fontColor
                echoMode: TextInput.Normal
                renderType: Text.QtRendering
                background: Item {
                    implicitWidth: nameInput.width
                    implicitHeight: nameInput.height
                    Rectangle {
                        color: CustStyle.neutral_fill
                        height: 1
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }

        //----------------------
        // profile name usage details
        Text {
            id: disclaimerText
            width: (body.width / 3 * 2 < 520 ? 520 : body.width / 3 * 2)
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            lineHeight: 1.1
            padding: 8
            color: fontColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: CustStyle.lable_normal
            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr("Your public wallet name is how other users of MatterCode™ enabled wallets can" +
                       " identity your payment code in plain English. If you wish to remain completely" +
                       " anonymous use a random name or non-descriptive name such as \"Default\"." +
                       " In future releases you will be able to maintain multiple wallets with corresponding" +
                       " names. Your name association to a partiuclar on-chain transaction is only cryptographically" +
                       " computatable in wallets you have transacted with. Only MatterCode™ wallets you have sent" +
                       " money to or received moeny from will see your wallet name in their transaction history.")

            // outline the input box
            OutlineSimple {
            outline_color: CustStyle.accent_outline
            }
        }

        //----------------------
        // Button Row
        Row {
            id: pageButtons
            topPadding: 40
            spacing: 120

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            /*
            MatterFi_Button_Standard {
                id: cancel_button
                displayText: qsTr("Cancel")
                onClicked: pageRoot.onCancelButton()
            }
            */

            MatterFi_Button_Standard {
                id: next_button
                enabled: true //(nameInput.displayText.length > 0)
                displayText: qsTr("Next")
                onClicked: pageRoot.onNextButton()
            }
        }

    }//end 'body'

    //-----------------------------------------------------------------------------
}
