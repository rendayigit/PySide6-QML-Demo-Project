pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TreeModels 1.0
import "../services"

/**
 * ModelTree - Official Qt 6.2+ TreeView implementation
 *
 * This component uses the official Qt 6.2+ TreeView component with a proper
 * QAbstractItemModel (TreeModel) from the Python backend for hierarchical data display.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.borderColor
    border.width: 1

    // Signals for communication with backend
    signal variableWatchRequested(string variablePath, string variableName)
    signal allVariablesWatchRequested(string parentPath, int parentIndex)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Text {
            text: "Simulation Models"
            font.pixelSize: 14
            font.bold: true
            color: ThemeManager.primaryText
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Official Qt 6.2+ TreeView component
            TreeView {
                id: treeView
                anchors.fill: parent
                model: backend ? backend.tree_model : null

                delegate: TreeViewDelegate {
                    id: treeDelegate

                    implicitWidth: treeView.width
                    implicitHeight: 25

                    // contentItem: Rectangle {
                    //     color: treeDelegate.hovered ? ThemeManager.controlBackgroundHover : "transparent"

                    //     Text {
                    //         anchors.left: parent.left
                    //         anchors.leftMargin: 25 + (treeDelegate.depth * 20)
                    //         anchors.verticalCenter: parent.verticalCenter
                    //         anchors.right: parent.right
                    //         anchors.rightMargin: 10

                    //         text: treeDelegate.model.display || ""
                    //         font.pixelSize: 12
                    //         color: ThemeManager.primaryText
                    //         font.bold: treeDelegate.depth === 0
                    //         elide: Text.ElideRight
                    //     }

                    //     MouseArea {
                    //         anchors.fill: parent
                    //         acceptedButtons: Qt.LeftButton

                    //         onDoubleClicked: function (mouse) {
                    //             // Get the model index for this item
                    //             var modelIndex = treeView.index(treeDelegate.row, 0, treeDelegate.parent);

                    //             // Access data using Qt.UserRole for fullPath and name
                    //             var fullPath = treeView.model.data(modelIndex, Qt.UserRole) || "";
                    //             var name = treeView.model.data(modelIndex, Qt.DisplayRole) || "";
                    //             var hasChildren = treeView.model.data(modelIndex, Qt.UserRole + 1) || false;

                    //             if (hasChildren) {
                    //                 // Double-click on parent: add all child variables recursively
                    //                 console.log("Adding all variables under:", fullPath);
                    //                 root.addAllVariablesUnder(fullPath);
                    //             } else {
                    //                 // Double-click on leaf: add single variable
                    //                 if (fullPath && fullPath !== "") {
                    //                     console.log("Adding to watch:", fullPath);
                    //                     root.variableWatchRequested(fullPath, name.trim());
                    //                 }
                    //             }
                    //         }
                    //     }
                    // }
                }
            }
        }
    }

    // Helper function to add all variables under a parent path
    function addAllVariablesUnder(parentPath) {
        // This would need to be implemented by traversing the model
        // For now, we'll emit the signal and let the backend handle it
        console.log("Adding all variables under:", parentPath);
        root.allVariablesWatchRequested(parentPath, -1);
    }
}
