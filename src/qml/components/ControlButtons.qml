import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * ControlButtons - Simulation control buttons component
 * 
 * This component provides Run/Hold, Reset, and Step buttons for simulation control.
 * It handles the visual state changes and communicates actions via signals.
 */
RowLayout {
    id: root
    spacing: 10
    
    // Properties for simulation state
    property bool isRunning: false
    
    // Signals for button actions
    signal toggleSimulationRequested()
    signal resetSimulationRequested()
    signal stepSimulationRequested()
    
    Button {
        id: runButton
        text: root.isRunning ? "Hold" : "Run"
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 80
        Layout.preferredHeight: 25
        background: Rectangle {
            color: {
                if (parent.pressed)
                    return root.isRunning ? "#2563eb" : "#059669";
                return root.isRunning ? "#3b82f6" : "#10b981";
            }
            radius: 4
            border.color: root.isRunning ? "#1d4ed8" : "#047857"
            border.width: 1
        }
        contentItem: Text {
            text: parent.text
            color: "black"
            font.pixelSize: 12
            font.bold: root.isRunning
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            console.log("Toggle simulation button clicked");
            root.toggleSimulationRequested();
        }
    }

    Button {
        id: resetButton
        text: "Reset"
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 80
        Layout.preferredHeight: 25
        background: Rectangle {
            color: parent.pressed ? "#dc2626" : "#ef4444"
            radius: 4
            border.color: "#b91c1c"
            border.width: 1
        }
        contentItem: Text {
            text: parent.text
            color: "white"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            console.log("Reset button clicked");
            root.resetSimulationRequested();
        }
    }

    Button {
        id: stepButton
        text: "Step"
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 80
        Layout.preferredHeight: 25
        background: Rectangle {
            color: parent.pressed ? "#0891b2" : "#06b6d4"
            radius: 4
            border.color: "#0e7490"
            border.width: 1
        }
        contentItem: Text {
            text: parent.text
            color: "white"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            console.log("Step button clicked");
            root.stepSimulationRequested();
        }
    }
}
