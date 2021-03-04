import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12
import QtGraphicalEffects 1.12

import "qrc:/styling"

//-----------------------------------------------------------------------------
// Used to style drop down selection ComboBoxes.
//-----------------------------------------------------------------------------
ComboBox {
  id: widget
  model: ["null"] // the options displayed for selection.

  //-----------------------------------------------------------------------------
  // What the list looks like when selection is active.
  delegate: ItemDelegate {
    width: widget.width
    highlighted: widget.highlightedIndex === index
    // Display Text deligator
    contentItem: Text {
      text: modelData
      color: CustStyle.accent_text
      font: widget.font
      //font.pixelSize: CustStyle.fsize_normal // already sat.
      elide: Text.ElideRight
      verticalAlignment: Text.AlignVCenter
    }
  }

  //-----------------------------------------------------------------------------
  // The indicator used when making a selection in the ComboBox.
  indicator: Canvas {
    id: canvas
    x: widget.width - width - widget.rightPadding
    y: widget.topPadding + (widget.availableHeight - height) / 2
    width: 12
    height: 8
    contextType: "2d"
    renderStrategy: Canvas.Immediate
    // Attach to redraw when ever the ComboBox is interacted with
    Connections {
      target: widget
      function onPressedChanged() { 
        canvas.requestPaint()
      }
    }
    // Draw operation for drop indicator cavas
    onPaint: {
      var ctx = getContext("2d");
      ctx.reset();
      ctx.moveTo(0, 0);
      ctx.lineTo(width, 0);
      ctx.lineTo(width / 2, height);
      ctx.closePath();
      ctx.fillStyle = widget.pressed ? CustStyle.accent_active : CustStyle.accent_fill
      ctx.fill();
    }
  }

  //-----------------------------------------------------------------------------
  // Text showing current selection.
  contentItem: Text {
    leftPadding: 4
    rightPadding: widget.indicator.width + widget.spacing

    text: widget.displayText
    font: widget.font
    //font.pixelSize: CustStyle.fsize_normal // already sat.
    color: widget.pressed ? CustStyle.accent_active : CustStyle.accent_fill
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
  }

  background: Rectangle {
    implicitWidth: 120
    implicitHeight: 40
    border.color: widget.pressed ? CustStyle.accent_active : CustStyle.accent_fill
    border.width: widget.visualFocus ? 2 : 1
    radius: 2
  }

  //-----------------------------------------------------------------------------
  // Menu that shows when clicked for selection.
  popup: Popup {
    y: widget.height - 1
    width: widget.width
    implicitHeight: contentItem.implicitHeight
    padding: 1
    // What items in the drop list look like
    contentItem: ListView {
      clip: true
      implicitHeight: contentHeight
      model: widget.popup.visible ? widget.delegateModel : null
      currentIndex: widget.highlightedIndex
      // for long display lists provide a scrollbar
      ScrollIndicator.vertical: ScrollIndicator { }
    }
    // BG fill
    background: Rectangle {
      border.color: CustStyle.accent_fill
      radius: 2
    }
  }
}