import QtQuick
import QtQuick.Controls
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
    property int radius: 4
    property int pixelSize: 12

    // Default size properties
    width: 80
    height: 30

    // Binding implicit size to width and height
    implicitWidth: width
    implicitHeight: height

    background: Rectangle {
        color: {
            if (root.pressed)
                return root.pressedColor;

            if (root.hovered)
                return root.hoveredColor;

            return root.normalColor;
        }

        radius: root.radius
        border.color: root.borderColor
        border.width: 1
    }

    contentItem: Text {
        text: root.buttonText
        color: root.textColor
        font.pixelSize: root.pixelSize
        font.bold: root.boldText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
