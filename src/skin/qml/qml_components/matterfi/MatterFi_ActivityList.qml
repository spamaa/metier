import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
//-----------------------------------------------------------------------------
// MatterFi_ActivityList.qml
// Provides deligation for contact activity thread models.
/*
qml: QQmlDMAbstractItemModelData(0x7f837b630830)
qml: time:Thu Jul 15 20:19:55 2021 GMT-0500
qml: type:10
qml: polarity:1
qml: text:Incoming PKT transaction from PD1kEC92CeshFRQ3V78XPAGmE1ZWy3YR4Ptsjxw8SxHgZvFVkwqjf
qml: memo:
qml: pending:false
qml: amount:1.479 999 999 52 PKT
qml: loading:false
qml: outgoing:false
qml: from:PD1kEC92CeshFRQ3V78XPAGmE1ZWy3YR4Ptsjxw8SxHgZvFVkwqjf
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
  width: parent.width
  height: 128

  property var model: ({})

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
    id: activityViewRect
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
        property var modelData: model
        property var timeElapsed: DawgsStyle.getElapsedTime(modelData.time)
        toplText: "" //modelData.text
        bottomlText: timeElapsed
        toprText: modelData.amount
        bottomrText: "$0000 USD"
        imageSource: "qrc:/assets/splash/logotype.svg"
        is_selected: (index === activityListView.selected_index)
        onClicked: {
          activityListView.selected_index = index
          contextRoot.onAction_activityList(modelData)
        }

        Component.onCompleted: {
          var first_space = modelData.text.indexOf(' ')
          listDeligate.toplText = modelData.text.substr(0, first_space)
        }
      }
    }

    //----------------------
    // Show the activity selection list:
    ListView {
      id: activityListView
      model: (contextRoot.model === null ? [] : contextRoot.model)
      property int selected_index: -1
      delegate: transactionListModelDelegator
      clip: true
      spacing: 0
      width: parent.width
      height: parent.height
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }//end 'activityViewRect'

  //-----------------------------------------------------------------------------
  // No activity where found notification:
  Rectangle {
    id: noTransactionsRect
    visible: (activityListView.count < 1)
    width: parent.width
    height: 52
    color: "transparent"

    Text {
      id: noActivityTextDisplay
      text: qsTr("no activity found")
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