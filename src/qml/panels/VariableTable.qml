import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

/**
 * VariableTable - Variable display table component
 * 
 * This component displays variables with resizable columns include Variable, Description,
 * Value, and Type. It supports selection, context menu operations, and dynamic row heights.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.borderColor
    border.width: 1
    
    // Properties
    property alias model: variablesModel
    
    // Signals for communication with backend
    signal clearTableRequested()
    signal removeVariablesRequested(var variablePaths)
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Text {
            text: "Variables"
            font.pixelSize: 14
            font.bold: true
            color: ThemeManager.primaryText
        }

        // Variable table header with resizable columns
        Rectangle {
            id: variableTableHeader
            Layout.fillWidth: true
            height: 30
            color: ThemeManager.hoverBackground
            border.color: ThemeManager.borderColor
            border.width: 1

            // Column width properties
            property real variableColumnWidth: 200
            property real descriptionColumnWidth: 150
            property real valueColumnWidth: 100
            property real typeColumnWidth: Math.max(100, width - variableColumnWidth - descriptionColumnWidth - valueColumnWidth - 20)

            Row {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 0

                // Variable column
                Rectangle {
                    width: variableTableHeader.variableColumnWidth
                    height: parent.height
                    color: "transparent"
                    
                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        text: "Variable"
                        font.bold: true
                        font.pixelSize: 12
                        color: ThemeManager.primaryText
                    }
                    
                    // Resize handle
                    Rectangle {
                        id: variableResizeHandle
                        width: 3
                        height: parent.height
                        anchors.right: parent.right
                        color: variableResizeArea.containsMouse ? ThemeManager.accentColor : ThemeManager.borderColor
                        
                        MouseArea {
                            id: variableResizeArea
                            anchors.fill: parent
                            anchors.margins: -2
                            hoverEnabled: true
                            cursorShape: Qt.SizeHorCursor
                            
                            property real startX: 0
                            property real startWidth: 0
                            
                            onPressed: function(mouse) {
                                startX = mouse.x
                                startWidth = variableTableHeader.variableColumnWidth
                            }
                            
                            onPositionChanged: function(mouse) {
                                if (pressed) {
                                    var delta = mouse.x - startX
                                    var newWidth = Math.max(50, startWidth + delta)
                                    variableTableHeader.variableColumnWidth = Math.min(400, newWidth)
                                }
                            }
                        }
                    }
                }

                // Description column
                Rectangle {
                    width: variableTableHeader.descriptionColumnWidth
                    height: parent.height
                    color: "transparent"
                    
                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        text: "Description"
                        font.bold: true
                        font.pixelSize: 12
                        color: ThemeManager.primaryText
                    }
                    
                    // Resize handle
                    Rectangle {
                        width: 3
                        height: parent.height
                        anchors.right: parent.right
                        color: descriptionResizeArea.containsMouse ? ThemeManager.accentColor : ThemeManager.borderColor
                        
                        MouseArea {
                            id: descriptionResizeArea
                            anchors.fill: parent
                            anchors.margins: -2
                            hoverEnabled: true
                            cursorShape: Qt.SizeHorCursor
                            
                            property real startX: 0
                            property real startWidth: 0
                            
                            onPressed: function(mouse) {
                                startX = mouse.x
                                startWidth = variableTableHeader.descriptionColumnWidth
                            }
                            
                            onPositionChanged: function(mouse) {
                                if (pressed) {
                                    var delta = mouse.x - startX
                                    var newWidth = Math.max(50, startWidth + delta)
                                    variableTableHeader.descriptionColumnWidth = Math.min(400, newWidth)
                                }
                            }
                        }
                    }
                }

                // Value column
                Rectangle {
                    width: variableTableHeader.valueColumnWidth
                    height: parent.height
                    color: "transparent"
                    
                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        text: "Value"
                        font.bold: true
                        font.pixelSize: 12
                        color: ThemeManager.primaryText
                    }
                    
                    // Resize handle
                    Rectangle {
                        width: 3
                        height: parent.height
                        anchors.right: parent.right
                        color: valueResizeArea.containsMouse ? ThemeManager.accentColor : ThemeManager.borderColor
                        
                        MouseArea {
                            id: valueResizeArea
                            anchors.fill: parent
                            anchors.margins: -2
                            hoverEnabled: true
                            cursorShape: Qt.SizeHorCursor
                            
                            property real startX: 0
                            property real startWidth: 0
                            
                            onPressed: function(mouse) {
                                startX = mouse.x
                                startWidth = variableTableHeader.valueColumnWidth
                            }
                            
                            onPositionChanged: function(mouse) {
                                if (pressed) {
                                    var delta = mouse.x - startX
                                    var newWidth = Math.max(50, startWidth + delta)
                                    variableTableHeader.valueColumnWidth = Math.min(300, newWidth)
                                }
                            }
                        }
                    }
                }

                // Type column
                Rectangle {
                    width: variableTableHeader.typeColumnWidth
                    height: parent.height
                    color: "transparent"
                    
                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        text: "Type"
                        font.bold: true
                        font.pixelSize: 12
                        color: ThemeManager.primaryText
                    }
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: variablesListView
                model: ListModel {
                    id: variablesModel
                }

                // Selection properties
                property var selectedItems: []
                
                // Helper function to toggle selection
                function toggleSelection(index) {
                    var item = variablesModel.get(index);
                    if (!item) return;
                    
                    var isSelected = item.selected || false;
                    variablesModel.setProperty(index, "selected", !isSelected);
                    
                    // Update selectedItems array
                    updateSelectedItems();
                }
                
                // Helper function to clear all selections
                function clearSelection() {
                    for (var i = 0; i < variablesModel.count; i++) {
                        variablesModel.setProperty(i, "selected", false);
                    }
                    selectedItems = [];
                }
                
                // Helper function to update selectedItems array
                function updateSelectedItems() {
                    var selected = [];
                    for (var i = 0; i < variablesModel.count; i++) {
                        var item = variablesModel.get(i);
                        if (item.selected) {
                            selected.push({
                                index: i,
                                variablePath: item.variablePath,
                                description: item.description
                            });
                        }
                    }
                    selectedItems = selected;
                }

                // Context menu for right-click actions
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton) {
                            variableContextMenu.popup()
                        }
                    }
                }

                Menu {
                    id: variableContextMenu
                    MenuItem {
                        text: "Clear Table"
                        onTriggered: {
                            console.log("Clear Table from context menu");
                            root.clearTableRequested();
                        }
                    }
                    MenuSeparator {}
                    MenuItem {
                        text: "Remove Selection (" + variablesListView.selectedItems.length + ")"
                        enabled: variablesListView.selectedItems.length > 0
                        onTriggered: {
                            console.log("Remove Selection from context menu");
                            if (variablesListView.selectedItems.length > 0) {
                                // Collect paths to remove
                                var pathsToRemove = [];
                                for (var i = 0; i < variablesListView.selectedItems.length; i++) {
                                    pathsToRemove.push(variablesListView.selectedItems[i].variablePath);
                                }
                                root.removeVariablesRequested(pathsToRemove);
                                // Clear selection after removal
                                variablesListView.clearSelection();
                            }
                        }
                    }
                }

                delegate: Rectangle {
                    width: parent ? parent.width : 0
                    height: Math.max(25, Math.max(variableText.contentHeight, Math.max(descriptionText.contentHeight, valueText.contentHeight)) + 20)
                    color: {
                        if (model.selected) {
                            return ThemeManager.selectionBackground;
                        }
                        return index % 2 ? ThemeManager.hoverBackground : ThemeManager.panelBackground;
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                // Handle selection on left click
                                if (mouse.modifiers & Qt.ControlModifier) {
                                    // Ctrl+click: toggle selection
                                    variablesListView.toggleSelection(index);
                                } else {
                                    // Normal click: clear all selections and select this one
                                    variablesListView.clearSelection();
                                    variablesListView.toggleSelection(index);
                                }
                            } else if (mouse.button === Qt.RightButton) {
                                // Right click: show context menu
                                // If this item is not selected, select it first
                                if (!model.selected) {
                                    variablesListView.clearSelection();
                                    variablesListView.toggleSelection(index);
                                }
                                variableContextMenu.popup();
                            }
                        }
                    }

                    Row {
                        id: contentRow
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 0

                        // Variable column
                        Rectangle {
                            width: variableTableHeader.variableColumnWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            
                            Text {
                                id: variableText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                text: model.variablePath || model.variable || ""
                                font.pixelSize: 11
                                color: model.selected ? ThemeManager.primaryText : ThemeManager.primaryText
                                wrapMode: Text.Wrap
                                width: parent.width - 10
                            }
                        }

                        // Description column
                        Rectangle {
                            width: variableTableHeader.descriptionColumnWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            
                            Text {
                                id: descriptionText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                text: model.description || ""
                                font.pixelSize: 11
                                color: model.selected ? ThemeManager.primaryText : ThemeManager.primaryText
                                wrapMode: Text.Wrap
                                width: parent.width - 10
                            }
                        }

                        // Value column
                        Rectangle {
                            width: variableTableHeader.valueColumnWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            
                            Text {
                                id: valueText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                text: model.value || ""
                                font.pixelSize: 11
                                color: model.selected ? ThemeManager.primaryText : ThemeManager.primaryText
                                wrapMode: Text.Wrap
                                width: parent.width - 10
                            }
                        }

                        // Type column
                        Rectangle {
                            width: variableTableHeader.typeColumnWidth
                            height: parent.height
                            color: "transparent"
                            clip: true
                            
                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                text: model.type || ""
                                font.pixelSize: 11
                                color: model.selected ? ThemeManager.primaryText : ThemeManager.secondaryText
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
