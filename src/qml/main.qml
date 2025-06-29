pragma ComponentBehavior: Bound

import QtQuick
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "services"
import "panels"
import "windows"

/**
 * Galactron GUI - Main Application Window
 *
 * This is the main application window that orchestrates all components:
 * - Menu bar with simulation controls
 * - Control buttons panel with time displays
 * - Model tree, variable table, and event log panels
 */
ApplicationWindow {
    id: root

    readonly property int min_width: 1200
    readonly property int min_height: 700

    title: "Galactron Simulation Control"

    visible: true
    width: min_width
    height: min_height

    minimumWidth: root.min_width - 250
    minimumHeight: root.min_height - 300

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
            root.currentSimTime = simTime;
        }

        function onSimulationStatusChanged(isRunning) {
            root.isRunning = isRunning;
        }

        function onStatusTextChanged(statusText) {
            root.statusText = statusText;
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
                    var data = variableData || {};
                    variableTable.model.setProperty(i, "value", data.value || "");
                    variableTable.model.setProperty(i, "type", data.type || "");
                    variableTable.model.setProperty(i, "description", data.description || "");
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

        // Simulation control handlers (grouped for clarity)
        onToggleSimulationRequested: simulationController.handleToggleSimulation()
        onResetSimulationRequested: simulationController.handleResetSimulation()
        onStepSimulationRequested: simulationController.handleStepSimulation()

        // Window control handlers
        onProgressWindowRequested: simulationController.handleOpenProgressWindow(progressWindow)
        onScaleWindowRequested: simulationController.handleOpenScaleWindow(scaleWindow)
        onSettingsRequested: simulationController.handleOpenSettingsWindow(settingsWindow)
        onPlotWindowRequested: openPlotWindow()

        // Application control handlers
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
            Layout.preferredHeight: 70
            color: ThemeManager.windowBackground

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // Control Buttons
                Controls {
                    id: controlButtons
                    isRunning: root.isRunning

                    // Simulation control handlers (same as menu bar for consistency)
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
                    onPlotVariablesRequested: function (variablePaths) {
                        handlePlotVariables(variablePaths);
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
            Layout.preferredHeight: 30
            color: ThemeManager.titleBarBackground
            border.color: ThemeManager.border
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: root.statusText
                font.pixelSize: 12
                color: ThemeManager.componentForeground
            }
        }
    }

    // Window Components
    ProgressWindow {
        id: progressWindow
        onProgressSimulationRequested: function (totalMilliseconds) {
            simulationController.handleProgressSimulation(totalMilliseconds);
        }
        onWindowCloseRequested: simulationController.handleCloseWindow(progressWindow)
    }

    ScaleWindow {
        id: scaleWindow
        onScaleSimulationRequested: function (scaleValue) {
            simulationController.handleScaleSimulation(scaleValue);
        }
        onWindowCloseRequested: simulationController.handleCloseWindow(scaleWindow)
    }

    SettingsWindow {
        id: settingsWindow

        onSettingsApplied: {
            console.log("Settings applied - Theme:", settingsWindow.selectedTheme);
            // Apply theme through ThemeManager
            ThemeManager.setTheme(settingsWindow.selectedTheme);

            // Update plot themes
            if (backend && backend.plotting) {
                backend.plotting.set_theme(settingsWindow.selectedTheme);
            }
        }

        onSettingsCanceled: {
            console.log("Settings canceled");
            // Reset to current theme
            settingsWindow.selectedTheme = ThemeManager.getCurrentTheme();
        }
    }

    PlotWindow {
        id: plotWindow
        backendInstance: backend
    }

    // Initialize plot themes when component is completed
    Component.onCompleted: {
        // Set initial plot theme to match current theme
        if (backend && backend.plotting) {
            backend.plotting.set_theme(ThemeManager.getCurrentTheme());
        }
    }

    // Plotting functions
    function handlePlotVariables(variablePaths) {
        console.log("Creating plot for variables:", variablePaths);
        if (backend && backend.plotting) {
            var plotId = backend.plotting.create_plot(variablePaths, "", "Time", "Value");
            console.log("Created plot with ID:", plotId);
        }
    }

    function openPlotWindow() {
        plotWindow.show();
        plotWindow.raise();
        plotWindow.requestActivate();
    }
}
