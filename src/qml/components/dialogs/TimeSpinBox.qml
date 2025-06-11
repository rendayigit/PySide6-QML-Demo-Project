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
        color: "#333"
    }

    // SpinBox
    SpinBox {
        id: spinBox
        from: root.minimumValue
        to: root.maximumValue
        value: root.currentValue
        implicitWidth: root.spinBoxWidth
        editable: true
        
        background: Rectangle {
            color: "#ffffff"
            border.color: "#ced4da"
            border.width: 1
            radius: 3
        }
        
        contentItem: TextInput {
            text: spinBox.textFromValue(spinBox.value, spinBox.locale)
            font.pixelSize: 12
            color: "#333"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            readOnly: !spinBox.editable
            validator: spinBox.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }
        
        up.indicator: Rectangle {
            x: spinBox.mirrored ? 0 : parent.width - width
            height: parent.height / 2
            implicitWidth: 20
            implicitHeight: 10
            color: spinBox.up.pressed ? "#e6e6e6" : "#f8f9fa"
            border.color: "#ced4da"
            border.width: 1
            
            Text {
                text: "▲"
                font.pixelSize: 8
                color: "#333"
                anchors.centerIn: parent
            }
        }
        
        down.indicator: Rectangle {
            x: spinBox.mirrored ? 0 : parent.width - width
            y: parent.height / 2
            height: parent.height / 2
            implicitWidth: 20
            implicitHeight: 10
            color: spinBox.down.pressed ? "#e6e6e6" : "#f8f9fa"
            border.color: "#ced4da"
            border.width: 1
            
            Text {
                text: "▼"
                font.pixelSize: 8
                color: "#333"
                anchors.centerIn: parent
            }
        }
    }
}
