import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import com.TreeModelAdaptor 1.0
import "qrc:/treeview"

import "qrc:/styling"
import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// 'MatterFi_DetailTree.qml'
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

	property alias model: advancedDetailTreeView.model // BlockchainAccountStatusQt

  signal action() // Emited when clicked on an index with in the detail structure.

	//-----------------------------------------------------------------------------
	// Default Outdated QT TreeView:  **Qt5 DEPRECIATED**  //** Replaced  **//
	// https://github.com/hvoigt/qt-qml-treeview/blob/master/treemodel.cpp
	TreeView {
		id: advancedDetailTreeView
		//visible: (!listView.visible)
		width: parent.width
		height: parent.height
		//model: contextRoot.model
		clip: true
		focus: true
		// styling
		//frameVisible: true
	  headerVisible: false
		//backgroundVisible: false
		//alternatingRowColors: false
		//horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
		//verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
		// used to highlight top row depth
		property var is_top_depth_row: true
		// how the rows look
		rowDelegate: Rectangle {
			color: (styleData.selected ? DawgsStyle.aa_selected_bg : "transparent")
		}
		// setup view columns
		TableViewColumn {
			role: "name"
			title: "Name"
			width: advancedDetailTreeView.width / 7 * 2
		}
		TableViewColumn {
			role: "sourceID"
			title: "SourceID"
			width: advancedDetailTreeView.width / 7 * 2
		}
		TableViewColumn {
			role: "progress"
			title: "Progress"
			width: advancedDetailTreeView.width / 7 * 3
			horizontalAlignment: Text.AlignRight
		}
		// how the display items look.
		itemDelegate: Item {
			Text {
				height: 32
				color: DawgsStyle.font_color
				text: (styleData.value !== undefined ? styleData.value : "")
				font.pixelSize: DawgsStyle.fsize_normal
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