import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15

import "qrc:/"
import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/page_components"
import "qrc:/matterfi"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// Dashboard_Contacts.qml
// Display delegate for ContactList.
//-----------------------------------------------------------------------------
Item {
  id: contextRoot
	width: parent.width
	height: parent.height

	property var contactList_model: undefined  // expecting OT 'ContactListModel'
	property string filterString: ""
	property bool contactListisEmpty: true
	property int current_contact_index: -1
	property var current_contact_sel: ({})
	property bool isEnabled: true

	signal action() // called when a contact is interacted with.

	//----------------------
	// Run soon as contextRoot is ready.
	Component.onCompleted: {
		contextRoot.populateContacts()
		// delete user's profile, its always index 0 in the Contact model.
		//contactsListView.model.removeRow(0) 
	}

	//----------------------
	// Make the display list of available user contacts. OT 'ContactListModel'
	function populateContacts() {
		if (contextRoot.contactList_model === undefined) {
			OTidentity.checkContacts()
			contextRoot.contactList_model = OTidentity.contactList_OTModel
			contextRoot.contactList_model.dataChanged.connect(contextRoot.contactsDataChanged)
			contactsListView.model = contextRoot.contactList_model
		}
		// debugger:
		//console.log("Contacts populated:", contextRoot.contactList_model.rowCount(), 
		//	contextRoot.contactList_model.columnCount() );
		//QML_Debugger.listEverything(contextRoot.contactList_model)
		//QML_Debugger.listEverything(contactsListView.model)
	}

	// Called on signal slot, contact data model has updated.
	function contactsDataChanged(index, bottomRight, roles) {
		contextRoot.populateContacts()
	}

	//-----------------------------------------------------------------------------
  // Clear connections, disconnect slots if any here.
  Component.onDestruction: {
		contextRoot.contactList_model.dataChanged.disconnect(contextRoot.contactsDataChanged)
  }

	//-----------------------------------------------------------------------------
	// Contact list interactive display deligation.
	Component {
    id: contactDeligate
		Dashboard_ListDeligate {
			id: listDeligate
			width: body.width
			topText: (index === 0 ? (model.name + " (myself)") : 
				(model.name.length > 18 ? model.name.slice(0, 18) + "..." : 
				model.name)
			);
			bottomText: "nil transaction(s)"
			imageSource: ""
			item_index: index
			contactPaymentCode: model.id
			onClicked: {
				contextRoot.current_contact_sel = model
				contextRoot.action()
			}
			//----------------------
			// Filtering the display:  Qt::CaseInsensitive
			property var filterString: (contextRoot.filterString)
			visible: ((filterString.length === 0 && index !== 0) || (
				model !== undefined && (
					model.name.indexOf(filterString) !== -1 ||
					model.id.indexOf(filterString) !== -1
				)
			)) && index !== 0 // hide first index (myself)
			height: (listDeligate.visible ? 64 : 0)
		}
	}

	//-----------------------------------------------------------------------------
	// show the contact list:
	Dashboard_ListView {
		id: contactsListView
		model: []
		delegate: contactDeligate
		visible: (!searchingBusyIndicator.visible && contactsListView.count > 1)
		anchors.horizontalCenter: parent.horizontalCenter
		footerText: qsTr("Looking for more?")
		footerButtonText: qsTr("Add a contact")
		onFooterAction: pageRoot.pushDash("dashboard_create_contact")

		// Search time out is busy indication:
		Timer {
			id: searchTimeoutTimer
			interval: 500

			onTriggered: {
				searchingBusyIndicator.running = false
				searchingBusyIndicator.visible = false
				contextRoot.filterString = searchbox.text
			}
		}
		// is searching/filtering contact list
		BusyIndicator {
			id: searchingBusyIndicator
			visible: (searchTimeoutTimer.running)
			scale: 1.0
			anchors.centerIn: parent
		}
		// displayed when no contacts match search context
		Label {
			id: noMatchesLabel
			anchors.centerIn: parent
			visible: false
			text: "No matches"
			color: DawgsStyle.font_color
		}
	}//end 'contactListView'

	//-----------------------------------------------------------------------------
  // Viewed when the user has no contacts.
  Rectangle {
    id: hasNoContactsViewRect
    width: parent.width
    height: createActivityPromptColumn.height + DawgsStyle.verticalMargin
    color: DawgsStyle.norm_bg
    radius: 12
		visible: (contactsListView.visible === false)
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
      id: createActivityPromptColumn
      width: parent.width
      spacing: 4
      anchors.horizontalCenter: parent.horizontalCenter

      Dawgs_CenteredTitle {
        fontPixelSize: DawgsStyle.fsize_accent
        textTitle: qsTr("You have no contacts")
      }

      MatterFi_RoundButton {
        text: qsTr("Add one")
        anchors.horizontalCenter: parent.horizontalCenter
        border_color: DawgsStyle.buta_active
        onClicked: {
					pageRoot.pushDash("dashboard_create_contact")
        }
      }
    }
  }//end 'noActivityViewRect'

//-----------------------------------------------------------------------------
}//end 'contextRoot'