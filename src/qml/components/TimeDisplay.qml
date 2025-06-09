import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * TimeDisplay - Time information display component
 * 
 * This component displays multiple time values: Simulation Time, Mission Time, 
 * Epoch Time, and Zulu Time in a horizontal layout with labels.
 */
RowLayout {
    id: root
    spacing: 15
    
    // Properties for time values - bound to backend
    property string simulationTime: "-"
    property string missionTime: "-"
    property string epochTime: "-"
    property string zuluTime: "-"
    
    // Simulation Time
    ColumnLayout {
        spacing: 2
        Text {
            text: "Simulation Time (s)"
            font.pixelSize: 10
            color: "#333"
            horizontalAlignment: Text.AlignHCenter
        }
        TextField {
            id: simTimeDisplay
            text: root.simulationTime
            readOnly: true
            implicitWidth: 130
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
            ToolTip.text: "Simulation elapsed time in seconds"
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
    }

    // Mission Time
    ColumnLayout {
        spacing: 2
        Text {
            text: "Mission Time"
            font.pixelSize: 10
            color: "#333"
            horizontalAlignment: Text.AlignHCenter
        }
        TextField {
            id: missionTimeDisplay
            text: root.missionTime
            readOnly: true
            implicitWidth: 130
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
            ToolTip.text: "Mission elapsed time"
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
    }

    // Epoch Time
    ColumnLayout {
        spacing: 2
        Text {
            text: "Epoch Time"
            font.pixelSize: 10
            color: "#333"
            horizontalAlignment: Text.AlignHCenter
        }
        TextField {
            id: epochTimeDisplay
            text: root.epochTime
            readOnly: true
            implicitWidth: 130
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
            ToolTip.text: "Time since epoch"
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
    }

    // Zulu Time
    ColumnLayout {
        spacing: 2
        Text {
            text: "Zulu Time"
            font.pixelSize: 10
            color: "#333"
            horizontalAlignment: Text.AlignHCenter
        }
        TextField {
            id: zuluTimeDisplay
            text: root.zuluTime
            readOnly: true
            implicitWidth: 130
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
            ToolTip.text: "Wall clock time (UTC + 0)"
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
    }
}
