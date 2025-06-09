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
                    return root.isRunning ? "#cc6600" : "#e6b800";
                return root.isRunning ? "#ff8800" : "#ffcc00";
            }
            radius: 4
            border.color: root.isRunning ? "#cc6600" : "#d4af37"
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
            color: parent.pressed ? "#cc3636" : "#ff4545"
            radius: 4
            border.color: "#cc3636"
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
            color: parent.pressed ? "#5599cc" : "#66b3ff"
            radius: 4
            border.color: "#4d79a4"
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
