import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../components" // Import CustomButton from components directory

/**
 * Controls - Simulation control buttons component
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
    signal toggleSimulationRequested
    signal resetSimulationRequested
    signal stepSimulationRequested

    // Run/Hold Button
    CustomButton {
        id: runButton
        buttonText: root.isRunning ? "Hold" : "Run"
        normalColor: root.isRunning ? "#3b82f6" : "#10b981"
        pressedColor: root.isRunning ? "#2563eb" : "#059669"
        borderColor: root.isRunning ? "#1d4ed8" : "#047857"
        textColor: "black"
        boldText: root.isRunning
        useLayoutAlignment: true

        onClicked: {
            root.toggleSimulationRequested();
        }
    }

    // Reset Button
    CustomButton {
        id: resetButton
        buttonText: "Reset"
        normalColor: "#ef4444"
        pressedColor: "#dc2626"
        borderColor: "#b91c1c"
        textColor: "white"
        useLayoutAlignment: true

        onClicked: {
            root.resetSimulationRequested();
        }
    }

    // Step Button
    CustomButton {
        id: stepButton
        buttonText: "Step"
        normalColor: "#06b6d4"
        pressedColor: "#0891b2"
        borderColor: "#0e7490"
        textColor: "white"
        useLayoutAlignment: true

        onClicked: {
            root.stepSimulationRequested();
        }
    }
}
