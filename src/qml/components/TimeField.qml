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
        color: "#333"
        horizontalAlignment: Text.AlignHCenter
    }

    TextField {
        text: root.value
        readOnly: true
        implicitWidth: root.fieldWidth
        color: "#333"
        font.pixelSize: 11
        font.family: "Consolas, Monaco, 'Liberation Mono', 'Courier New', monospace"
        font.letterSpacing: 0
        horizontalAlignment: TextInput.AlignHCenter
        background: Rectangle {
            color: "#f8f9fa"
            border.color: "#ced4da"
            border.width: 1
            radius: 3
        }
        ToolTip.text: root.tooltipText
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
}
