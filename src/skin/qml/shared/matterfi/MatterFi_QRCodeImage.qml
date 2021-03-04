import QtQuick 2.15
import QtQml.Models 2.1
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12

import QtGraphicalEffects 1.12

import "qrc:/styling"
import "qrc:/styling/cust_formaters"
import "qrc:/qml_shared"

//-----------------------------------------------------------------------------
// Delegate for QR Code display objects. Turns strings into svg images.
//-----------------------------------------------------------------------------
Rectangle {
  id: svg_body
  width: 150
  height: 150
  color: "transparent"

  //-----------------------------------------------------------------------------
  // Set the Image to the byte array generated from the svg xml QString.
  property var qrCodebase64: undefined // data:image/svg;base64,
  function set_display_string(from_string) {
    
    // TODO: should QRcode function be part of 'app' the qml.cpp functions?
    var base64_QString = otwrap.getQRcodeBase64(from_string)

    svg_body.qrCodebase64 = "data:image/svg;base64," + base64_QString
    //console.log("QRCode Image, set base64:", svg_body.qrCodebase64)
  }

  //-----------------------------------------------------------------------------
  // Draw the SVG:
  Image {
    id: svgImage
    width: svg_body.width
    height: svg_body.height
    sourceSize.width: svg_body.width
    sourceSize.height: svg_body.height
    anchors.horizontalCenter: svg_body.horizontalCenter
    anchors.verticalCenter: svg_body.verticalCenter
    source: ( svg_body.qrCodebase64 === undefined ? "" : svg_body.qrCodebase64 )
    fillMode: Image.PreserveAspectFit
    mipmap: true
    smooth: false
  }
  // Color the 'fill' of the SVG image, only if there is an alpha channel
  //ColorOverlay {
  //  anchors.fill: svgImage
  //  source: svgImage
  //  color: "white"
  //}

//-----------------------------------------------------------------------------
}//end 'svg_body'