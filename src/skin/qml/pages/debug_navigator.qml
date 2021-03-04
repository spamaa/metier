import QtQuick 2.15
import QtQml.Models 2.1

import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Provides a list of all pages and pop ups for testing layouts:
Page {
    id: debugNavigatorPage
    width: rootAppPage.width
    height: rootAppPage.height
    title: qsTr("Debug Pages")
    objectName: "debug_navigator"

    property bool hideNavBar: true // hide navigation bar

    //----------------------
    // Display a popup over rootAppPage
    function showPopup(qml_filename) {
        try {
            var popupComponent = Qt.createComponent(qml_filename)
            var showthisPopup = popupComponent.createObject(rootAppPage)
            showthisPopup.open()
            console.log("Debugging Popup: ", qml_filename, showthisPopup, popupComponent)
        } catch (error) {
            console.log("Popup Crashed: ", qml_filename, error)
        }
    }
    //----------------------
    // When debugging, you can force the display of dummy data where a logged in user
    // data is normally required:
    property bool userLoggedIn: false
    function toggleDummyLoggedin() {
        /*
        var userIsloggedIn = matterfi.isuser_logged_in()
        if ( !userIsloggedIn ) {
            // force a new creation of an empty user profile
            var newActiveProfile = matterfi.get_active_profile(true)
            console.warn("Debug Profile logged in.") //, JSON.stringify(newActiveProfile) )
            userLoggedIn = true
        } else {
            // logging out clears the temp active_profile; this dictates the state of a user
            // being logged in or not. If "MatterFi::active_profile" is 'nullptr' this will
            // be because there is no user currently logged in at the time checked.
            matterfi.logout()
            userLoggedIn = false
            console.warn("Debug Profile logged out.")
        }
        */
    }

    //----------------------
    // run soon as page has Focus again. At initial start, 'matterfi' will not be ready in time.
    onActiveFocusChanged: {
        try {
            userLoggedIn = false //matterfi.isuser_logged_in()
            console.log("DebugNav focus changed, refreshing:")
        } catch(error) {
            console.warn("DebugNav: first focus \"refresh\", 'matterfi' is not available yet.")
            console.warn("DebugNav: This is O.K. if it's the first launch of the application.")
        }
    }

    //-----------------------------------------------------------------------------
    Column {
        id: body
        width: debugNavigatorPage.width
        property int displayWidth: 310
        spacing: 2
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: screenTitle
            text: qsTr("Debug Navigator:")
            color: CustStyle.neutral_text
            font.weight: Font.DemiBold
            font.pixelSize: CustStyle.fsize_title
            smooth: true
            anchors.horizontalCenter: body.horizontalCenter
        }

        //-----------------------------------------------------------------------------
        Row {
            id: modeFunctions
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            width: body.displayWidth
            leftPadding: 0
            topPadding: 8
            // Display NavBar context burger menu:
            Button {
                id: contextBurgerbut
                width: 80
                height: 28
                scale: contextBurgerbut.down ? CustStyle.but_shrink : 1.0
                anchors.verticalCenter: parent.verticalCenter
                contentItem: ButtonText {
                    text: qsTr("CntxBurger")
                    font.pixelSize: CustStyle.fsize_contex
                }
                background: OutlineSimple {}
                onClicked: rootAppPage.openContextDrawer()
            }

            // login as userDummy/profileDummy:
            Label {
                id: toggleDummyLoggedinDataLable
                text: qsTr("Logged-in:")
                color: CustStyle.neutral_text
                font.weight: Font.DemiBold
                font.pixelSize: CustStyle.fsize_lable
                smooth: true
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                rightPadding: toggleDummyLoggedinData.width
                width: body.displayWidth / 3

                Switch {
                    id: toggleDummyLoggedinData
                    scale: 0.6
                    checked: (userLoggedIn === true)
                    anchors.verticalCenter: parent.verticalCenter
                    topPadding: 4
                    leftPadding: parent.width / 2 + 32
                    onClicked: toggleDummyLoggedin()
                }
            }

            // Change Theme modes:
            Label {
                id: toggleDarkLable
                text: qsTr("Dark Mode:")
                color: CustStyle.neutral_text
                font.weight: Font.DemiBold
                font.pixelSize: CustStyle.fsize_lable
                smooth: true
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
                rightPadding: toggleThemeMode.width
                width: body.displayWidth / 3


                Switch {
                    id: toggleThemeMode
                    scale: 0.6
                    checked: (rootAppPage.currentStyle > 0)
                    anchors.verticalCenter: parent.verticalCenter
                    topPadding: 4
                    leftPadding: parent.width / 2 + 42
                    onClicked: {
                        if (!toggleThemeMode.checked) {
                            rootAppPage.changeStyle(0) // light mode
                        } else {
                            rootAppPage.changeStyle(1) // dark mode
                        }
                    }
                }
            }

        }// row

        //-----------------------------------------------------------------------------
        // Pages Selection:
        Text {
            id: pagesTitle
            text: qsTr("Pages:")
            color: CustStyle.neutral_text
            font.weight: Font.DemiBold
            font.pixelSize: CustStyle.fsize_lable
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: 16
        }

        Grid {
            id: pagesGridSelection
            columns: 4
            spacing: 16
            property int squareWidth: 64
            property int squareHeight: 32
            anchors.horizontalCenter: parent.horizontalCenter
            //----------------------
            NavButton {
                textDisplay: qsTr("Home")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/home.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("New User")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/newuser/create_new_profile.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Edit Profile")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/existing_user/edit_profile.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Recover Profile")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/existing_user/enter_recovery_phrase.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("New Recovery")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/newuser/new_recovery_phrase.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Recovery Storage")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/newuser/account_recovery_storing.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Contact List")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/contacts/contact_list.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("View Contact")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/contacts/view_contact_profile.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Recover Wallet")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/existing_user/recover_wallet.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("User Accounts")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    rootAppPage.pushPage("pages/existing_user/user_accounts.qml")
                }
            }
            //----------------------
        }

        //-----------------------------------------------------------------------------
        // Popups Selection:
        /*
        Text {
            id: popupsTitle
            text: qsTr("Popups:")
            color: CustStyle.neutral_text
            font.weight: Font.DemiBold
            font.pixelSize: CustStyle.fsize_lable
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 16
            bottomPadding: 16
        }

        Grid {
            id: popupsSelection
            columns: 4
            spacing: 16
            property int squareWidth: 64
            property int squareHeight: 32
            anchors.horizontalCenter: parent.horizontalCenter
            //----------------------
            NavButton {
                textDisplay: qsTr("PR New")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    debugNavigatorPage.showPopup("qrc:/popup/profile_recovery_new.qml")
                }
            }
            //----------------------
            NavButton {
                textDisplay: qsTr("Enter Pin")
                width: parent.squareWidth
                height: parent.squareHeight
                onAction: {
                    debugNavigatorPage.showPopup("qrc:/popup/enter_user_pin.qml")
                }
            }
            //----------------------
        }
        */

        //-----------------------------------------------------------------------------
    }// page column
}



//-----------------------------------------------------------------------------
