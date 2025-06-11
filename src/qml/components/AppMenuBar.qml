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
    signal toggleSimulationRequested
    signal resetSimulationRequested
    signal stepSimulationRequested
    signal progressDialogRequested
    signal scaleDialogRequested
    signal clearVariableTableRequested
    signal quitRequested

    Menu {
        title: "&File"

        MenuItem {
            text: "Simulator Controls"
            onTriggered:
            //TODO: Implement
            {}
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
                root.progressDialogRequested();
            }
        }
        MenuItem {
            text: "Store"
            onTriggered:
            //TODO: Implement
            {}
        }
        MenuItem {
            text: "Restore"
            onTriggered:
            //TODO: Implement
            {}
        }
        MenuItem {
            text: "Rate"
            onTriggered: {
                root.scaleDialogRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "Settings"
            onTriggered:
            //TODO: Implement
            {}
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
            text: "&Plot Selected Variables\tCtrl+P"
            onTriggered:
            //TODO: Implement
            {}
        }
        MenuSeparator {}
        MenuItem {
            text: "&Save Variables"
            onTriggered:
            //TODO: Implement
            {}
        }
        MenuItem {
            text: "&Load Variables"
            onTriggered:
            //TODO: Implement
            {}
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
            onTriggered:
            //TODO: Implement
            {}
        }
        MenuItem {
            text: "&About"
            onTriggered:
            //TODO: Implement
            {}
        }
    }
}
