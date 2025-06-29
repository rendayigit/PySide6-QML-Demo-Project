import QtQuick
import "../services"

/**
 * Switcher - Generic binary toggle switcher component
 *
 * A reusable switcher that toggles between two options with customizable text
 * and colors. Can be used for themes, modes, settings, etc.
 */
Item {
    id: root

    width: 120
    height: 35

    // Properties
    property bool isRightSelected: false
    property string leftText: "Option 1"
    property string rightText: "Option 2"

    // Color customization
    // Themed colors
    property color backgroundColor: ThemeManager.alternativePrimaryComponentBackground
    property color indicatorColor: ThemeManager.primaryComponentBackground
    property color textColor: ThemeManager.alternativePrimaryComponentForeground

    // Signals
    signal optionToggled(bool isRightSelected)

    // Background rectangle
    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2
        color: root.backgroundColor

        // Animated sliding indicator
        Rectangle {
            id: indicator
            width: parent.width / 2
            height: parent.height - 4
            radius: height / 2
            color: root.indicatorColor
            y: 2

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }

            x: root.isRightSelected ? parent.width / 2 - 2 : 2
        }

        // Left option text
        Text {
            id: leftLabel
            text: root.leftText
            font.pixelSize: 11
            color: root.textColor
            anchors.left: parent.left
            anchors.leftMargin: root.width / 5 - 5
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        // Right option text
        Text {
            id: rightLabel
            text: root.rightText
            font.pixelSize: 11
            color: root.textColor
            anchors.right: parent.right
            anchors.rightMargin: root.width / 5 - 5
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        // Mouse area for interaction
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.isRightSelected = !root.isRightSelected;
                root.optionToggled(root.isRightSelected);
            }
        }
    }
}
