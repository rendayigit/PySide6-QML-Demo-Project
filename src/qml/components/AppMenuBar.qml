import QtQuick
import QtQuick.Controls

/**
 * AppMenuBar - Application menu bar with simulation controls
 *
 * This component provides the main application menu with File, Variable Display, and Help menus.
 * It includes simulation control actions and variable management operations.
 */
MenuBar {
    id: root

    // Signal properties for communication with main window
    signal simulatorControlsRequested  // TODO: Implement
    signal toggleSimulationRequested
    signal resetSimulationRequested  // TODO: Implement
    signal stepSimulationRequested
    signal progressWindowRequested
    signal storeSimulationRequested  // TODO: Implement
    signal restoreSimulationRequested  // TODO: Implement
    signal scaleWindowRequested
    signal settingsRequested  // TODO: Implement
    signal quitRequested
    signal plotSelectedVariablesRequested  // TODO: Implement
    signal saveVariablesRequested  // TODO: Implement
    signal loadVariablesRequested  // TODO: Implement
    signal clearVariableTableRequested
    signal helpManualRequested  // TODO: Implement
    signal aboutRequested // TODO: Implement

    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+R"
        onActivated: {
            root.toggleSimulationRequested();
        }
    }

    Shortcut {
        sequence: "Ctrl+X"
        onActivated: {
            root.resetSimulationRequested();
        }
    }

    Shortcut {
        sequence: "Ctrl+P"
        onActivated: {
            root.plotSelectedVariablesRequested();
        }
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: {
            root.quitRequested();
        }
    }

    Shortcut {
        sequence: "F1"
        onActivated: {
            root.helpManualRequested();
        }
    }

    Menu {
        title: "&File"

        MenuItem {
            text: "Simulator Controls"
            onTriggered: {
                root.simulatorControlsRequested();
            }
        }
        MenuItem {
            text: "&Run/Hold\tCtrl+R"
            onTriggered: {
                root.toggleSimulationRequested();
            }
        }
        MenuItem {
            text: "Reset\tCtrl+X"
            onTriggered: {
                root.resetSimulationRequested();
            }
        }
        MenuItem {
            text: "Step"
            onTriggered: {
                root.stepSimulationRequested();
            }
        }
        MenuItem {
            text: "Progress Simulation"
            onTriggered: {
                root.progressWindowRequested();
            }
        }
        MenuItem {
            text: "Store"
            onTriggered: {
                root.storeSimulationRequested();
            }
        }
        MenuItem {
            text: "Restore"
            onTriggered: {
                root.restoreSimulationRequested();
            }
        }
        MenuItem {
            text: "Rate"
            onTriggered: {
                root.scaleWindowRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "Settings"
            onTriggered: {
                root.settingsRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "&Quit\tCtrl+Q"
            onTriggered: {
                root.quitRequested();
            }
        }
    }

    Menu {
        title: "&Variable Display"

        MenuItem {
            text: "&Plot Selected\tCtrl+P" //TODO: Name too long
            onTriggered: {
                root.plotSelectedVariablesRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "&Save Variables"
            onTriggered: {
                root.saveVariablesRequested();
            }
        }
        MenuItem {
            text: "&Load Variables"
            onTriggered: {
                root.loadVariablesRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "&Clear Table"
            onTriggered: {
                root.clearVariableTableRequested();
            }
        }
    }

    Menu {
        title: "&Help"

        MenuItem {
            text: "&Manual\tF1"
            onTriggered: {
                root.helpManualRequested();
            }
        }
        MenuItem {
            text: "&About"
            onTriggered: {
                root.aboutRequested();
            }
        }
    }
}
