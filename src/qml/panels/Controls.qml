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
        normalColor: root.isRunning ? ThemeManager.warningBackground : ThemeManager.successBackground
        hoveredColor: normalColor.darker(0.8)
        pressedColor: normalColor.darker(1.2)
        borderColor: ThemeManager.border
        textColor: ThemeManager.warningForeground
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
        normalColor: ThemeManager.destructiveBackground
        hoveredColor: ThemeManager.destructiveHoverBackground
        pressedColor: normalColor.darker(1.2)
        borderColor: ThemeManager.border
        textColor: ThemeManager.destructiveForeground
        useLayoutAlignment: true

        onClicked: {
            root.resetSimulationRequested();
        }
    }

    // Step Button
    CustomButton {
        id: stepButton
        buttonText: "Step"
        useLayoutAlignment: true

        onClicked: {
            root.stepSimulationRequested();
        }
    }
}
