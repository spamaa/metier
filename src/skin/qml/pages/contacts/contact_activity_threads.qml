import QtQuick 2.15
import QtQml.Models 2.1

import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_shared"
import "qrc:/drawers"

//-----------------------------------------------------------------------------
// Displays user's contact list and a single user selected activity thread.
Page {
    id: pageRoot
    width: rootAppPage.width
    height: rootAppPage.height
    title: qsTr("Contact Threads")
    background: null //Qt.transparent

    property bool hideNavBar: true // hide navigation bar
    //-----------------------------------------------------------------------------
    // Called on button interaction to navigate back in the app Page stack.
    function onNavBackButton() {
        rootAppPage.popPage();
    }
    //----------------------
    // Called when a contact is clicked on in the list.
    function onContactSelection(contact_index, contact_model) {
        selectedContactActivityDisplay.displayBusySignal()
        //var name = pageRoot.contactList_model.data( contactList_model.index(contact_index, 0) )
        //console.log("Contacts List: contact was clicked on.", contact_index, name, contact_model)
        //QML_Debugger.listEverything(contact_model)
        pageRoot.current_contact_index = contact_index
        pageRoot.currentContact_model = contact_model
        pageRoot.getActivityThread(contact_model.id)
    }

    //-----------------------------------------------------------------------------
    // Manage contact activity thread display for current selection.
    property var accountActivity_model: ({}) // expecting 'AccountActivityModel'
    property var contactList_model: ({})     // expecting 'ContactListModel'
    property var contactActivity_model: ({}) // expecting 'ActivityThreadModel'
    property var currentContact_model: ({})  // expecting 'QAbstractItemModel'
    property var filterString: ""
    property bool contactListisEmpty: true
    property var current_contact_index: -1
    //----------------------
    // Run soon as page is ready.
    Component.onCompleted: {
        //console.log("Contact Activity display is being re-created.")
        // grab current account activity from wallet for address verification
        pageRoot.accountActivity_model = rootAppPage.passAlongData
        rootAppPage.clear_passAlong()
        //QML_Debugger.listEverything(pageRoot.accountActivity_model)
        // populated the known contacts list for activity thread selection
        pageRoot.populateContacts()
    }
    //----------------------
    // Grab the p2p activity between user and contact selected.
    function getActivityThread(address) {
        //console.log("Grabbing p2p thread activity for contact:", address)
        pageRoot.contactActivity_model = otwrap.activityThreadModelQML(address)
        //QML_Debugger.listEverything(pageRoot.contactActivity_model)
        selectedContactActivityDisplay.refresh(pageRoot.contactActivity_model,
            pageRoot.currentContact_model);
        // refresh the current contact display information for targeted activity thread
        currentActivityThread_CD.clear_display()
        // check if the user is talking to themselves
        //console.log("Checking is self:", pageRoot.accountActivity_model.accountID, pageRoot.currentContact_model.id)
        //QML_Debugger.listEverything(accountActivity_model)
        //QML_Debugger.listEverything(currentContact_model)
        //QML_Debugger.listEverything(contactActivity_model)

        // Set the variables to display the current contact the ActivityThread is showing.
        if (pageRoot.current_contact_index === 0) { 
            currentActivityThread_CD.name = pageRoot.currentContact_model.name + " (myself)"
        } else { // is talking to other users
            currentActivityThread_CD.name = pageRoot.currentContact_model.name
        }
        currentActivityThread_CD.image = pageRoot.currentContact_model.image
        // grab the matterfi payment code for clipboard copies.
        currentActivityThread_CD.paymentCode = pageRoot.currentContact_model.id
    }
    //----------------------
    // Make the display list of available user contacts.
    function populateContacts() {
        var fetchedContactList = otwrap.contactListModelQML()
        //console.log("Contacts List fetched:", fetchedContactList)
        //QML_Debugger.listEverything(fetchedContactList)
        
        // display the list of contacts known for activity thread selection
        if ( fetchedContactList.rowCount() < 1 ) {
            //console.log("Contacts List: No Contacts where found.")
            contactListisEmpty = true
        } else {
            pageRoot.contactList_model = fetchedContactList
            //console.log("Contacts populated:", pageRoot.contactList_model )
            contactListModelDelegator.model = pageRoot.contactList_model
            contactListisEmpty = false
        }
    }
    //----------------------
    // Filtering the contact list displayed.
    function applySearchFilter(filter_text) {
        console.log("Applying contact list filter string.", filter_text)
        pageRoot.filterString = filter_text

    }
    //----------------------
    // Call UI to add a new contact to the known list.
    function openNewContactUI() {
        createnewContactDrawer.setup(pageRoot.contactList_model, pageRoot.accountActivity_model)
        rootAppPage.drawerIsOpen = true
        createnewContactDrawer.open()
    }

    //-----------------------------------------------------------------------------
    // ContextUI Drawers:
    CreateContact_ContextDrawer {
        id: createnewContactDrawer
    }

    //-----------------------------------------------------------------------------
    // Main 'body' layout:
    Column {
        id: body
        height: pageRoot.height
        width: pageRoot.width
        spacing: 0
        anchors.horizontalCenter: parent.horizontalCenter

        // Page Header bar:
        Rectangle {
            id: pageHeader
            width: pageRoot.width
            height: 42
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                id: headerbarDisplay
                width: parent.width
                height: parent.height
                leftPadding: 16
                spacing: (currentActivityThread_CD.shrunk ? 
                    pageHeader.width / 2 - (leftPadding * 2) : pageHeader.width / 2 - leftPadding)
                anchors.horizontalCenter: parent.horizontalCenter
                // navigate to prevous page button
                FontIconButton {
                    id: navBackIconButton
                    iconChar: IconIndex.arrow_alt_circle_left
                    //iconSize: 18
                    anchors.verticalCenter: parent.verticalCenter
                    color: CustStyle.theme_fontColor
                    onAction: pageRoot.onNavBackButton()
                }
                // current contact ActivityThread is focused on
                Rectangle {
                    id: currentActivityThread_CD
                    width: pageHeader.width / 4
                    height: pageHeader.height
                    color: "transparent"
                    property var name: ""
                    property var image: undefined
                    property var paymentCode: ""
                    
                    visible: (currentActivityThread_CD.name !== "")
                    property bool shrunk: false
                    // used to clear the display of current selected contact details
                    function clear_display() {
                        currentActivityThread_CD.name = ""
                        currentActivityThread_CD.image = undefined
                        currentActivityThread_CD.paymentCode = ""
                    }
                    // display which contact is currently in activity with
                    Row {
                        id: currentContactDetailsRow
                        scale: currentActivityThread_CD.shrunk ? CustStyle.but_shrink : 1.0
                        width: parent.width
                        height: parent.height
                        leftPadding: 4
                        anchors.centerIn: parent
                        // profile photo:
                        MatterFi_Avatar {
                            id: contactAvatarImage
                            width: parent.height
                            height: width
                            avatarUrl: (currentActivityThread_CD.image !== undefined ?
                                currentActivityThread_CD.image : "")
                            anchors.verticalCenter: parent.verticalCenter
                            // display tool tip notification
                            ToolTip {
                                id: copyCD_PaymentCodeToolTip
                                visible: false
                                text: qsTr("MatterCode™ Copied!")
                                // set display color palette
                                palette {
                                    base: Universal.background
                                }
                                // time that the ToolTip is displayed for
                                Timer {
                                    id: copyCD_paymentcodeCopied
                                    interval: 2000
                                    running: false
                                    onTriggered: {
                                        copyCD_PaymentCodeToolTip.visible = false
                                    }
                                }
                            }
                        }
                        // profile name:
                        Text {
                            id: contactNameText
                            text: currentActivityThread_CD.name
                            color: CustStyle.theme_fontColor
                            leftPadding: 12
                            font.pixelSize: CustStyle.fsize_normal
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        // work around limitation for QClipBoard in QML not being accessible
                        TextEdit {
                            id: textClipBoard
                            visible: false
                        }
                    }//end 'currentContactDetailsRow'
                    
                    // mark input area
                    MouseArea {
                        id: contactDetailsRow_MA
                        anchors.fill: parent
                        hoverEnabled: true
                        // copy text on user click
                        onClicked: {
                            currentActivityThread_CD.shrunk = false
                            textClipBoard.text = currentActivityThread_CD.paymentCode
                            textClipBoard.selectAll()
                            textClipBoard.copy()
                            copyCD_PaymentCodeToolTip.visible = true
                            copyCD_paymentcodeCopied.start()
                        }
                        onPressed: { currentActivityThread_CD.shrunk = true }
                        onReleased: { currentActivityThread_CD.shrunk = false }
                        onEntered: { currentActivityThread_CD.shrunk = true }
                        onExited: { currentActivityThread_CD.shrunk = false }
                    }
                }//end 'currentActivityThread_CD'
            }//end 'headerbarDisplay'
        }//end 'pageHeader'

        //-----------------------------------------------------------------------------
        // Split the page body down the middle.
        Row {
            id: leftRightPageRow
            width: body.width
            height: body.height - pageHeader.height
            anchors.horizontalCenter: parent.horizontalCenter

            //-----------------------------------------------------------------------------
            // Contacts list header bar, filtering is done with in the DelegateModel.
            Column {
                id: contactsListDisplay
                height: leftRightPageRow.height
                width: 256 //leftRightPageRow.width / 2

                Rectangle {
                    id: contactsListHeader
                    width: parent.width
                    height: 42
                    color: CustStyle.neutral_fill
                    anchors.horizontalCenter: parent.horizontalCenter
                    property color search_color: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text
                    // interactive contact list bar elements
                    Row {
                        id: searchbarDisplay
                        width: parent.width
                        height: parent.height
                        leftPadding: 6
                        spacing: 8
                        // open new contact UI
                        FontIconButton {
                            id: profileContextButton
                            iconChar: IconIndex.address_card
                            iconSize: 24
                            anchors.verticalCenter: parent.verticalCenter
                            onAction: {
                                pageRoot.openNewContactUI()
                            }
                        }
                        // search icon
                        MatterFi_SVGimage {
                            id: searchIcon
                            svgFile: "search"
                            isFAicon_solid: true
                            width: 20
                            height: width // is square image
                            color: contactsListHeader.search_color
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        // search string entry field
                        TextField {
                            id: searchbox
                            placeholderText: "Search"
                            maximumLength: 32
                            focus: (!rootAppPage.drawerIsOpen)
                            clip: true
                            width: searchbarDisplay.width - 72
                            color: contactsListHeader.search_color
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            echoMode: TextInput.Normal
                            renderType: Text.QtRendering

                            background: Item {
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                Rectangle {
                                    color: "transparent"
                                    height: parent.height
                                    width: parent.width
                                    anchors.fill: parent
                                }
                            }
                            // update current typed string filter
                            onTextChanged: {
                                if (!pageRoot.contactListisEmpty) {
                                    searchingBusyIndicator.running = true
                                    searchingBusyIndicator.visible = true
                                    searchTimeoutTimer.restart()
                                }
                            }
                        }
                    }//end 'searchbarDisplay'
                }//end 'contactsListHeader'

                //-----------------------------------------------------------------------------
                // Contact list interactive display
                Rectangle {
                    id: contactListView
                    width: parent.width
                    height: parent.height - contactsListHeader.height
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter

                    // The display DelegateModel for a contact in the list:
                    DelegateModel {
                        id: contactListModelDelegator
                        model: pageRoot.contactList_model
                        // draw all the contacts, also matching search context if any
                        delegate: MatterFi_ContactListDelegate {
                            width: listView.width
                            contact_data: model
                            listIndex: index
                            filterString: (pageRoot.filterString)
                            onAction: {
                                pageRoot.onContactSelection(index, contact_data)
                            }
                        }
                    }
                    // show the contact list:
                    ListView {
                        id: listView
                        clip: true
                        width: parent.width
                        height: parent.height
                        anchors.topMargin: 16
                        model: contactListModelDelegator
                        visible: (!searchingBusyIndicator.visible)
                        anchors.top: parent.anchors.TopAnchor
                        anchors.left: parent.anchors.LeftAnchor
                        anchors.bottom: parent.anchors.BottomAnchor
                        anchors.right: parent.anchors.RightAnchor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    // Search time out is busy indication:
                    Timer {
                        id: searchTimeoutTimer
                        interval: 500

                        onTriggered: {
                            searchingBusyIndicator.running = false
                            searchingBusyIndicator.visible = false
                            pageRoot.applySearchFilter(searchbox.text)
                        }
                    }
                    // is searching/filtering contact list
                    MatterFi_BusyIndicator {
                        id: searchingBusyIndicator
                        scale: 1.0
                        anchors.centerIn: parent
                    }
                    // displayed when no contacts match search context
                    Label {
                        id: noMatchesLabel
                        anchors.centerIn: parent
                        visible: false
                        text: "No matches"
                        color: CustStyle.theme_fontColor
                    }
                    // displayed when no contacts are avalaible
                    Label {
                        id: noContactsLabel
                        anchors.centerIn: parent
                        visible: contactListisEmpty
                        text: "No Contacts"
                        color: CustStyle.theme_fontColor
                    }
                }//end 'contactListView'
            }//end 'contactsListDisplay'

            //-----------------------------------------------------------------------------
            // Contact activity display area
            MatterFi_ContactActivityDelegate {
                id: selectedContactActivityDisplay
                width: leftRightPageRow.width - contactsListDisplay.width
                height: leftRightPageRow.height
            }

        //-----------------------------------------------------------------------------
        }//end 'leftRightPageRow'
    }//end 'body' Column

//-----------------------------------------------------------------------------
}//end 'pageRoot'
