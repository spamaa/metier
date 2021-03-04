import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12
import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/matterfi"
import "qrc:/qml_shared"
import "qrc:/matterfi"
//-----------------------------------------------------------------------------
/* AccountStatus OT model:
*
* qml: nym:
* qml: chain:
* qml: objectNameChanged:function() { [native code] }
* qml: dataChanged:function() { [native code] }
* qml: headerDataChanged:function() { [native code] }
* qml: layoutChanged:function() { [native code] }
* qml: resetInternalData:function() { [native code] }
* qml: hasIndex:function() { [native code] }
* qml: index:function() { [native code] }
* qml: rowCount:function() { [native code] }
* qml: columnCount:function() { [native code] }
* qml: data:function() { [native code] }
* 
* Roles:
*   NameRole = Qt::UserRole + 0,            // QString
*   SourceIDRole = Qt::UserRole + 1,        // QString
*   SubaccountIDRole = Qt::UserRole + 2,    // QString
*   SubaccountTypeRole = Qt::UserRole + 3,  // int
*   SubchainTypeRole = Qt::UserRole + 4,    // int
*   ProgressRole = Qt::UserRole + 5,        // QString
* 
*/
//-----------------------------------------------------------------------------
// Display an advanced detailed tree of connected peers and sync details for the blockchains.
Page {
  id: pageRoot
  title: qsTr("Advanced Wallet Details")
  objectName: "advanced_details"
  width: rootAppPage.width
  height: rootAppPage.height

  background: Rectangle {
    id: page_bg_fill
    color: rootAppPage.currentStyle > 0 ? CustStyle.dm_pagebg : CustStyle.lm_pagebg
  }

  property bool hideNavBar: true // hide navigation bar

  // Model component ponter propteries:
  property var accountStatus_OT:   ({}) // expecting "AccountStatus" OT model
  property var accountActivity_OT: ({}) // expecting "AccountActivity" OT model

  //-----------------------------------------------------------------------------
  // Button Actions:
  //function onNavBackButton() {
  //  rootAppPage.popPage()
  //}

  //-----------------------------------------------------------------------------
  // Finishes deligation requirement for model for OT AccountStatus display.
  function setAccountStatusModel() {
    // grab account_id to get peer sync details AccountStatus model
    var account_id = pageRoot.accountActivity_OT.accountID
    pageRoot.accountStatus_OT = otwrap.accountStatusModelQML(account_id)
    // debugger:
    //console.log("AccountStatus model id:", account_id, "Model:\n", pageRoot.accountStatus_OT)
    //QML_Debugger.listEverything(pageRoot.accountStatus_OT)
  }

  // Run as soon as page is loaded:
  Component.onCompleted: {
    // grab current AccountActivity from wallet navigation
    pageRoot.accountActivity_OT = rootAppPage.passAlongData
    rootAppPage.clear_passAlong()
    // populate pageRoot model pointers
    pageRoot.setAccountStatusModel()
  }

  //-----------------------------------------------------------------------------
  // main display 'body' layout
  Column {
    id: body
    width: parent.width
    height: parent.height
    spacing: 12
    padding: 16
    anchors.centerIn: parent

    //----------------------
    // BlockChain Logo:
    Image {
      id: walletBrandingImage
      source: "qrc:/assets/svgs/pkt-icon.svg"
      width: 180
      height: 120
      smooth: true
      fillMode: Image.PreserveAspectFit
      anchors.topMargin: 0
      anchors.bottomMargin: 0
      sourceSize.width: walletBrandingImage.width
      sourceSize.height: walletBrandingImage.height
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // Clear Page Title:
    Text {
      id: contextDrawerFunctionTextDescription
      text: qsTr("Advanced Wallet Details:")
      font.weight: Font.DemiBold
      font.pixelSize: CustStyle.fsize_xlarge
      color: CustStyle.accent_text
      verticalAlignment: Text.AlignVCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //----------------------
    // Details TreeView display rect:
    Rectangle {
      id: displayTreeRect
      color: "transparent"
      width: parent.width / 16 * 15
      height: parent.height - (walletBrandingImage.height * 2)
      anchors.horizontalCenter: parent.horizontalCenter

      MatterFi_DetailTree {
        id: accountDetailDelegate
        model: pageRoot.accountStatus_OT
      }
    }//end 'displayTreeRect'

    //----------------------
    // Exit button:
    /*
    MatterFi_Button_Standard {
      id: doneButton
      displayText: qsTr("Done")
      onClicked: pageRoot.onNavBackButton()
      anchors.horizontalCenter: parent.horizontalCenter
    }
    */

  //-----------------------------------------------------------------------------
  }//end 'body'


//-----------------------------------------------------------------------------
}//end 'pageRoot'
