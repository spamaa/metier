import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.1

import "qrc:/styling"
import "qrc:/qml_components"
import "qrc:/spacedawgs"
//-----------------------------------------------------------------------------
// MatterFi_QRCodeImage.qml
// Delegate for QR Code display objects. Turns strings into svg images.
//-----------------------------------------------------------------------------
Rectangle {
  id: contextRoot
  width: 150
  height: width
  color: "transparent"

  property color primaryColor: "#fff"

  //-----------------------------------------------------------------------------
  // Set the Image to the byte array generated from the svg xml QString.
  property string qrCodeDataString: ""
  property bool raw_utf8: true
  property string rawQRimage: ""
  function set_display_string(from_string) {
    // Generate the QRcode from OT 'api' to display the svg image
    var base64_QString = api.getQRcodeBase64(from_string, contextRoot.raw_utf8)
    if (contextRoot.raw_utf8) {
      // data:image/svg+xml;utf8,
      contextRoot.qrCodeDataString = "data:image/svg+xml;utf8," + base64_QString
      contextRoot.rawQRimage = contextRoot.qrCodeDataString
      contextRoot.changeColor(contextRoot.primaryColor)
      // debugger:
      //console.log("Styling the QR code:", contextRoot.qrCodeDataString)
    } else {
      // data:image/svg;base64,
      contextRoot.qrCodeDataString = "data:image/svg;base64," + base64_QString
      contextRoot.rawQRimage = contextRoot.qrCodeDataString
    }
    //console.log("QRCode Image, set base64:", contextRoot.qrCodeDataString)
  }

  //----------------------
  function changeBGcolor(newcolor) {
    if (newcolor === null) {
      // remove the BG rect from SVG.
      var editedstring = contextRoot.qrCodeDataString.replace(
        /<rect width="100%" height="100%" fill="#FFFFFF"\/>/g, ""
      );
    } else {
      // recolor the BG rect.
      var editedstring = contextRoot.qrCodeDataString.replace(/#FFFFFF/g, newcolor)
    }
    contextRoot.qrCodeDataString = editedstring
  }
  //----------------------
  function changeColor(primecolor, bgcolor = null) {
    contextRoot.qrCodeDataString = contextRoot.rawQRimage
    contextRoot.changeBGcolor(bgcolor)
    var editedstring = contextRoot.qrCodeDataString.replace(/#000000/g, primecolor)
    contextRoot.qrCodeDataString = editedstring
  }

  //-----------------------------------------------------------------------------
  // Draw the SVG:
  Image {
    id: svgImage
    width: contextRoot.width
    height: contextRoot.height
    sourceSize.width: contextRoot.width
    sourceSize.height: contextRoot.height
    anchors.horizontalCenter: contextRoot.horizontalCenter
    anchors.verticalCenter: contextRoot.verticalCenter
    source: contextRoot.qrCodeDataString
    fillMode: Image.PreserveAspectFit
    mipmap: true
    smooth: false
  }

//-----------------------------------------------------------------------------
}//end 'contextRoot'