import QtQuick
import QtQuick.Controls

/**
 * GalactronMenuBar - Application menu bar with simulation controls
 * 
 * This component provides the main application menu with File, Variable Display, and Help menus.
 * It includes simulation control actions and variable management operations.
 */
MenuBar {
    id: root
    
    // Signal properties for communication with main window
    signal toggleSimulationRequested()
    signal resetSimulationRequested()
    signal stepSimulationRequested()
    signal progressDialogRequested()
    signal scaleDialogRequested()
    signal clearVariableTableRequested()
    signal quitRequested()
    
    Menu {
        title: "&File"

        MenuItem {
            text: "Simulator Controls"
            onTriggered: console.log("Simulator Controls menu")
        }
        MenuItem {
            text: "&Run/Hold\tCtrl+R"
            onTriggered: {
                console.log("Menu Run/Hold triggered");
                root.toggleSimulationRequested();
            }
        }
        MenuItem {
            text: "Reset\tCtrl+X"
            onTriggered: {
                console.log("Reset from menu");
                root.resetSimulationRequested();
            }
        }
        MenuItem {
            text: "Step"
            onTriggered: {
                console.log("Menu Step triggered");
                root.stepSimulationRequested();
            }
        }
        MenuItem {
            text: "Progress Simulation"
            onTriggered: {
                console.log("Progress Simulation menu triggered");
                root.progressDialogRequested();
            }
        }
        MenuItem {
            text: "Store"
            onTriggered: console.log("Store")
        }
        MenuItem {
            text: "Restore"
            onTriggered: console.log("Restore")
        }
        MenuItem {
            text: "Rate"
            onTriggered: {
                console.log("Rate menu triggered");
                root.scaleDialogRequested();
            }
        }
        MenuSeparator {}
        MenuItem {
            text: "Settings"
            onTriggered: console.log("Settings")
        }
        MenuSeparator {}
        MenuItem {
            text: "&Quit\tCtrl+Q"
            onTriggered: root.quitRequested()
        }
    }

    Menu {
        title: "&Variable Display"

        MenuItem {
            text: "&Plot Selected Variables\tCtrl+P"
            onTriggered: console.log("Plot Selected Variables")
        }
        MenuSeparator {}
        MenuItem {
            text: "&Save Variables"
            onTriggered: console.log("Save Variables")
        }
        MenuItem {
            text: "&Load Variables"
            onTriggered: console.log("Load Variables")
        }
        MenuSeparator {}
        MenuItem {
            text: "&Clear Table"
            onTriggered: root.clearVariableTableRequested()
        }
    }

    Menu {
        title: "&Help"

        MenuItem {
            text: "&Manual\tF1"
            onTriggered: console.log("Manual")
        }
        MenuItem {
            text: "&About"
            onTriggered: console.log("About Galactron")
        }
    }
}
