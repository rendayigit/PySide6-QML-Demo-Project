import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 700
    title: "Galactron GUI - Simulator Control"

    property string simulationTime: "0.000"
    property bool isRunning: false

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
                onTriggered: console.log("Settings")
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
            color: "#f8f9fa"
            border.color: "#dee2e6"
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
                        color: "black"
                        font.pixelSize: 12
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
                        color: "black"
                        font.pixelSize: 12
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
                        border.color: "#cc3636"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        window.isRunning = false;
                        window.simulationTime = "0.000";
                        console.log("Reset");
                    }
                }

                Button {
                    id: stepButton
                    text: "Step"
                    onClicked: console.log("Step")
                }

                Button {
                    id: storeButton
                    text: "Store"
                    onClicked: console.log("Store")
                }

                Button {
                    id: restoreButton
                    text: "Restore"
                    onClicked: console.log("Restore")
                }

                Button {
                    id: plotButton
                    text: "Plot"
                    onClicked: console.log("Plot")
                }

                Item { Layout.fillWidth: true } // Spacer

                Text {
                    text: "Simulation Time (s)"
                    font.pixelSize: 12
                    color: "#333"
                }

                TextField {
                    id: simTimeDisplay
                    text: window.simulationTime
                    readOnly: true
                    implicitWidth: 100
                    background: Rectangle {
                        color: "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        radius: 3
                    }
                }
            }
        }

        // Main Content Area with Split Layout
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                // Left side - Variables Section
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.7
                    color: "white"
                    border.color: "#dee2e6"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        // Tree Panel
                        Rectangle {
                            Layout.preferredWidth: 300
                            Layout.fillHeight: true
                            color: "white"
                            border.color: "#dee2e6"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 5

                                Text {
                                    text: "Simulation Models"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#333"
                                }

                                ScrollView {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    
                                    ListView {
                                        id: modelsTree
                                        model: ListModel {
                                            ListElement { name: "System Models"; level: 0 }
                                            ListElement { name: "  - Spacecraft"; level: 1 }
                                            ListElement { name: "  - Orbit"; level: 1 }
                                            ListElement { name: "  - Environment"; level: 1 }
                                            ListElement { name: "Control Systems"; level: 0 }
                                            ListElement { name: "  - ADCS"; level: 1 }
                                            ListElement { name: "  - Power"; level: 1 }
                                        }

                                        delegate: Rectangle {
                                            width: modelsTree.width
                                            height: 25
                                            color: mouseArea.containsMouse ? "#e9ecef" : "transparent"

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
                                                color: "#333"
                                                font.bold: model.level === 0
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Variable List Panel
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "white"
                            border.color: "#dee2e6"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 5

                                Text {
                                    text: "Variables"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#333"
                                }

                                // Variable table header
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 30
                                    color: "#f8f9fa"
                                    border.color: "#dee2e6"
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 0

                                        Text { text: "Variable"; Layout.preferredWidth: 200; font.bold: true; font.pixelSize: 12 }
                                        Text { text: "Description"; Layout.fillWidth: true; font.bold: true; font.pixelSize: 12 }
                                        Text { text: "Value"; Layout.preferredWidth: 150; font.bold: true; font.pixelSize: 12 }
                                        Text { text: "Type"; Layout.preferredWidth: 100; font.bold: true; font.pixelSize: 12 }
                                    }
                                }

                                ScrollView {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    ListView {
                                        model: ListModel {
                                            ListElement { variable: "sim.time"; description: "Simulation time"; value: "0.000"; type: "double" }
                                            ListElement { variable: "orbit.altitude"; description: "Orbital altitude"; value: "400.0"; type: "double" }
                                            ListElement { variable: "spacecraft.mass"; description: "Spacecraft mass"; value: "1500.0"; type: "double" }
                                            ListElement { variable: "power.battery"; description: "Battery charge"; value: "85.5"; type: "double" }
                                            ListElement { variable: "adcs.attitude"; description: "Spacecraft attitude"; value: "[0,0,0,1]"; type: "quaternion" }
                                            ListElement { variable: "orbit.velocity"; description: "Orbital velocity"; value: "7654.2"; type: "double" }
                                        }

                                        delegate: Rectangle {
                                            width: parent ? parent.width : 0
                                            height: 25
                                            color: index % 2 ? "#f8f9fa" : "white"

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                spacing: 0

                                                Text { text: model.variable; Layout.preferredWidth: 200; font.pixelSize: 11; color: "#333" }
                                                Text { text: model.description; Layout.fillWidth: true; font.pixelSize: 11; color: "#333" }
                                                Text { text: model.value; Layout.preferredWidth: 150; font.pixelSize: 11; color: "#333" }
                                                Text { text: model.type; Layout.preferredWidth: 100; font.pixelSize: 11; color: "#666" }
                                            }
                                        }
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
                    color: "white"
                    border.color: "#dee2e6"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5

                        Text {
                            text: "Event Logs"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#333"
                        }

                        // Log table header
                        Rectangle {
                            Layout.fillWidth: true
                            height: 30
                            color: "#f8f9fa"
                            border.color: "#dee2e6"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 0

                                Text { text: "Level"; Layout.preferredWidth: 70; font.bold: true; font.pixelSize: 12 }
                                Text { text: "Log"; Layout.fillWidth: true; font.bold: true; font.pixelSize: 12 }
                            }
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ListView {
                                model: ListModel {
                                    ListElement { level: "INFO"; log: "Simulator initialized successfully" }
                                    ListElement { level: "INFO"; log: "Loading spacecraft configuration..." }
                                    ListElement { level: "WARN"; log: "Battery level below optimal range" }
                                    ListElement { level: "INFO"; log: "Orbit propagation started" }
                                    ListElement { level: "DEBUG"; log: "Attitude control system active" }
                                    ListElement { level: "INFO"; log: "Telemetry data received" }
                                    ListElement { level: "ERROR"; log: "Communication timeout" }
                                    ListElement { level: "INFO"; log: "System recovery completed" }
                                }

                                delegate: Rectangle {
                                    width: parent ? parent.width : 0
                                    height: 40
                                    color: {
                                        if (model.level === "ERROR") return "#ffe6e6"
                                        if (model.level === "WARN") return "#fff3cd"
                                        return index % 2 ? "#f8f9fa" : "white"
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 5

                                        Rectangle {
                                            Layout.preferredWidth: 60
                                            height: 25
                                            color: {
                                                if (model.level === "ERROR") return "#dc3545"
                                                if (model.level === "WARN") return "#ffc107"
                                                if (model.level === "INFO") return "#17a2b8"
                                                return "#6c757d"
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
                                            Layout.fillWidth: true
                                            text: model.log
                                            font.pixelSize: 11
                                            color: "#333"
                                            wrapMode: Text.WordWrap
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
            height: 30
            color: "#f0f0f0"
            border.color: "#dee2e6"
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "Simulator ready"
                font.pixelSize: 12
                color: "#333"
            }
        }
    }
}
