import QtQuick
import QtQuick.Controls

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
    property string backgroundColor: "#e5e7eb"
    property string borderColor: "#d1d5db"
    property string selectedIndicatorColor: "#f3f4f6"
    property string selectedIndicatorBorder: "#d1d5db"
    property string selectedIndicatorColorRight: "#374151"
    property string selectedIndicatorBorderRight: "#1f2937"
    property string selectedTextColor: "#374151"
    property string unselectedTextColor: "#9ca3af"
    property string selectedTextColorRight: "#f3f4f6"

    // Signals
    signal optionToggled(bool isRightSelected)

    // Background rectangle
    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: 1

        // Animated sliding indicator
        Rectangle {
            id: indicator
            width: parent.width / 2
            height: parent.height - 4
            radius: height / 2
            color: root.isRightSelected ? root.selectedIndicatorColorRight : root.selectedIndicatorColor
            border.color: root.isRightSelected ? root.selectedIndicatorBorderRight : root.selectedIndicatorBorder
            border.width: 1
            y: 2

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            Behavior on border.color {
                ColorAnimation { duration: 200 }
            }

            x: root.isRightSelected ? parent.width / 2 : 2
        }

        // Left option text
        Text {
            id: leftLabel
            text: root.leftText
            font.pixelSize: 11
            font.bold: !root.isRightSelected
            color: root.isRightSelected ? root.unselectedTextColor : root.selectedTextColor
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Right option text
        Text {
            id: rightLabel
            text: root.rightText
            font.pixelSize: 11
            font.bold: root.isRightSelected
            color: root.isRightSelected ? root.selectedTextColorRight : root.unselectedTextColor
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 200 }
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
