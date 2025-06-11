import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * ControlButton - Reusable control button component
 *
 * A standardized button with customizable colors, text, and click handling.
 */
Button {
    id: root

    // Properties
    property string buttonText: ""
    property string normalColor: "#06b6d4"
    property string pressedColor: "#0891b2"
    property string borderColor: "#0e7490"
    property string textColor: "white"
    property bool boldText: false
    property int buttonWidth: 80
    property int buttonHeight: 25

    // Set button properties
    text: root.buttonText
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: root.buttonWidth
    Layout.preferredHeight: root.buttonHeight

    background: Rectangle {
        color: parent.pressed ? root.pressedColor : root.normalColor
        radius: 4
        border.color: root.borderColor
        border.width: 1
    }

    contentItem: Text {
        text: parent.text
        color: root.textColor
        font.pixelSize: 12
        font.bold: root.boldText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
