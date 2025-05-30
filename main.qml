import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Demo 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "PySide6 + QML Demo"

    // Create a Backend instance
    Backend {
        id: backendInstance
    }

    // Main content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Title
        Text {
            text: "PySide6 + QML Integration Demo"
            font.pixelSize: 28
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        // Card-like container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#ecf0f1"
            radius: 10
            border.color: "#bdc3c7"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 30

                // Message display
                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    color: "#3498db"
                    radius: 8

                    Text {
                        id: messageText
                        text: backend.message
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap

                        // Animation for text changes
                        Behavior on text {
                            SequentialAnimation {
                                PropertyAnimation {
                                    target: messageText
                                    property: "opacity"
                                    to: 0
                                    duration: 150
                                }
                                PropertyAction {
                                    target: messageText
                                    property: "text"
                                }
                                PropertyAnimation {
                                    target: messageText
                                    property: "opacity"
                                    to: 1
                                    duration: 150
                                }
                            }
                        }
                    }
                }

                // Button section
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Button {
                        id: clickButton
                        text: "Click Me!"
                        font.pixelSize: 16
                        background: Rectangle {
                            color: parent.pressed ? "#27ae60" : "#2ecc71"
                            radius: 5
                            border.color: "#27ae60"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            backend.increment_counter();
                            // Add a little animation
                            clickAnimation.start();
                        }

                        // Click animation
                        SequentialAnimation {
                            id: clickAnimation
                            PropertyAnimation {
                                target: clickButton
                                property: "scale"
                                to: 0.95
                                duration: 100
                            }
                            PropertyAnimation {
                                target: clickButton
                                property: "scale"
                                to: 1.0
                                duration: 100
                            }
                        }
                    }

                    Button {
                        text: "Reset"
                        font.pixelSize: 16
                        background: Rectangle {
                            color: parent.pressed ? "#c0392b" : "#e74c3c"
                            radius: 5
                            border.color: "#c0392b"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            backend.update_message("Reset! Ready for new clicks.");
                        }
                    }
                }

                // Text input section
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Send custom message to Python backend:"
                        font.pixelSize: 14
                        color: "#34495e"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        TextField {
                            id: messageInput
                            Layout.fillWidth: true
                            placeholderText: "Enter your message here..."
                            font.pixelSize: 14

                            background: Rectangle {
                                color: "white"
                                border.color: "#bdc3c7"
                                border.width: 1
                                radius: 4
                            }

                            onAccepted: {
                                if (text.length > 0) {
                                    backend.update_message(text);
                                    text = "";
                                }
                            }
                        }

                        Button {
                            text: "Send"
                            enabled: messageInput.text.length > 0

                            background: Rectangle {
                                color: parent.enabled ? (parent.pressed ? "#8e44ad" : "#9b59b6") : "#bdc3c7"
                                radius: 4
                            }
                            contentItem: Text {
                                text: parent.text
                                color: parent.enabled ? "white" : "#7f8c8d"
                                font: parent.font
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                if (messageInput.text.length > 0) {
                                    backend.update_message(messageInput.text);
                                    messageInput.text = "";
                                }
                            }
                        }
                    }
                }

                // Info section
                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    color: "#f8f9fa"
                    radius: 5
                    border.color: "#dee2e6"

                    Text {
                        anchors.fill: parent
                        anchors.margins: 15
                        text: "This demo shows:\n• Python-QML communication\n• Signal/Slot mechanism\n• Property binding\n• Modern QML UI components"
                        font.pixelSize: 12
                        color: "#6c757d"
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
