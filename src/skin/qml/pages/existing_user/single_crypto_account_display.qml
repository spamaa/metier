import QtQuick 2.15
import QtQml.Models 2.1

import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/matterfi"
import "qrc:/qml_shared"
import "qrc:/drawers"

// import org.opentransactions.metier 1.0 as OTModels

//-----------------------------------------------------------------------------
Page {
    id: pageRoot
    title: qsTr("A User Account")
    width: rootAppPage.width
    height: rootAppPage.height
    objectName: "single_account_page"

    background: null //Qt.transparent

    property bool hideNavBar: true // hide navigation bar

    // what index inside the AccountList ot model to display
    // history and transaction interactions for:
    property var force_display_wallet: "PKT"    // sets what wallet to show 'notary_name'
    property var displayAccountList_RowIndex: 0 // set automatically by above value

    // for 'live' theme changing that doesn't require a application restart
    property color fontColor: rootAppPage.currentStyle > 0 ? CustStyle.darkmode_text : CustStyle.lightmode_text

    //-----------------------------------------------------------------------------
    // Create connections:
    Component.onCompleted: {
        // attach to an AccountList OT model Row index, this is set up
        // so that later another wallet can be selected for displaying
        // by calling the same function with the display wallet 'notary_name'
        pageRoot.display_wallet_account_index(pageRoot.force_display_wallet)
        // debugger:
        //console.log("PageRoot for 'Single Crypto Account' is loaded.", pageRoot.force_display_wallet)
    }

    //-----------------------------------------------------------------------------
    // Context Drawers:
    SendFunds_ContextDrawer {
        id: sendContextDrawer
    }
    function openSendContextDrawer() {
        sendContextDrawer.accountActivity_model = pageRoot.currentAccountActivty_OTModel
        sendContextDrawer.accountList_RowModel = pageRoot.accountList_RowModel
        sendContextDrawer.setup()
        rootAppPage.drawerIsOpen = true
        sendContextDrawer.open()
    }
    //----------------------
    ReceiveFunds_ContextDrawer {
        id: receiveContextDrawer
    }
    function openReceiveContextDrawer() {
        receiveContextDrawer.accountActivity_model = pageRoot.currentAccountActivty_OTModel
        receiveContextDrawer.accountList_RowModel = pageRoot.accountList_RowModel
        receiveContextDrawer.force_refresh()
        rootAppPage.drawerIsOpen = true
        receiveContextDrawer.open()
    }

    //-----------------------------------------------------------------------------
    // AccountActivity QML widget interactions:
    function on_accountActivity_receiveFunds() {
        pageRoot.openReceiveContextDrawer(pageRoot.currentAccountActivty_OTModel)
    }

    // send to address
    function on_accountActivity_walletSend() {
        // open context draw manager
        pageRoot.openSendContextDrawer(pageRoot.currentAccountActivty_OTModel)
    }

    //-----------------------------------------------------------------------------
    // Block chain syncronization progress display.
    property var syncprogressLow:  0
    property var syncprogressHigh: 100

    function sync_status(current, total) {
        pageRoot.syncprogressLow = current
        pageRoot.syncprogressHigh = total
        //console.log("Sync Progress: ", current, total)
        bsyncPB.value = (current / total)
        percentageTextDisplay.text = (bsyncPB.value > 1.0 ? 1.0 : bsyncPB.value.toFixed(1), qsTr(" %"))
        if (bsyncPB.value >= 1.0) {
            bsyncPB.isdone = true
        } else {
            bsyncPB.isdone = false
        }
    }

    //-----------------------------------------------------------------------------
    // Handel retrival of an held with in the AccountList model. Use that for a
    // display model data pointer.
    property var accountList_OTModel: undefined
    property var accountList_RowModel: undefined
    property var accountList_Item: ({})
    //----------------------
    DelegateModel {
        id: accountListModelDelegator
        model: undefined

        delegate: Rectangle {
            Component.onCompleted: {
                // set model from index, for Role entries
                if (index == pageRoot.displayAccountList_RowIndex) {
                    pageRoot.accountList_RowModel = model
                    // TODO: find a better way to get and AccountList RowModel for propterties from Role values.
                    pageRoot.setAccountActivity_OTModel()
                    // debugger:
                    //console.log("AccountList RowModel Data:", pageRoot.accountList_RowModel)
                    //QML_Debugger.listEverything(model)
                }
            }
        }
    }
    // *hidden list
    ListView {
        id: accountlistView
        model: accountListModelDelegator
        visible: false
        width: 0
        height: width
    }
    //----------------------
    // Set the View to show the wallet account that resides at the provided index.
    // AccountList Roles { polarity accounttype account balance notary unit contractid }
    function display_wallet_account_index(account_notary_name = "PKT") {
        // clear last data
        pageRoot.accountList_Item = ({})
        // Grab the OT AccountList model for index data retrival used in display:
        pageRoot.accountList_OTModel = otwrap.accountListModelQML()
        accountListModelDelegator.model = pageRoot.accountList_OTModel
        // check if there are active block chains being used, then
        // itterate threw those to find the selected wallet
        if (pageRoot.accountList_OTModel.rowCount() > 0) {
            // loop threw the aviable blockchains so a name can
            // be used, so index isnt an issue.
            var account_index = 0
            while (account_index < pageRoot.accountList_OTModel.rowCount()) {
                // Check in the very least that there is a valid index for Column '0'
                if ( pageRoot.accountList_OTModel.index(account_index, 0).valid ) {
                    var notary_name = accountList_OTModel.data( accountList_OTModel.index(account_index, 0) )
                    //console.log("AccountList OT Model: ", account_notary_name, notary_name);
                    if (notary_name != account_notary_name) {
                        account_index ++
                        continue;
                    }
                    // Watch the 'accountList_OTModel' for any data changes
                    // this is where 'accountList_Item' will get its data populated
                    pageRoot.displayAccountList_RowIndex = account_index
                    accountList_OTModel.dataChanged.connect(pageRoot.on_accountlist_datachanged)
                    pageRoot.on_accountlist_datachanged()// force a first time update
                    // debugger:
                    //console.log("AccountList OT Model found:", accountList_OTModel);
                    //QML_Debugger.listEverything(accountList_OTModel)
                    //QML_Debugger.listEverything(accountList_RowModel) // the displayed AccountList row
                    //QML_Debugger.listEverything(accountList_Item)     // data container for displaying
                    break;
                } else {
                    //console.log("Error wallet account model index is not valid: ", account_index, pageRoot.accountList_OTModel.rowCount());
                }
                account_index ++
            }
        } else {
            // There is only one account displayed in the Wallet list
            console.log("AccountList RowModel set by index 0")
            pageRoot.displayAccountList_RowIndex = 0
            accountList_OTModel.dataChanged.connect(pageRoot.on_accountlist_datachanged)
            pageRoot.on_accountlist_datachanged()// force a first time update
        }
        // if an AccountList model entry was not found
        if (pageRoot.accountList_Item === undefined) {
            console.log("AccountList RowModel by that 'notary_name' was not found:", account_notary_name)
            pageRoot.accountList_RowModel = undefined
        }
    }
    //----------------------
    // Update the acccount model data sets
    function on_accountlist_datachanged(index = null, bottomRight = null, roles = null) {
        // used for the current display Row index from the OT AccountList model data
        var account_index = pageRoot.displayAccountList_RowIndex
        // update column display values used in QML:
        if (pageRoot.accountList_OTModel !== undefined) {
            // Put each Column value into a hash for display
            pageRoot.accountList_Item['notary_name']  = accountList_OTModel.data( 
                accountList_OTModel.index(account_index, 0) ); // NotaryNameColumn
            pageRoot.accountList_Item['balance']      = accountList_OTModel.data(
                accountList_OTModel.index(account_index, 1) ); // DisplayUnitColumn
            pageRoot.accountList_Item['display_name'] = accountList_OTModel.data( 
                accountList_OTModel.index(account_index, 2) ); // AccountNameColumn
            pageRoot.accountList_Item['display_unit'] = accountList_OTModel.data(
                accountList_OTModel.index(account_index, 3) ); // DisplayBalanceColumn

            var notary_name = pageRoot.accountList_Item['notary_name']
            //displayBalanceInUnitsText.text = pageRoot.accountList_Item['display_unit']
            
            // Use the AccountList index AccountActivity model for balance display.
            // Use that data to push display updates where used, will show balance of 0.0
            var display_balance_text = "NaN"
            if (currentAccountActivty_OTModel !== undefined) {
                display_balance_text = currentAccountActivty_OTModel.displayBalance
            } else {
                display_balance_text = "0.0"
            }
            // instead the display value can be grabed from the AccountList model
            //var amount_value = parseFloat(pageRoot.accountList_Item['display_unit']).toFixed(2)
            //var display_balance_text = amount_value
            //if (display_balance_text === "NaN") {
            //    display_balance_text = "0.0"
            //}
            // push that display to the text elements that use it
            displayBalanceInUnitsText.text = display_balance_text
            receiveContextDrawer.currentBalance_displayText = display_balance_text
            sendContextDrawer.currentBalance_displayText = display_balance_text
            // debugger:
            //console.log("Refreshed AccountList Column data: ", pageRoot.accountList_Item)
            //QML_Debugger.listEverything(accountList_OTModel)
            //console.log("Balance data:", display_balance_text)
        } else {
            pageRoot.accountList_Item = undefined
            console.log("Error: Balance data for wallet account could not be found.", account_index)
        }
        //console.log("balance data updated")
    }

    //-----------------------------------------------------------------------------
    // Managing active models used in the page and it's widgets.
    property var currentAccountActivty_OTModel: undefined
    function setAccountActivity_OTModel() {
        if (pageRoot.accountList_RowModel === undefined) {
            console.log("AccountList OT RowModel is 'undefined', can not attach AccountActivity.")
            return
        }
        // set the AccountActivity model to the matching displayed AccountList entry
        pageRoot.currentAccountActivty_OTModel = 
            otwrap.accountActivityModelQML( pageRoot.accountList_RowModel.account );
        // sync with active account activity's BlockChain selection
        if (pageRoot.currentAccountActivty_OTModel != null) {
            // disconnect from current block chain
            currentAccountActivty_OTModel.syncProgressUpdated.disconnect(sync_status)
            // then reconnect the signal to the new selected AccountActivity model
            currentAccountActivty_OTModel.syncProgressUpdated.connect(sync_status)
            // BlockChain sync status for slected AccountActivity model
            // should be connected to sync progress bar display.
        } else {
            console.log("AccountList OT RowModel error, can not attach AccountActivity.")
        }
    }

    //-----------------------------------------------------------------------------
    // The main 'body' layout.
    Column {
        id: body
        spacing: 16
        topPadding: 12
        width: pageRoot.width
        height: walletBrandingImage.height
        anchors.horizontalCenter: parent.horizontalCenter

        //----------------------
        // Display the top of the page header
        Row {
            id: topHeaderElementRow
            spacing: 32
            leftPadding: pageRoot.width / 2 - walletBrandingImage.width - 160
            width: walletBrandingImage.width + accountSummaryDisplay.width
            height: walletBrandingImage.height
            //anchors.horizontalCenter: parent.horizontalCenter

            // BlockChain Logo:
            Image {
                id: walletBrandingImage
                width: 300
                height: 170
                sourceSize.width: walletBrandingImage.width
                sourceSize.height: walletBrandingImage.height
                source: "qrc:/assets/svgs/pkt-logo.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors {
                    topMargin: 0;
                    bottomMargin: 0;
                }
            }

            // Display group for the account's summary of current balance and worth.
            Column {
                id: accountSummaryDisplay
                height: parent.height
                width: 240
                spacing: 8
                topPadding: 8
                //----------------------
                // Display the current BlockChain value held with-in the user's wallet.
                Row {
                    id: balanceDisplayRow
                    width: parent.width
                    height: parent.height
                    spacing: 16

                    Text {
                        id: displayBalanceText
                        text: qsTr("Balance: ")
                        color: CustStyle.accent_text
                        font.bold: true
                        font.pixelSize: CustStyle.fsize_large
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        id: displayBalanceInUnitsText
                        text: qsTr("0.0") // will get updated on changes
                        color: CustStyle.accent_text
                        font.bold: true
                        font.pixelSize: CustStyle.fsize_xlarge
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        //-----------------------------------------------------------------------------
        // Button Row
        Row {
            id: pageButtons
            spacing: 30
            anchors.horizontalCenter: parent.horizontalCenter
            //----------------------
            MatterFi_Button_Standard {
                id: send_button
                displayText: qsTr("Send")
                onClicked: pageRoot.openSendContextDrawer()
            }
            //----------------------
            MatterFi_Button_Standard {
                id: receive_button
                displayText: qsTr("Receive")
                onClicked: pageRoot.openReceiveContextDrawer()
            }
        }

        //-----------------------------------------------------------------------------
        // display the account transaction history:
        MatterFi_TransactionHistoryDisplay {
            id: wip_transaction_display
            width: pageRoot.width
            height: pageRoot.height - accountSummaryDisplay.height - bsyncPBStatus.height - 116

            accountActivityModel: pageRoot.currentAccountActivty_OTModel
        }

    }//end 'body'

    //-----------------------------------------------------------------------------
    // Display the current sync status of the BlockChain:
    Row {
        id: bsyncPBStatus
        width: 320
        spacing: 8
        y: pageRoot.height - bsyncPBStatus.height - 12
        x: pageRoot.width - width - 148
        // ui hint text
        Text {
            text: qsTr("Syncing Blockchain:")
            color: pageRoot.fontColor
            font.pixelSize: CustStyle.fsize_normal
            anchors.verticalCenter: parent.verticalCenter
        }
        // show percentage value
        Text {
            id: percentageTextDisplay
            text: "0.0 %"
            color: pageRoot.fontColor
            font.pixelSize: CustStyle.fsize_normal
            anchors.verticalCenter: parent.verticalCenter
        }
        // bar display
        MatterFi_ProgressBar {
            id: bsyncPB
            minimum: pageRoot.syncprogressLow
            maximum: pageRoot.syncprogressHigh
            width: 200
            anchors.verticalCenter: parent.verticalCenter
        }
        // toggle being shown when sync is done
        visible: (!bsyncPB.isdone)
    }
    // Displayed when the sync is working on Outstanding Blocks
    Row {
        id: outstandingStatus
        width: 128
        spacing: 8
        y: pageRoot.height - 32
        x: pageRoot.width - width - 96
        // display status of blockchain synchronization
        Text {
            text: qsTr("| Blockchain Synced |")
            color: pageRoot.fontColor
            font.pixelSize: CustStyle.fsize_normal
            anchors.verticalCenter: parent.verticalCenter
        }
        // toggle being shown when sync is done
        visible: (bsyncPB.isdone)
    }

    //-----------------------------------------------------------------------------
    // Display the current sync status of the BlockChain:
    MatterFi_BlockChainStatistics {
        id: blockchainStatGroup
        width: parent.width
        y: pageRoot.height - bsyncPBStatus.height - 16
        anchors.horizontalCenter: parent.horizontalCenter
    }

    //-----------------------------------------------------------------------------
    // Display the context menu
    FontIconButton {
        id: menuContextButton
        iconChar: IconIndex.ellipsis_v
        //iconSize: 18
        x: pageRoot.width - 32
        y: 64

        onAction: {
            contextMenu.popup()
        }

        Menu {
            id: contextMenu
            MenuItem { 
                text: "View My Contacts"
                onTriggered: {
                    rootAppPage.passAlongData = pageRoot.currentAccountActivty_OTModel
                    rootAppPage.pushPage("pages/contacts/contact_activity_threads.qml")
                }
            }
            MenuItem { 
                text: "Advanced Wallet Details"
                onTriggered: {
                    rootAppPage.passAlongData = pageRoot.currentAccountActivty_OTModel
                    //rootAppPage.pushPage("pages/existing_user/advanced_wallet_details.qml")
                    accountDetialsWindow.load_qml_file()
                    accountDetialsWindow.show()
                    accountDetialsWindow.requestActivate()
                    console.log("AccountDetails window was opened.")
                }
            }
            MenuItem { 
                text: "My Recovery Words"
                onTriggered: {
                    rootAppPage.pushPage("pages/existing_user/show_recovery_phrase.qml")
                }
            }
            MenuItem { 
                text: "Version"
                onTriggered: {
                    rootAppPage.pushPage("pages/app_version.qml")
                }
            }
        }
    }

    //-----------------------------------------------------------------------------
    // Additional popup windows:
    NewWindow {
        id: accountDetialsWindow
        visible: false
        loaded_qml_file: "qrc:/pages/existing_user/advanced_wallet_details.qml"

        onClosing: {
            console.log("AccountDetails window was closed.")
        }
    }

//-----------------------------------------------------------------------------v
}//end 'pageRoot'
