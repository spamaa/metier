import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
//-----------------------------------------------------------------------------
// MatterFi_TransactionList.qml
// Provides deligation for account activities.
/*
qml: index:0
qml: hasModelChildren:false
qml: confirmations:226683
qml: contacts:
qml: workflow:
qml: uuid:
qml: polarity: 1
qml: memo:
qml: timestamp:Fri May 7 18:03:18 2021 GMT-0500
qml: amount:0.499 990 202 49 PKT
qml: description:Incoming PKT transaction
qml: type:10
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: 128

  property var model: ({})
  property alias emptyStringDetail: noTransactionsTextDisplay.text

  signal selectedActivity()

  //----------------------
	property var selectedActivityListRow: undefined
  // Called when an activity list item was selected from list:
  function onAction_activityList(selection) {
		// selection should be transaction QQmlDMAbstractItemModelData
    contextRoot.selectedActivityListRow = selection
		// debugger:
    //console.log("Activity selection made: ", parent.selectedActivityListRow)
		//QML_Debugger.listEverything(contextRoot.selectedActivityListRow)
    // fire signal with model data to selection deligator
    contextRoot.selectedActivity(contextRoot.selectedActivityListRow)
	}

  //-----------------------------------------------------------------------------
  // List all transactions:
  Rectangle {
    id: transactionsListRect
    width: parent.width
    height: parent.height
    color: "transparent"
    //----------------------
    // what each transaction entry looks like:
    Component {
      id: transactionListModelDelegator
      //----------------------
      // draw each account activity entry
      Dashboard_ListDetailedDeligate {
        id: listDeligate
        width: contextRoot.width
        height: 86
        property var timeElapsed: DawgsStyle.getElapsedTime(model.timestamp)
        toplText: "" //model.description
        bottomlText: timeElapsed
        toprText: model.amount
        bottomrText:  (DawgsStyle.ot_exchanges ? "$0000 USD" : "") //TODO: bugzilla#34

        //imageSource: "qrc:/assets/splash/logotype.svg"
        iconSource: (model.polarity < 0 ? IconIndex.fa_turn_up : IconIndex.fa_turn_down)
        iconColor: (model.polarity < 0 ? DawgsStyle.aa_selected_ol : DawgsStyle.font_color)
        imageBG: (model.polarity < 0 ? DawgsStyle.page_bg : DawgsStyle.aa_hovered_bg)
        imageOutline: (model.polarity < 0 ? "transparent" : DawgsStyle.aa_selected_ol)

        is_selected: (index === transactionListView.selected_index)
        onClicked: {
          transactionListView.selected_index = index
          contextRoot.onAction_activityList(model)
        }

        Component.onCompleted: {
          var first_space = model.description.indexOf(' ')
          listDeligate.toplText = model.description.substr(0, first_space)
        }
      }
    }

    //----------------------
    // Show the transacation selection list:
    ListView {
      id: transactionListView
      model: (contextRoot.model === null ? [] : contextRoot.model)
      property int selected_index: -1
      delegate: transactionListModelDelegator
      clip: true
      spacing: 0
      width: parent.width
      height: parent.height
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }//end 'transactionsListRect'

  //-----------------------------------------------------------------------------
  // No transactions where found notification:
  Rectangle {
    id: noTransactionsRect
    visible: (transactionListView.count < 1)
    width: parent.width
    height: 52
    color: "transparent"

    Text {
      id: noTransactionsTextDisplay
      text: qsTr("no transactions found")
      color: DawgsStyle.aa_norm_ol
      font.pixelSize: DawgsStyle.fsize_accent
      font.weight: Font.Bold
      anchors.centerIn: parent
    }

    Rectangle {
			id: viewBottomRectLine
			height: 2
			width: parent.width
			color: DawgsStyle.aa_norm_ol
      anchors.bottom: parent.bottom
		}
  }

//-----------------------------------------------------------------------------
}// end 'body'