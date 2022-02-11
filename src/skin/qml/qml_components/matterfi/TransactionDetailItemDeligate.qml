import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// TransactionDetailItemDeligate.qml
// Provides a standard for deligation of Transaction detail items.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: parent.width
  height: ( doubleRow ? 56 : 28 );
  color: "transparent"

  property bool doubleRow: false
  property bool displayLineDivide: false
  property string dataTitle: qsTr("lable")
  property string dataLnOne: qsTr("line 1")
  property string dataLnTwo: ""

  //-----------------------------------------------------------------------------
  Rectangle {
    id: detailsDisplayRect
    color: "transparent"
    anchors.fill: parent

    // Title text to accompanying data:
    Text {
      id: titleContextText
      text: contextRoot.dataTitle
      color: DawgsStyle.font_color
      font.pixelSize: DawgsStyle.fsize_normal
      anchors {
        left: parent.left;
        leftMargin: 6;
        top: parent.top;
        topMargin: 6;
      }
    }

    // Details attached to the Title text:
    Column {
      id: doubleLeftTextColumnDisplay
      width: parent.width - titleContextText.width
      height: parent.height
      spacing: 4
      anchors {
        right: parent.right;
        rightMargin: 6;
        top: parent.top;
        topMargin: 6;
      }

      Text {
        id: lineOneDisplayText
        text: contextRoot.dataLnOne
        color: DawgsStyle.font_color
        font.pixelSize: DawgsStyle.fsize_normal
        anchors {
          right: parent.right;
          rightMargin: 6;
        }
      }

      Text {
        id: lineTwoDisplayText
        text: contextRoot.dataLnTwo
        color: DawgsStyle.text_descrip
        visible: contextRoot.doubleRow
        font.pixelSize: DawgsStyle.fsize_normal
        anchors {
          right: parent.right;
          rightMargin: 6;
        }
      }
    }
  }

  // Sectional divider for in list element usage:
  Rectangle {
    id: sectionalLineDivider
    width: contextRoot.width
    height: 1
    color: DawgsStyle.aa_norm_ol
    visible: contextRoot.displayLineDivide

    anchors {
      bottom: parent.top;
      bottomMargin: 2
    }
  }

}//end 'contextRoot'