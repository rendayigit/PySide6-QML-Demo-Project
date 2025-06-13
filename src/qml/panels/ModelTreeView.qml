pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

/**
 * ModelTreeView - Qt 6.2+ TreeView implementation (Example)
 *
 * This is an example of how to use the actual Qt 6.2+ TreeView component.
 * Note: This requires a proper QAbstractItemModel for production use.
 * For now, this demonstrates the TreeView component structure.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.borderColor
    border.width: 1

    // Signals for communication with backend
    signal variableWatchRequested(string variablePath, string variableName)
    signal allVariablesWatchRequested(string parentPath, int parentIndex)

    // For demonstration: A simple hierarchical model
    // In production, this should be a QAbstractItemModel from Python
    property var exampleTreeModel: [
        {
            name: "Root Node 1",
            fullPath: "root1",
            hasChildren: true,
            children: [
                {
                    name: "Child 1.1",
                    fullPath: "root1.child1",
                    hasChildren: false,
                    children: []
                },
                {
                    name: "Child 1.2", 
                    fullPath: "root1.child2",
                    hasChildren: true,
                    children: [
                        {
                            name: "Grandchild 1.2.1",
                            fullPath: "root1.child2.grandchild1",
                            hasChildren: false,
                            children: []
                        }
                    ]
                }
            ]
        },
        {
            name: "Root Node 2",
            fullPath: "root2", 
            hasChildren: false,
            children: []
        }
    ]

    // Public interface for compatibility with main.qml
    property alias model: root
    
    function populateFromFlatData(flatData) {
        // Convert flat data to hierarchical structure
        // This is a simplified example
        console.log("TreeView: Would populate from flat data:", flatData?.length || 0, "items");
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Text {
            text: "Simulation Models (TreeView)"
            font.pixelSize: 14
            font.bold: true
            color: ThemeManager.primaryText
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Qt 6.2+ TreeView Component
            TreeView {
                id: treeView
                anchors.fill: parent
                model: root.exampleTreeModel
                
                delegate: TreeViewDelegate {
                    id: treeDelegate
                    
                    implicitWidth: treeView.width
                    implicitHeight: 25
                    
                    indicator: Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 5 + (treeDelegate.depth * 20)
                        anchors.verticalCenter: parent.verticalCenter
                        text: treeDelegate.hasChildren ? 
                              (treeDelegate.expanded ? "▼" : "▶") : "  "
                        font.pixelSize: 10
                        color: ThemeManager.secondaryText
                        width: 15
                    }
                    
                    contentItem: Rectangle {
                        color: treeDelegate.hovered ? ThemeManager.controlBackgroundHover : "transparent"
                        
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 25 + (treeDelegate.depth * 20)
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            
                            text: treeDelegate.model?.name || ""
                            font.pixelSize: 12
                            color: ThemeManager.primaryText
                            font.bold: treeDelegate.depth === 0
                            elide: Text.ElideRight
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            
                            onDoubleClicked: {
                                var itemModel = treeDelegate.model;
                                if (itemModel?.hasChildren) {
                                    // Double-click on parent: add all child variables recursively
                                    console.log("Adding all variables under:", itemModel.fullPath);
                                    // root.addAllVariablesUnder(itemModel.fullPath);
                                } else {
                                    // Double-click on leaf: add single variable
                                    if (itemModel?.fullPath) {
                                        console.log("Adding to watch:", itemModel.fullPath);
                                        root.variableWatchRequested(itemModel.fullPath, itemModel.name);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
