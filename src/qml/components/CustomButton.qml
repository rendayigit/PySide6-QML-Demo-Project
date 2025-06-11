import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * CustomButton - Universal reusable button component
 *
 * A standardized button.
 * Supports customizable colors, text, sizing, layout behavior, and positioning.
 * Can be used for dialogs, controls, and any other button needs.
 */
Button {
    id: root

    // Text and styling properties
    property string buttonText: ""
    property string normalColor: "#06b6d4"
    property string pressedColor: "#0891b2"
    property string borderColor: "#0e7490"
    property string textColor: "white"
    property bool boldText: false

    // Size properties
    property int buttonWidth: 80
    property int buttonHeight: 25

    // Layout properties (for control buttons)
    property bool useLayoutAlignment: false
    property int layoutAlignment: Qt.AlignVCenter

    // Position properties (for dialog buttons when not using layout)
    property int posX: 0
    property int posY: 0

    // Set button properties
    text: root.buttonText
    implicitWidth: root.buttonWidth
    implicitHeight: root.buttonHeight

    // Apply position if not using layout
    x: root.useLayoutAlignment ? 0 : root.posX
    y: root.useLayoutAlignment ? 0 : root.posY

    // Apply layout properties only if requested
    Layout.alignment: root.useLayoutAlignment ? root.layoutAlignment : undefined
    Layout.preferredWidth: root.useLayoutAlignment ? root.buttonWidth : undefined
    Layout.preferredHeight: root.useLayoutAlignment ? root.buttonHeight : undefined

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
