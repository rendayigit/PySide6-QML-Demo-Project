import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Demo 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 700
    title: "Galactron GUI - Simulator Control"

    // Create a Backend instance
    Backend {
        id: backendInstance
    }

    property string simulationTime: "0.000"
    property bool isRunning: false
    property bool isDarkTheme: false
    
    // Theme colors
    property color backgroundColor: isDarkTheme ? "#2b2b2b" : "#ffffff"
    property color panelColor: isDarkTheme ? "#3c3c3c" : "#f8f9fa"
    property color borderColor: isDarkTheme ? "#555555" : "#dee2e6"
    property color textColor: isDarkTheme ? "#ffffff" : "#333333"
    property color headerBgColor: isDarkTheme ? "#404040" : "#f8f9fa"
    
    // Sample data models
    ListModel {
        id: modelsTreeModel
        ListElement { name: "System"; level: 0 }
        ListElement { name: "  Controllers"; level: 1 }
        ListElement { name: "    PID_Controller"; level: 2 }
        ListElement { name: "  Sensors"; level: 1 }
        ListElement { name: "    Temperature_Sensor"; level: 2 }
        ListElement { name: "    Pressure_Sensor"; level: 2 }
        ListElement { name: "Actuators"; level: 0 }
        ListElement { name: "  Motor_1"; level: 1 }
        ListElement { name: "  Valve_A"; level: 1 }
    }
    
    ListModel {
        id: variablesModel
        ListElement { variable: "sys.temp"; description: "System Temperature"; value: "25.4°C"; type: "Real" }
        ListElement { variable: "sys.pressure"; description: "System Pressure"; value: "101.3kPa"; type: "Real" }
        ListElement { variable: "motor.speed"; description: "Motor Speed"; value: "1450 RPM"; type: "Integer" }
        ListElement { variable: "valve.position"; description: "Valve Position"; value: "45%"; type: "Real" }
        ListElement { variable: "pid.setpoint"; description: "PID Setpoint"; value: "30.0"; type: "Real" }
    }
    
    ListModel {
        id: eventsModel
        ListElement { time: "0.000"; event: "System initialized"; severity: "Info" }
        ListElement { time: "0.125"; event: "Motor started"; severity: "Info" }
        ListElement { time: "0.250"; event: "Temperature sensor calibrated"; severity: "Info" }
        ListElement { time: "0.375"; event: "PID controller engaged"; severity: "Info" }
    }

    // Menu Bar
    menuBar: MenuBar {
        Menu {
            title: "&File"
            
            MenuItem {
                text: "Simulator Controls"
                onTriggered: console.log("Simulator Controls menu")
            }
            MenuItem {
                text: "&Run/Hold\tCtrl+R"
                onTriggered: {
                    window.isRunning = !window.isRunning;
                    console.log(window.isRunning ? "Running" : "Holding");
                }
            }
            MenuItem {
                text: "Reset\tCtrl+X"
                onTriggered: {
                    window.isRunning = false;
                    window.simulationTime = "0.000";
                    console.log("Reset");
                }
            }
            MenuItem {
                text: "Step"
                onTriggered: console.log("Step")
            }
            MenuItem {
                text: "Progress Simulation"
                onTriggered: console.log("Progress Simulation")
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
                text: "Speed"
                onTriggered: console.log("Speed")
            }
            MenuSeparator {}
            MenuItem {
                text: "Settings"
                onTriggered: settingsDialog.open()
            }
            MenuSeparator {}
            MenuItem {
                text: "&Quit\tCtrl+Q"
                onTriggered: Qt.quit()
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
                onTriggered: console.log("Clear Table")
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

    // Main content
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Control Panel
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: window.panelColor
            border.color: window.borderColor
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Button {
                    id: simulatorButton
                    text: "Simulator Controls"
                    background: Rectangle {
                        color: parent.pressed ? "#e6b800" : "#ffcc00"
                        radius: 4
                        border.color: "#d4af37"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: console.log("Simulator Controls")
                }

                Button {
                    id: runButton
                    text: window.isRunning ? "Hold" : "Run"
                    background: Rectangle {
                        color: parent.pressed ? "#e6b800" : "#ffcc00"
                        radius: 4
                        border.color: "#d4af37"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        window.isRunning = !window.isRunning;
                        console.log(window.isRunning ? "Running" : "Holding");
                    }
                }

                Button {
                    id: resetButton
                    text: "Reset"
                    background: Rectangle {
                        color: parent.pressed ? "#cc3636" : "#ff4545"
                        radius: 4
                        border.color: "#d4af37"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 12
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        window.isRunning = false;
                        window.simulationTime = "0.000";
                        console.log("Reset");
                    }
                }

                Button { text: "Step"; onClicked: console.log("Step") }
                Button { text: "Store"; onClicked: console.log("Store") }
                Button { text: "Restore"; onClicked: console.log("Restore") }
                Button { text: "Plot"; onClicked: console.log("Plot") }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 200
                    height: 40
                    color: window.backgroundColor
                    border.color: window.borderColor
                    border.width: 1
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "Time: " + window.simulationTime
                        font.pixelSize: 12
                        color: window.textColor
                    }
                }
            }
        }

        // Three-panel layout
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            // Left side - Models Tree
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.3
                color: window.backgroundColor
                border.color: window.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    Text {
                        text: "Simulation Models"
                        font.pixelSize: 14
                        font.bold: true
                        color: window.textColor
                        Layout.fillWidth: true
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ListView {
                            model: modelsTreeModel
                            delegate: Rectangle {
                                width: parent ? parent.width : 0
                                height: 25
                                color: mouseArea.containsMouse ? (window.isDarkTheme ? "#404040" : "#e9ecef") : "transparent"

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: console.log("Selected:", model.name)
                                }

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: model.name
                                    font.pixelSize: 12
                                    color: window.textColor
                                    font.bold: model.level === 0
                                }
                            }
                        }
                    }
                }
            }

            // Center - Variables Table
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: window.backgroundColor
                border.color: window.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    Text {
                        text: "Variables"
                        font.pixelSize: 14
                        font.bold: true
                        color: window.textColor
                        Layout.fillWidth: true
                    }

                    // Header
                    Rectangle {
                        Layout.fillWidth: true
                        height: 30
                        color: window.headerBgColor
                        border.color: window.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 0

                            Text { text: "Variable"; Layout.preferredWidth: 200; font.bold: true; font.pixelSize: 12; color: window.textColor }
                            Text { text: "Description"; Layout.fillWidth: true; font.bold: true; font.pixelSize: 12; color: window.textColor }
                            Text { text: "Value"; Layout.preferredWidth: 150; font.bold: true; font.pixelSize: 12; color: window.textColor }
                            Text { text: "Type"; Layout.preferredWidth: 100; font.bold: true; font.pixelSize: 12; color: window.textColor }
                        }
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ListView {
                            model: variablesModel
                            delegate: Rectangle {
                                width: parent ? parent.width : 0
                                height: 25
                                color: index % 2 ? (window.isDarkTheme ? "#3a3a3a" : "#f8f9fa") : (window.isDarkTheme ? "#2b2b2b" : "white")

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 0

                                    Text { text: model.variable; Layout.preferredWidth: 200; font.pixelSize: 11; color: window.textColor }
                                    Text { text: model.description; Layout.fillWidth: true; font.pixelSize: 11; color: window.textColor }
                                    Text { text: model.value; Layout.preferredWidth: 150; font.pixelSize: 11; color: window.textColor }
                                    Text { text: model.type; Layout.preferredWidth: 100; font.pixelSize: 11; color: window.textColor }
                                }
                            }
                        }
                    }
                }
            }

            // Right side - Event Logs
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.3
                color: window.backgroundColor
                border.color: window.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    Text {
                        text: "Event Logs"
                        font.pixelSize: 14
                        font.bold: true
                        color: window.textColor
                        Layout.fillWidth: true
                    }

                    // Header
                    Rectangle {
                        Layout.fillWidth: true
                        height: 30
                        color: window.headerBgColor
                        border.color: window.borderColor
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 0

                            Text { text: "Time"; Layout.preferredWidth: 70; font.bold: true; font.pixelSize: 12; color: window.textColor }
                            Text { text: "Event"; Layout.fillWidth: true; font.bold: true; font.pixelSize: 12; color: window.textColor }
                            Text { text: "Level"; Layout.preferredWidth: 70; font.bold: true; font.pixelSize: 12; color: window.textColor }
                        }
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ListView {
                            model: eventsModel
                            delegate: Rectangle {
                                width: parent ? parent.width : 0
                                height: 40
                                color: index % 2 ? (window.isDarkTheme ? "#3a3a3a" : "#f8f9fa") : (window.isDarkTheme ? "#2b2b2b" : "white")

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5

                                    Text {
                                        text: model.time
                                        Layout.preferredWidth: 70
                                        font.pixelSize: 11
                                        color: window.textColor
                                    }

                                    Text {
                                        text: model.event
                                        Layout.fillWidth: true
                                        font.pixelSize: 11
                                        color: window.textColor
                                        wrapMode: Text.WordWrap
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: 60
                                        height: 25
                                        color: {
                                            if (model.severity === "Info") return window.isDarkTheme ? "#0d7377" : "#17a2b8"
                                            if (model.severity === "Warning") return window.isDarkTheme ? "#b8860b" : "#ffc107"
                                            if (model.severity === "Error") return window.isDarkTheme ? "#8b0000" : "#dc3545"
                                            return window.isDarkTheme ? "#495057" : "#6c757d"
                                        }
                                        radius: 3

                                        Text {
                                            anchors.centerIn: parent
                                            text: model.severity
                                            font.pixelSize: 10
                                            color: "white"
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            height: 25
            color: window.headerBgColor
            border.color: window.borderColor
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "Ready"
                font.pixelSize: 12
                color: window.textColor
            }
        }
    }
    
    // Settings Dialog
    SettingsDialog {
        id: settingsDialog
        isDarkTheme: window.isDarkTheme
        
        onThemeChanged: function(darkTheme) {
            window.isDarkTheme = darkTheme
        }
    }
}
