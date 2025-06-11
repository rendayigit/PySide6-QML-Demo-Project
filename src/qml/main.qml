import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "components/time"
import "components/controls"
import "dialogs"

/**
 * Galactron GUI - Main Application Window
 *
 * This is the main application window that orchestrates all components:
 * - Menu bar with simulation controls
 * - Control buttons panel with time displays
 * - Model tree, variable table, and event log panels
 * - Dialog components for advanced operations
 */
ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 700
    title: "Galactron GUI - Simulator Control"

    // Simulation state properties - bound to backend
    property bool isRunning: backend ? backend.is_running : false
    property string currentSimTime: backend ? backend.simulation_time : "0.000"
    property string statusText: backend ? backend.status_text : "Simulator ready"
    property bool commandInProgress: false

    // Simulation Controller - Centralized backend interaction
    SimulationController {
        id: simulationController
        backendInstance: backend
    }

    // Connect to backend signals for real-time updates
    Connections {
        target: backend
        function onSimulationTimeChanged() {
            window.currentSimTime = backend.simulation_time;
        }
        function onMissionTimeChanged() {
        // Mission time is automatically updated via binding
        }
        function onEpochTimeChanged() {
        // Epoch time is automatically updated via binding
        }
        function onZuluTimeChanged() {
        // Zulu time is automatically updated via binding
        }
        function onSimulationStatusChanged() {
            window.isRunning = backend.is_running;
        }
        function onStatusTextChanged() {
            window.statusText = backend.status_text;
        }
        function onEventLogReceived(level, message) {
            eventLog.model.append({
                "level": level,
                "log": message
            });
        }
        function onModelTreeUpdated(treeData) {
            modelTree.model.clear();
            for (var i = 0; i < treeData.length; i++) {
                modelTree.model.append(treeData[i]);
            }
        }
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
        function onCommandExecuted(commandName, success) {
            if (success) {
                console.log(commandName + " command executed successfully");
            } else {
                console.log(commandName + " command failed");
            }
        }
    }

    // Menu Bar Component
    menuBar: AppMenuBar {
        id: menuBar
        onToggleSimulationRequested: simulationController.handleToggleSimulation()
        onResetSimulationRequested: simulationController.handleResetSimulation()
        onStepSimulationRequested: simulationController.handleStepSimulation()
        onProgressDialogRequested: simulationController.handleOpenProgressDialog(progressDialog)
        onScaleDialogRequested: simulationController.handleOpenScaleDialog(scaleDialog)
        onClearVariableTableRequested: simulationController.handleClearVariableTable()
        onQuitRequested: simulationController.handleQuitApplication()
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
                    onToggleSimulationRequested: simulationController.handleToggleSimulation()
                    onResetSimulationRequested: simulationController.handleResetSimulation()
                    onStepSimulationRequested: simulationController.handleStepSimulation()
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
                    onClearTableRequested: simulationController.handleClearVariableTable()
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

    // Dialog Components
    ProgressDialog {
        id: progressDialog
        onProgressSimulationRequested: function(totalMilliseconds) {
            var success = simulationController.handleProgressSimulation(totalMilliseconds);
            if (success) {
                simulationController.handleCloseDialog(progressDialog);
            }
        }
        onDialogCloseRequested: {
            simulationController.handleCloseDialog(progressDialog);
        }
    }

    ScaleDialog {
        id: scaleDialog
    }
}
