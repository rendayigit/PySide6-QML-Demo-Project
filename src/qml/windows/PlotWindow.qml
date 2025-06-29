pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../services"

/**
 * PlotWindow - Plot management window
 *
 * This window provides controls for managing variable plots,
 * including creating new plots and managing existing ones.
 */
Window {
    id: root

    readonly property int min_width: 450
    readonly property int min_height: 300

    // Backend instance property
    property var backendInstance: null

    title: "Plot Manager"

    width: 600  // Start with a wider default width
    height: min_height

    minimumWidth: root.min_width
    minimumHeight: root.min_height

    color: ThemeManager.windowBackground

    // Main content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header
        Text {
            text: "Variable Plotting"
            font.pixelSize: 16
            font.bold: true
            color: ThemeManager.componentForeground
        }

        // Active plots section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Active Plots"
                font.pixelSize: 14
                font.bold: true
                color: ThemeManager.componentForeground
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                color: ThemeManager.componentBackground
                border.color: ThemeManager.border
                border.width: 1
                radius: 4
                clip: true

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 5

                    ListView {
                        id: plotsListView
                        model: ListModel {
                            id: plotsModel
                        }

                        delegate: Rectangle {
                            id: delegateRoot

                            required property string plot_id
                            required property string title
                            required property int index

                            width: plotsListView.width
                            height: 30
                            color: "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 10

                                Text {
                                    id: plotTitleText
                                    text: delegateRoot.title || "Plot"
                                    font.pixelSize: 12
                                    color: ThemeManager.componentForeground
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 50  // Ensure minimum space for at least some text
                                    elide: Text.ElideRight  // Add "..." when text is too long
                                    clip: true  // Prevent text overflow

                                    // Tooltip to show full text when hovered
                                    MouseArea {
                                        id: titleMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        ToolTip {
                                            visible: titleMouseArea.containsMouse && (plotTitleText.implicitWidth > plotTitleText.width)
                                            text: delegateRoot.title || "Plot"
                                            delay: 500
                                        }
                                    }
                                }

                                CustomButton {
                                    buttonText: "Close"
                                    Layout.preferredWidth: 60
                                    Layout.preferredHeight: 24
                                    normalColor: ThemeManager.destructiveBackground
                                    hoveredColor: ThemeManager.destructiveHoverBackground
                                    pressedColor: ThemeManager.destructivePressedBackground
                                    textColor: ThemeManager.destructiveForeground
                                    pixelSize: 10

                                    onClicked: {
                                        if (root.backendInstance && root.backendInstance.plotting) {
                                            root.backendInstance.plotting.close_plot(delegateRoot.plot_id);
                                            // The plotClosed signal will automatically update our list
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Controls section
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            CustomButton {
                buttonText: "Close All Plots"
                normalColor: ThemeManager.destructiveBackground
                hoveredColor: ThemeManager.destructiveHoverBackground
                pressedColor: ThemeManager.destructivePressedBackground
                textColor: ThemeManager.destructiveForeground
                borderColor: ThemeManager.border
                Layout.preferredWidth: 120

                onClicked: {
                    if (root.backendInstance && root.backendInstance.plotting) {
                        root.backendInstance.plotting.close_all_plots();
                        // The plotClosed signals will automatically update our list
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        // Spacer
        Item {
            Layout.fillHeight: true
        }

        // Bottom buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item {
                Layout.fillWidth: true
            }

            CustomButton {
                buttonText: "Close"

                onClicked: {
                    root.close();
                }
            }
        }
    }

    // Functions
    function addPlotToList(plotId, title) {
        plotsModel.append({
            "plot_id": plotId,
            "title": title
        });
    }

    function removePlotFromList(plotId) {
        for (var i = 0; i < plotsModel.count; i++) {
            if (plotsModel.get(i).plot_id === plotId) {
                plotsModel.remove(i);
                break;
            }
        }
    }

    function refreshPlotsList() {
        if (root.backendInstance && root.backendInstance.plotting) {
            plotsModel.clear();
            var plotInfoList = root.backendInstance.plotting.get_plot_info_list();
            for (var i = 0; i < plotInfoList.length; i++) {
                var plotInfo = plotInfoList[i];
                addPlotToList(plotInfo.plot_id, plotInfo.title);
            }
        }
    }

    Component.onCompleted: {
        refreshPlotsList();
    }

    // Connect to backend plot signals for event-driven updates
    Connections {
        target: (root.backendInstance && root.backendInstance.plotting) ? root.backendInstance.plotting.plot_manager_object : null

        function onPlotCreated(plotId) {
            // When a new plot is created, add it to our list
            if (root.backendInstance && root.backendInstance.plotting) {
                var plotInfoList = root.backendInstance.plotting.get_plot_info_list();
                for (var i = 0; i < plotInfoList.length; i++) {
                    var plotInfo = plotInfoList[i];
                    if (plotInfo.plot_id === plotId) {
                        root.addPlotToList(plotInfo.plot_id, plotInfo.title);
                        break;
                    }
                }
            }
        }

        function onPlotClosed(plotId) {
            // When a plot is closed, remove it from our list
            root.removePlotFromList(plotId);
        }
    }
}
