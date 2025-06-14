import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../services"

/**
 * ModelTree - Simulation model tree display component
 *
 * This component displays the hierarchical simulation model tree with expand/collapse
 * functionality and support for adding variables to watch list.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.borderColor
    border.width: 1

    // Properties
    property alias model: modelsTreeModel

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

            ListView {
                id: modelsTreeListView
                model: ListModel {
                    id: modelsTreeModel
                }

                // Helper function to toggle expand/collapse
                function toggleExpanded(index) {
                    var item = modelsTreeModel.get(index);
                    if (!item)
                        return;

                    var isExpanded = item.expanded || false;
                    modelsTreeModel.setProperty(index, "expanded", !isExpanded);

                    // Update visibility of children
                    updateChildrenVisibility(index, !isExpanded);
                }

                // Helper function to update children visibility
                function updateChildrenVisibility(parentIndex, parentExpanded) {
                    var parentItem = modelsTreeModel.get(parentIndex);
                    if (!parentItem) {
                        return;
                    }

                    var parentLevel = parentItem.level;
                    var parentPath = parentItem.fullPath;

                    // Find and update all children of this parent
                    for (var i = parentIndex + 1; i < modelsTreeModel.count; i++) {
                        var childItem = modelsTreeModel.get(i);

                        // Stop when we reach a sibling or parent (same or lower level)
                        if (childItem.level <= parentLevel) {
                            break;
                        }

                        // Check if this is a direct child
                        if (childItem.level === parentLevel + 1 && childItem.fullPath.startsWith(parentPath + ".")) {
                            modelsTreeModel.setProperty(i, "visible", parentExpanded);

                            // If we're collapsing or child is collapsed, hide all its descendants
                            if (!parentExpanded || !childItem.expanded) {
                                updateChildrenVisibility(i, false);
                            }
                        }
                    }
                }

                // Helper function to add all variables under a parent recursively
                function addAllVariablesUnder(parentPath, parentIndex) {
                    var parentItem = modelsTreeModel.get(parentIndex);
                    if (!parentItem)
                        return;

                    var parentLevel = parentItem.level;

                    // Find and add all leaf nodes under this parent
                    for (var i = parentIndex + 1; i < modelsTreeModel.count; i++) {
                        var childItem = modelsTreeModel.get(i);

                        // Stop when we reach a sibling or parent (same or lower level)
                        if (childItem.level <= parentLevel) {
                            break;
                        }

                        // If this is a leaf node (no children) under our parent path, add it
                        if (!childItem.hasChildren && childItem.fullPath.startsWith(parentPath + ".")) {
                            console.log("Adding to watch:", childItem.fullPath);
                            root.variableWatchRequested(childItem.fullPath, childItem.name.trim());
                        }
                    }
                }

                delegate: Rectangle {
                    width: modelsTreeListView.width
                    height: model.visible !== false ? 25 : 0
                    visible: model.visible !== false
                    color: mouseArea.containsMouse ? ThemeManager.hoverBackground : "transparent"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.log("Selected:", model.name);
                            // Toggle expand/collapse if this item has children
                            if (model.hasChildren) {
                                modelsTreeListView.toggleExpanded(index);
                            }
                        }
                        onDoubleClicked: {
                            if (model.hasChildren) {
                                // Double-click on parent: add all child variables recursively
                                console.log("Adding all variables under:", model.fullPath);
                                modelsTreeListView.addAllVariablesUnder(model.fullPath, index);
                            } else {
                                // Double-click on leaf: add single variable
                                if (model.fullPath && model.fullPath !== "") {
                                    console.log("Adding to watch:", model.fullPath);
                                    root.variableWatchRequested(model.fullPath, model.name.trim());
                                }
                            }
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10 + (model.level * 20)
                        anchors.rightMargin: 10
                        spacing: 5

                        // Expand/collapse icon
                        Text {
                            text: {
                                if (model.hasChildren) {
                                    return model.expanded ? "▼" : "▶";
                                }
                                return "  ";
                            }
                            font.pixelSize: 10
                            color: ThemeManager.secondaryText
                            Layout.preferredWidth: 15
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // Node name
                        Text {
                            text: model.name
                            font.pixelSize: 12
                            color: ThemeManager.primaryText
                            font.bold: model.level === 0
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
