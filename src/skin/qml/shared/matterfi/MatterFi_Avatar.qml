import QtQuick 2.15
import QtQuick.Controls.Universal 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.15



import "qrc:/styling"

//-----------------------------------------------------------------------------
Item {
    id: widget

    property string avatarUrl: "http://matterfi.com/assets/images/svg/Matterfi-normal.svg"
    property color bgcolor: "transparent"
    property var objectName: ""

    property int leftPadding: 0
    property int rightPadding: 0

    //-----------------------------------------------------------------------------
    Rectangle {
        id: body
        width: widget.width
        height: widget.height
        color: widget.bgcolor

        Image {
            id: defaultPlaceholderImage
            width: body.width
            height: body.height
            sourceSize.width: body.width
            sourceSize.height: body.height
            source: "qrc:/assets/svgs/Matterfi-normal.svg"
            fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
            smooth: true

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }

            anchors.leftMargin: widget.leftPadding
            anchors.rightMargin: widget.rightPadding
        }
        //----------------------
        // Retrive the Avatar, then draw it:
        // https://doc.qt.io/qt-5/qml-qtquick-image.html#fillMode-prop
        // https://doc.qt.io/qt-5.12/qtqml-documents-networktransparency.html
        Image {
            id: avatarImage
            property string imgUrl: widget.avatarUrl.trim()
            source: imgUrl
            width: body.width
            height: body.height
            sourceSize.width: body.width
            sourceSize.height: body.height
            fillMode: Image.PreserveAspectFit //Image.PreserveAspectCrop
            smooth: true

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }

            onCacheChanged: {
                if (widget.avatarUrl.length > 0) {
                    defaultPlaceholderImage.visible = false
                }
            }
        }
        //----------------------
        // Rounding image mask used
        Rectangle {
            id: mask
            width: 240
            height: 240
            radius: width / 2
            visible: false
        }
    }
}
