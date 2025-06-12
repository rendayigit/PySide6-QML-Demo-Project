import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

/**
 * EventLog - Event logs display component
 * 
 * This component displays event logs with different severity levels, auto-scroll functionality,
 * and dynamic row heights for JSON-formatted log messages.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.borderColor
    border.width: 1
    
    // Properties
    property alias model: eventLogsModel
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Text {
            text: "Event Logs"
            font.pixelSize: 14
            font.bold: true
            color: ThemeManager.primaryText
        }

        // Log table header
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: ThemeManager.panelBackground
            border.color: ThemeManager.borderColor
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 0

                Text {
                    text: "Level"
                    Layout.preferredWidth: 70
                    font.bold: true
                    font.pixelSize: 12
                    color: ThemeManager.primaryText
                }
                Text {
                    text: "Log"
                    Layout.fillWidth: true
                    font.bold: true
                    font.pixelSize: 12
                    color: ThemeManager.primaryText
                }
            }
        }

        // Container for ScrollView and auto-scroll button
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                anchors.fill: parent
                clip: true

                ListView {
                    id: eventLogsListView
                    model: ListModel {
                        id: eventLogsModel
                    }

                    // Track if user is at bottom and if auto-scroll is enabled
                    property bool userAtBottom: true
                    property bool autoScrollEnabled: true // Start with auto-scroll enabled

                    // Track when user scrolls manually
                    onContentYChanged: {
                        var atBottom = (contentY + height >= contentHeight - 5); // 5px tolerance
                        if (userAtBottom !== atBottom) {
                            userAtBottom = atBottom;
                            // Disable auto-scroll if user scrolls up manually
                            if (!atBottom && autoScrollEnabled) {
                                autoScrollEnabled = false;
                            }
                            // Re-enable auto-scroll if user scrolls back to bottom
                            if (atBottom && !autoScrollEnabled) {
                                autoScrollEnabled = true;
                            }
                        }
                    }

                    // Auto-scroll when new items are added (if enabled OR if at bottom)
                    onCountChanged: {
                        if (autoScrollEnabled || userAtBottom) {
                            Qt.callLater(function () {
                                positionViewAtIndex(eventLogsListView.count - 1, ListView.End);
                            });
                            userAtBottom = true;
                        }
                    }

                    // Initialize as being at bottom with auto-scroll enabled
                    Component.onCompleted: {
                        Qt.callLater(function () {
                            if (eventLogsListView.count > 0) {
                                positionViewAtIndex(eventLogsListView.count - 1, ListView.End);
                            }
                        });
                        userAtBottom = true;
                        autoScrollEnabled = true;
                    }

                    delegate: Rectangle {
                        width: parent ? parent.width : 0
                        height: Math.max(40, logText.contentHeight + 20)
                        color: {
                            if (model.level === "ERROR")
                                return ThemeManager.isDarkTheme ? "#4a1f1f" : "#ffe6e6";
                            if (model.level === "WARNING")
                                return ThemeManager.isDarkTheme ? "#4a3c1f" : "#fff3cd";
                            if (model.level === "CRITICAL")
                                return ThemeManager.isDarkTheme ? "#660000" : "#ffdddd";
                            return index % 2 ? ThemeManager.alternateBackground : ThemeManager.surfaceBackground;
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 5

                            Rectangle {
                                Layout.preferredWidth: 60
                                Layout.alignment: Qt.AlignTop
                                height: 25
                                color: {
                                    if (model.level === "ERROR")
                                        return "#dc3545";
                                    if (model.level === "WARNING")
                                        return "#ffc107";
                                    if (model.level === "CRITICAL")
                                        return "#000000";
                                    if (model.level === "INFO")
                                        return "#17a2b8";
                                    if (model.level === "DEBUG")
                                        return "#6c757d";
                                    return "#6c757d";
                                }
                                radius: 3

                                Text {
                                    anchors.centerIn: parent
                                    text: model.level
                                    color: "white"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }

                            Text {
                                id: logText
                                Layout.fillWidth: true
                                text: model.log
                                font.pixelSize: 11
                                color: ThemeManager.primaryText
                                wrapMode: Text.Wrap
                                width: parent.width - 75 // Account for level badge width and margins
                            }
                        }
                    }
                }
            }

            // Auto-scroll button (appears when not at bottom and not auto-scrolling)
            Button {
                id: autoScrollButton
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 10
                width: 40
                height: 40
                visible: !eventLogsListView.userAtBottom && !eventLogsListView.autoScrollEnabled

                background: Rectangle {
                    color: parent.pressed ? ThemeManager.primaryButtonBgPressed : ThemeManager.primaryButtonBg
                    radius: 20
                    border.color: ThemeManager.focusBorderColor
                    border.width: 1

                    // Drop shadow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 2
                        anchors.leftMargin: 2
                        color: ThemeManager.isDarkTheme ? "#00000060" : "#00000040"
                        radius: 20
                        z: -1
                    }
                }

                contentItem: Text {
                    text: "↓"
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    eventLogsListView.autoScrollEnabled = true;
                    eventLogsListView.positionViewAtIndex(eventLogsListView.count - 1, ListView.End);
                    eventLogsListView.userAtBottom = true;
                }
            }
        }
    }
}
