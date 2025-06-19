pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
    border.color: ThemeManager.border
    border.width: 1

    // Configuration constants
    readonly property int itemHeight: 25
    readonly property int indentationStep: 20
    readonly property int baseLeftMargin: 10
    readonly property int rightMargin: 10
    readonly property int iconWidth: 15

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
            color: ThemeManager.componentForeground
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

                    var newExpandedState = !(item.expanded || false);
                    modelsTreeModel.setProperty(index, "expanded", newExpandedState);

                    // Update visibility of children
                    updateChildrenVisibility(index, newExpandedState);
                }

                // Helper function to update children visibility
                function updateChildrenVisibility(parentIndex, parentExpanded) {
                    var parentItem = modelsTreeModel.get(parentIndex);
                    if (!parentItem)
                        return;

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
                    id: delegateItem

                    width: modelsTreeListView.width
                    height: model.visible !== false ? root.itemHeight : 0
                    visible: model.visible !== false
                    color: mouseArea.containsMouse ? ThemeManager.componentHoverBackground : "transparent"

                    required property var model
                    required property int index

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            // Toggle expand/collapse if this item has children
                            if (delegateItem.model.hasChildren) {
                                modelsTreeListView.toggleExpanded(delegateItem.index);
                            }
                        }

                        onDoubleClicked: {
                            if (delegateItem.model.hasChildren) {
                                // Double-click on parent: add all child variables recursively
                                modelsTreeListView.addAllVariablesUnder(delegateItem.model.fullPath, delegateItem.index);
                            } else {
                                // Double-click on leaf: add single variable
                                if (delegateItem.model.fullPath && delegateItem.model.fullPath !== "") {
                                    root.variableWatchRequested(delegateItem.model.fullPath, delegateItem.model.name.trim());
                                }
                            }
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: root.baseLeftMargin + (delegateItem.model.level * root.indentationStep)
                        anchors.rightMargin: root.rightMargin
                        spacing: 5

                        // Expand/collapse icon
                        Text {
                            text: {
                                if (delegateItem.model.hasChildren) {
                                    return delegateItem.model.expanded ? "▼" : "▶";
                                }

                                return "  ";
                            }

                            font.pixelSize: 10
                            color: ThemeManager.secondaryComponentForeground
                            Layout.preferredWidth: root.iconWidth
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // Node name
                        Text {
                            text: delegateItem.model.name
                            font.pixelSize: 12
                            color: ThemeManager.componentForeground
                            font.bold: delegateItem.model.level === 0
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
