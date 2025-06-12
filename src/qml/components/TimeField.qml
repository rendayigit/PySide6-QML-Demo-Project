import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * TimeField - Time display field component
 *
 * A standardized time display field with label, text field, and tooltip.
 */
ColumnLayout {
    id: root
    spacing: 2

    // Properties
    property string label: ""
    property string value: "-"
    property string tooltipText: ""
    property int fieldWidth: 150

    Text {
        text: root.label
        font.pixelSize: 10
        color: ThemeManager.primaryText
        horizontalAlignment: Text.AlignHCenter
    }

    TextField {
        text: root.value
        readOnly: true
        implicitWidth: root.fieldWidth
        color: ThemeManager.inputText
        font.pixelSize: 11
        font.family: "Consolas, Monaco, 'Liberation Mono', 'Courier New', monospace"
        font.letterSpacing: 0
        horizontalAlignment: TextInput.AlignHCenter
        background: Rectangle {
            color: ThemeManager.surfaceBackground
            border.color: ThemeManager.inputBorderColor
            border.width: 1
            radius: 3
        }
        ToolTip.text: root.tooltipText
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
}
