import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * TimeSpinBox - Reusable time input spinbox component
 *
 * A standardized spinbox for time input with customizable label, range, and width.
 */
ColumnLayout {
    id: root
    spacing: 5

    // Properties
    property string label: ""
    property int minimumValue: 0
    property int maximumValue: 99
    property int currentValue: 0
    property int spinBoxWidth: 80
    property alias value: spinBox.value

    // Label
    Text {
        text: root.label
        font.pixelSize: 12
        font.bold: true
        color: ThemeManager.primaryText
    }

    // SpinBox
    SpinBox {
        id: spinBox
        from: root.minimumValue
        to: root.maximumValue
        value: root.currentValue
        implicitWidth: root.spinBoxWidth
        editable: true
    }
}
