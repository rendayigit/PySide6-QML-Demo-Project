import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

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
        normalColor: root.isRunning ? ThemeManager.primaryButtonBg : ThemeManager.successColor
        pressedColor: root.isRunning ? ThemeManager.primaryButtonBgPressed : ThemeManager.successColorPressed
        borderColor: root.isRunning ? ThemeManager.focusBorderColor : ThemeManager.successColorBorder
        textColor: ThemeManager.primaryButtonText
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
        pressedColor: ThemeManager.errorColorPressed
        borderColor: ThemeManager.errorColorBorder
        textColor: ThemeManager.primaryButtonText
        useLayoutAlignment: true

        onClicked: {
            root.resetSimulationRequested();
        }
    }

    // Step Button
    CustomButton {
        id: stepButton
        buttonText: "Step"
        normalColor: ThemeManager.primaryButtonBg
        pressedColor: ThemeManager.primaryButtonBgPressed
        borderColor: ThemeManager.focusBorderColor
        textColor: ThemeManager.primaryButtonText
        useLayoutAlignment: true

        onClicked: {
            root.stepSimulationRequested();
        }
    }
}
