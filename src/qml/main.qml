import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"      // Reusable components
import "panels"          // Main window panels
import "windows"         // Separate windows/dialogs

/**
 * Galactron GUI - Main Application Window
 *
 * This is the main application window that orchestrates all components:
 * - Menu bar with simulation controls
 * - Control buttons panel with time displays
 * - Model tree, variable table, and event log panels
 */
ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 700
    title: "Galactron GUI - Simulator Control"

    // Simulation state properties
    property bool isRunning: false
    property string currentSimTime: "0.00"
    property string statusText: "Simulator ready"
    property bool commandInProgress: false

    // Simulation Controller - Centralized backend interaction
    SimulationController {
        id: simulationController
        backendInstance: backend
    }

    // Connect to backend signals for real-time updates
    Connections {
        target: backend
        
        // Time and status updates
        function onSimulationTimeChanged(simTime) {
            window.currentSimTime = simTime;
        }
        
        function onSimulationStatusChanged(isRunning) {
            window.isRunning = isRunning;
        }
        
        function onStatusTextChanged(statusText) {
            window.statusText = statusText;
        }
        
        // Theme updates
        function onThemeChanged(theme) {
            console.log("Theme changed to:", theme);
            // Update settings window if it's open
            if (settingsWindow.visible) {
                settingsWindow.selectedTheme = settingsWindow.backend?.current_theme || theme;
            }
        }
        
        // Event log updates
        function onEventLogReceived(level, message) {
            eventLog.model.append({
                "level": level,
                "log": message
            });
        }
        
        // Model tree updates
        function onModelTreeUpdated(treeData) {
            modelTree.model.clear();
            for (var i = 0; i < treeData.length; i++) {
                modelTree.model.append(treeData[i]);
            }
        }
        
        // Variable model updates
        function onVariableAdded(variableData) {
            // Ensure the selected property is initialized
            variableData.selected = false;
            variableTable.model.append(variableData);
        }
        
        function onVariableUpdated(variablePath, variableData) {
            // Find and update the variable in the model
            for (var i = 0; i < variableTable.model.count; i++) {
                if (variableTable.model.get(i).variablePath === variablePath) {
                    // Update all properties of the variable
                    variableTable.model.setProperty(i, "value", variableData.value);
                    variableTable.model.setProperty(i, "type", variableData.type);
                    variableTable.model.setProperty(i, "description", variableData.description);
                    break;
                }
            }
        }
        
        function onVariablesCleared() {
            // Clear all variables from the model
            variableTable.model.clear();
        }
        
        function onVariableRemoved(variablePath) {
            // Remove the specific variable from the model
            for (var i = 0; i < variableTable.model.count; i++) {
                if (variableTable.model.get(i).variablePath === variablePath) {
                    variableTable.model.remove(i);
                    break;
                }
            }
        }
    }

    // Menu Bar Component
    menuBar: AppMenuBar {
        id: menuBar

        onToggleSimulationRequested: {
            simulationController.handleToggleSimulation();
        }

        onResetSimulationRequested: {
            simulationController.handleResetSimulation();
        }

        onStepSimulationRequested: {
            simulationController.handleStepSimulation();
        }

        onProgressWindowRequested: {
            simulationController.handleOpenProgressWindow(progressWindow);
        }

        onScaleWindowRequested: {
            simulationController.handleOpenScaleWindow(scaleWindow);
        }

        onSettingsRequested: {
            simulationController.handleOpenSettingsWindow(settingsWindow);
        }

        onClearVariableTableRequested: {
            simulationController.handleClearVariableTable();
        }

        onQuitRequested: {
            simulationController.handleQuitApplication();
        }
    }

    // Main content layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Control Panel with buttons and time displays
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: "#f8f9fa"
            border.color: "#dee2e6"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // Control Buttons
                Controls {
                    id: controlButtons
                    isRunning: window.isRunning

                    onToggleSimulationRequested: {
                        simulationController.handleToggleSimulation();
                    }

                    onResetSimulationRequested: {
                        simulationController.handleResetSimulation();
                    }

                    onStepSimulationRequested: {
                        simulationController.handleStepSimulation();
                    }
                }

                Item {
                    Layout.fillWidth: true
                } // Spacer

                // Time Displays
                TimeDisplay {
                    id: timeDisplay
                    simulationTime: backend ? backend.simulation_time : "-"
                    missionTime: backend ? backend.mission_time : "-"
                    epochTime: backend ? backend.epoch_time : "-"
                    zuluTime: backend ? backend.zulu_time : "-"
                }
            }
        }

        // Main Content Area with Resizable Split Layout
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            // Main left section with simulation models and variables
            SplitView {
                SplitView.fillWidth: true
                orientation: Qt.Horizontal

                // Simulation Models Panel
                ModelTree {
                    id: modelTree
                    SplitView.minimumWidth: 200
                    SplitView.preferredWidth: 300

                    onVariableWatchRequested: function (variablePath, variableName) {
                        simulationController.handleAddVariableToWatch(variablePath, variableName);
                    }
                }

                // Variables Panel
                VariableTable {
                    id: variableTable
                    SplitView.fillWidth: true
                    SplitView.minimumWidth: 400

                    onClearTableRequested: {
                        simulationController.handleClearVariableTable();
                    }

                    onRemoveVariablesRequested: function (variablePaths) {
                        simulationController.handleRemoveMultipleVariables(variablePaths);
                    }
                }
            }

            // Event Logs Panel
            EventLog {
                id: eventLog
                SplitView.minimumWidth: 250
                SplitView.preferredWidth: 350
            }
        }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#f0f0f0"
            border.color: "#dee2e6"
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: window.statusText
                font.pixelSize: 12
                color: "#333"
            }
        }
    }

    // Window Components
    ProgressWindow {
        id: progressWindow

        onProgressSimulationRequested: function (totalMilliseconds) {
            simulationController.handleProgressSimulation(totalMilliseconds);
        }

        onWindowCloseRequested: {
            simulationController.handleCloseWindow(progressWindow);
        }
    }

    ScaleWindow {
        id: scaleWindow

        onScaleSimulationRequested: function (scaleValue) {
            simulationController.handleScaleSimulation(scaleValue);
        }

        onWindowCloseRequested: {
            simulationController.handleCloseWindow(scaleWindow);
        }
    }

    SettingsWindow {
        id: settingsWindow

        onSettingsApplied: {
            console.log("Settings applied - Theme:", settingsWindow.selectedTheme);
            // Apply theme through backend
            if (backend) {
                backend.set_theme(settingsWindow.selectedTheme);
            }
        }

        onSettingsCanceled: {
            console.log("Settings canceled");
            // Reset to current backend theme
            if (backend) {
                settingsWindow.selectedTheme = backend.current_theme;
            }
        }
    }
}
