import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1
import QtGraphicalEffects 1.12

import QtQuick.Controls 1.4 as OneFourQuick

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"
//-----------------------------------------------------------------------------
// MatterFi_DetailTree.qml
// Provides an interactive list for TreModels.
//
/* OT BlockchainAccountStatusQt
{BlockchainAccountStatusQt::NameRole, "name"},
	{BlockchainAccountStatusQt::SourceIDRole, "sourceid"},
	{BlockchainAccountStatusQt::SubaccountIDRole, "subaccountid"},
	{BlockchainAccountStatusQt::SubaccountTypeRole, "subaccounttype"},
	{BlockchainAccountStatusQt::SubchainTypeRole, "subchaintype"},
	{BlockchainAccountStatusQt::ProgressRole, "progress"},
*/
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

	property var model: undefined // BlockchainAccountStatusQt

  signal action() // Emited when clicked on an index with in the detail structure.

  //-----------------------------------------------------------------------------
	/*
  Component.onCompleted: {
    // debugger:
    console.log("MatterFi_DetailTree model:", contextRoot.model)
    QML_Debugger.listEverything(contextRoot.model)
		//QML_Debugger.listModelChildren(contextRoot.model)
		console.log("RowCount: " + contextRoot.model.rowCount() + ", ColumnCount: " + contextRoot.model.columnCount())
		contextRoot.getIndexData(0, 0, 0)
		contextRoot.getSibling(0, 0, 0)
  }

 	//----------------------
	// Search the detail tree model for data at a row and column.
	function getIndexData(row = 0, column = 0, role = 0) {
		var entrydata = contextRoot.model.data( contextRoot.model.index(row, column), role + 256)
		console.log("Looked up DetailTree model data for:", row, column, role + 256, entrydata)
		QML_Debugger.listEverything(entrydata)
		return entrydata
	}

	function getSibling(index, row = 0, column = 0) {
		var modelIndex = contextRoot.model.index(row, column)
		var sibling = contextRoot.model.sibling(row, column, modelIndex)
		console.log("Looked up DetailTree sibling for:", row, column, modelIndex, sibling)
		QML_Debugger.listEverything(sibling)
		return sibling
	}
	*/

	//-----------------------------------------------------------------------------
	// Create Row header:
	/*
	Component {
		id: modelDetailsDelegate
		Rectangle {
			id: headerDelegateRect
			width: parent.width
			height: 128
			color: "transparent"

			Column {
				width: parent.width
				height: parent.height

				Text {
					id: rowTextHeader
					text: qsTr("Nym ID: ") + listView.model.nym + qsTr("\t Blockchain: ") + listView.model.chain
					color: CustStyle.theme_fontColor
					font.pixelSize: CustStyle.fsize_normal
				}

				Text {
					text: name
					color: CustStyle.theme_fontColor
					font.pixelSize: CustStyle.fsize_normal
				}

				//Text {
				//	text: (progress ? progress : "%0.0")
				//}
			}


			Component.onCompleted: {
				console.log("DetailTree row index:", index, model)
				QML_Debugger.listEverything(model)
				console.log("RowCount: " + model.rowCount() + ", ColumnCount: " + model.columnCount())
				var data = model.data( contextRoot.model.index(0, 1) )
				console.log("Column data: ", data)
				//QML_Debugger.listModelChildren(model)
				QML_Debugger.listEverything(data)
			}
		}
	}

	//----------------------
	// Create the Root list view:
	ListView {
		id: listView
		width: parent.width - 24
		height: parent.height - 4
		visible: true
		topMargin: 12
		model: contextRoot.model
		delegate: modelDetailsDelegate
		clip: true
		anchors.centerIn: parent
	}
	*/

	//-----------------------------------------------------------------------------
	// Default Outdated QT TreeView:  **DEPRECIATED**
	// https://github.com/hvoigt/qt-qml-treeview/blob/master/treemodel.cpp
	OneFourQuick.TreeView {
		id: advancedDetailTreeView
		//visible: (!listView.visible)
		width: parent.width
		height: parent.height
		model: contextRoot.model
		clip: true
		focus: true
		// styling
		frameVisible: true
		headerVisible: false
		backgroundVisible: false
		alternatingRowColors: false
		horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
		verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
		// used to highlight top row depth
		property var is_top_depth_row: true
		// how the rows look
		rowDelegate: Rectangle {
			color: (styleData.selected ? CustStyle.pkt_logo : "transparent")
		}
		// setup view columns
		OneFourQuick.TableViewColumn {
			role: "name"
			title: "Name"
			width: advancedDetailTreeView.width / 7 * 2
		}
		OneFourQuick.TableViewColumn {
			role: "sourceID"
			title: "SourceID"
			width: advancedDetailTreeView.width / 7 * 2
		}
		OneFourQuick.TableViewColumn {
			role: "progress"
			title: "Progress"
			width: advancedDetailTreeView.width / 7 * 3
			horizontalAlignment: Text.AlignRight
		}
		// how the display items look.
		itemDelegate: Item {
			Text {
				height: 32
				color: CustStyle.theme_fontColor
				text: (styleData.value !== undefined ? styleData.value : "")
				font.pixelSize: CustStyle.fsize_normal
			}
		}
	}//end 'advancedDetailTreeView'

	//-----------------------------------------------------------------------------
	// Create a simple border outline:
	OutlineSimple {
		//outline_color: "red"
		radius: 4
	}

  //-----------------------------------------------------------------------------
}//end 'contextRoot'