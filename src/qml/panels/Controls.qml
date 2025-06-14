import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

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
        normalColor: root.isRunning ? ThemeManager.buttonBackground : ThemeManager.successColor
        pressedColor: root.isRunning ? ThemeManager.buttonPressed : ThemeManager.successColor
        borderColor: root.isRunning ? ThemeManager.borderColor : ThemeManager.successColor
        textColor: ThemeManager.buttonText
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
        normalColor: ThemeManager.errorColor
        pressedColor: ThemeManager.errorColor
        borderColor: ThemeManager.errorColor
        textColor: ThemeManager.buttonText
        useLayoutAlignment: true

        onClicked: {
            root.resetSimulationRequested();
        }
    }

    // Step Button
    CustomButton {
        id: stepButton
        buttonText: "Step"
        normalColor: ThemeManager.buttonBackground
        pressedColor: ThemeManager.buttonPressed
        borderColor: ThemeManager.borderColor
        textColor: ThemeManager.buttonText
        useLayoutAlignment: true

        onClicked: {
            root.stepSimulationRequested();
        }
    }
}
