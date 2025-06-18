import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"
import "../components"

pragma ComponentBehavior: Bound

/**
 * EventLog - Event logs display component
 *
 * This component displays event logs with different severity levels, auto-scroll functionality,
 * and dynamic row heights for JSON-formatted log messages.
 */
Rectangle {
    id: root
    color: ThemeManager.windowBackground
    border.color: ThemeManager.border
    border.width: 1

    // Color constants for easy modification
    readonly property color errorBadgeColor: "#dc3545"
    readonly property color warningBadgeColor: "#ffc107"
    readonly property color criticalBadgeColor: "#000000"
    readonly property color infoBadgeColor: "#17a2b8"
    readonly property color debugBadgeColor: "#6c757d"
    readonly property color defaultBadgeColor: "#6c757d"
    
    readonly property color errorBackgroundDark: "#4a1f1f"
    readonly property color errorBackgroundLight: "#ffe6e6"
    readonly property color warningBackgroundDark: "#4a3c1f"
    readonly property color warningBackgroundLight: "#fff3cd"
    readonly property color criticalBackgroundDark: "#660000"
    readonly property color criticalBackgroundLight: "#ffdddd"

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
            color: ThemeManager.componentForeground
        }

        // Log table header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: ThemeManager.componentBackground
            border.color: ThemeManager.border
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
                    color: ThemeManager.componentForeground
                }

                Text {
                    text: "Log"
                    Layout.fillWidth: true
                    font.bold: true
                    font.pixelSize: 12
                    color: ThemeManager.componentForeground
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
                    property bool userAtBottom: false
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
                        id: delegateItem
                        width: parent ? parent.width : 0
                        height: Math.max(40, logText.contentHeight + 20)

                        required property var model
                        required property int index

                        color: {
                            if (model.level === "ERROR")
                                return ThemeManager.currentTheme === "dark" ? root.errorBackgroundDark : root.errorBackgroundLight;
                            if (model.level === "WARNING")
                                return ThemeManager.currentTheme === "dark" ? root.warningBackgroundDark : root.warningBackgroundLight;
                            if (model.level === "CRITICAL")
                                return ThemeManager.currentTheme === "dark" ? root.criticalBackgroundDark : root.criticalBackgroundLight;
                            return index % 2 ? ThemeManager.windowBackground.lighter(1.1) : ThemeManager.windowBackground.darker(1.1);
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 5

                            Rectangle {
                                Layout.preferredWidth: 60
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredHeight: 25
                                color: {
                                    if (delegateItem.model.level === "ERROR")
                                        return root.errorBadgeColor;
                                    if (delegateItem.model.level === "WARNING")
                                        return root.warningBadgeColor;
                                    if (delegateItem.model.level === "CRITICAL")
                                        return root.criticalBadgeColor;
                                    if (delegateItem.model.level === "INFO")
                                        return root.infoBadgeColor;
                                    if (delegateItem.model.level === "DEBUG")
                                        return root.debugBadgeColor;
                                    return root.defaultBadgeColor;
                                }
                                radius: 3

                                Text {
                                    anchors.centerIn: parent
                                    text: delegateItem.model.level
                                    color: "white"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }

                            Text {
                                id: logText
                                Layout.fillWidth: true
                                text: delegateItem.model.log
                                font.pixelSize: 11
                                color: ThemeManager.componentForeground
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
            }

            // Auto-scroll button (appears when not at bottom and not auto-scrolling)
            CustomButton {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 10

                buttonText: "↓"
                pixelSize: 20
                width: 40
                height: 40
                radius: 20

                normalColor: ThemeManager.primaryComponentBackground
                hoveredColor: ThemeManager.primaryComponentHoverBackground
                pressedColor: ThemeManager.primaryComponentPressedBackground
                textColor: ThemeManager.primaryComponentForeground
                borderColor: ThemeManager.border

                visible: !eventLogsListView.userAtBottom && !eventLogsListView.autoScrollEnabled

                onClicked: {
                    eventLogsListView.autoScrollEnabled = true;
                    eventLogsListView.positionViewAtIndex(eventLogsListView.count - 1, ListView.End);
                    eventLogsListView.userAtBottom = true;
                }
            }
        }
    }
}
