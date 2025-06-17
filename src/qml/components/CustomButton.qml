import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

/**
 * CustomButton - Universal reusable button component
 *
 * A standardized button.
 * Supports customizable colors, text, sizing, layout behavior, and positioning.
 */
Button {
    id: root

    // Text and styling properties
    property string buttonText: "Button"
    property color normalColor: ThemeManager.componentBackground
    property color hoveredColor: ThemeManager.componentHoverBackground
    property color pressedColor: ThemeManager.componentPressedBackground
    property color textColor: ThemeManager.componentForeground
    property color borderColor: ThemeManager.border
    property bool boldText: false

    // Size properties
    property int buttonWidth: 80
    property int buttonHeight: 30

    // Layout properties (for control buttons)
    property bool useLayoutAlignment: false
    property int layoutAlignment: Qt.AlignVCenter

    // Position properties (for buttons when not using layout)
    property int posX: 0
    property int posY: 0

    // Set button properties
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
        color: {
            if (root.pressed)
                return root.pressedColor;
            if (root.hovered)
                return root.hoveredColor;
            return root.normalColor;
        }

        radius: 4
        border.color: root.borderColor
        border.width: 1
    }

    contentItem: Text {
        text: root.buttonText
        color: root.textColor
        font.pixelSize: 12
        font.bold: root.boldText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
