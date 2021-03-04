import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// This is used to draw a standard looking Button for use accross the application.
// Allows the styling to be applied and changed in one place.
//-----------------------------------------------------------------------------
Button {
  id: widget
  width: 100
  height: 48
  scale: widget.down ? CustStyle.but_shrink : 1.0

  property string displayText: ""

  //-----------------------------------------------------------------------------
  contentItem: ButtonText {
    text: widget.displayText
    //font.capitalization: Font.AllUppercase
  }

  //-----------------------------------------------------------------------------
  background: OutlineSimple {
    implicitWidth: parent.width
    implicitHeight: parent.height
  }

}