import QtQuick

/**
 * SimulationController - Centralized backend interaction controller
 *
 * This component handles all backend interactions and simulation control logic.
 * It provides a clean separation between UI components and backend operations.
 */
QtObject {
    id: controller

    // Reference to the backend (injected from parent)
    property var backendInstance: null

    // Current simulation state (for local tracking)
    property bool isRunning: backendInstance ? backendInstance.is_running : false
    property string currentSimTime: backendInstance ? backendInstance.simulation_time : "0.00"
    property string statusText: backendInstance ? backendInstance.status_text : "Simulator ready"

    // Simulation Control Functions
    function handleToggleSimulation() {
        backendInstance.toggle_simulation();
    }

    function handleResetSimulation() { // TODO: Implement
    }

    function handleStepSimulation() {
        backendInstance.step_simulation();
    }

    function handleProgressSimulation(totalMilliseconds) {
        backendInstance.progress_simulation(totalMilliseconds.toString());
    }

    function handleAddVariableToWatch(variablePath, variableName) {
        backendInstance.add_variable_to_watch(variablePath, variableName);
    }

    function handleRemoveVariableFromWatch(variablePath) {
        backendInstance.remove_variable_from_watch(variablePath);
    }

    function handleRemoveMultipleVariables(variablePaths) {
        for (var i = 0; i < variablePaths.length; i++) {
            handleRemoveVariableFromWatch(variablePaths[i]);
        }
    }

    function handleClearVariableTable() {
        backendInstance.clear_variable_table();
    }

    function handleOpenProgressDialog(dialogRef) {
        if (dialogRef) {
            dialogRef.open();
        }
    }

    function handleOpenScaleDialog(dialogRef) {
        if (dialogRef) {
            dialogRef.open();
        }
    }

    function handleCloseDialog(dialogRef) {
        if (dialogRef) {
            dialogRef.close();
        }
    }

    function handleQuitApplication() {
        Qt.quit();
    }
}
