import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 700
    title: "Galactron GUI - Simulator Control"

    // Use backend's simulation time property
    property bool isRunning: backend ? backend.isRunning : false
    property string currentSimTime: backend ? backend.simulationTime : "0.000"
    property string statusText: backend ? backend.statusText : "Simulator ready"
    property bool commandInProgress: false  // Track if a command is being executed

    // Connect to backend simulation time changes
    Connections {
        target: backend
        function onSimulationTimeChanged() {
            window.currentSimTime = backend.simulationTime;
        }
        function onMissionTimeChanged() {
            // Mission time is automatically updated via binding
        }
        function onEpochTimeChanged() {
            // Epoch time is automatically updated via binding
        }
        function onZuluTimeChanged() {
            // Zulu time is automatically updated via binding
        }
        function onSimulationStatusChanged() {
            window.isRunning = backend.isRunning;
        }
        function onStatusTextChanged() {
            window.statusText = backend.statusText;
        }
        function onEventLogReceived(level, message) {
            eventLogsModel.append({
                "level": level,
                "log": message
            });
        }
        function onModelTreeUpdated(treeData) {
            modelsTreeModel.clear();
            for (var i = 0; i < treeData.length; i++) {
                modelsTreeModel.append(treeData[i]);
            }
        }
        function onVariableAdded(variableData) {
            variablesModel.append(variableData);
        }
        function onVariableUpdated(variablePath, variableData) {
            // Find and update the variable in the model
            for (var i = 0; i < variablesModel.count; i++) {
                if (variablesModel.get(i).variablePath === variablePath) {
                    // Update all properties of the variable
                    variablesModel.setProperty(i, "value", variableData.value);
                    variablesModel.setProperty(i, "type", variableData.type);
                    variablesModel.setProperty(i, "description", variableData.description);
                    break;
                }
            }
        }
        function onCommandExecuted(commandName, success) {
            if (success) {
                console.log(commandName + " command executed successfully");
            } else {
                console.log(commandName + " command failed");
            }
        }
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
                    console.log("Menu Run/Hold triggered");
                    if (backend) {
                        var success = backend.toggleSimulation();
                        if (success) {
                            console.log("Command sent successfully from menu");
                        } else {
                            console.log("Command failed from menu");
                        }
                    }
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
                onTriggered: {
                    console.log("Menu Step triggered");
                    if (backend) {
                        var success = backend.stepSimulation();
                        if (success) {
                            console.log("STEP command sent successfully from menu");
                        } else {
                            console.log("STEP command failed from menu");
                        }
                    }
                }
            }
            MenuItem {
                text: "Progress Simulation"
                onTriggered: {
                    console.log("Progress Simulation menu triggered");
                    progressDialog.open();
                }
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
                text: "Rate"
                onTriggered: {
                    console.log("Rate menu triggered");
                    scaleDialog.open();
                }
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
                        color: {
                            if (parent.pressed) return window.isRunning ? "#cc6600" : "#e6b800";
                            return window.isRunning ? "#ff8800" : "#ffcc00";
                        }
                        radius: 4
                        border.color: window.isRunning ? "#cc6600" : "#d4af37"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "black"
                        font.pixelSize: 12
                        font.bold: window.isRunning
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        console.log("Toggle simulation button clicked");
                        if (backend) {
                            var success = backend.toggleSimulation();
                            if (success) {
                                console.log("Command sent successfully");
                            } else {
                                console.log("Command failed");
                            }
                        }
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
                    background: Rectangle {
                        color: parent.pressed ? "#5599cc" : "#66b3ff"
                        radius: 4
                        border.color: "#4d79a4"
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
                        console.log("Step button clicked");
                        if (backend) {
                            var success = backend.stepSimulation();
                            if (success) {
                                console.log("STEP command sent successfully");
                            } else {
                                console.log("STEP command failed");
                            }
                        }
                    }
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

                Item {
                    Layout.fillWidth: true
                } // Spacer

                // Time displays
                RowLayout {
                    spacing: 15

                    // Simulation Time
                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "Simulation Time (s)"
                            font.pixelSize: 10
                            color: "#333"
                            horizontalAlignment: Text.AlignHCenter
                        }
                        TextField {
                            id: simTimeDisplay
                            text: backend ? backend.simulationTime : "-"
                            readOnly: true
                            implicitWidth: 130
                            color: "#333"
                            font.pixelSize: 11
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "#f8f9fa"
                                border.color: "#ced4da"
                                border.width: 1
                                radius: 3
                            }
                            ToolTip.text: "Simulation elapsed time in seconds"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }
                    }

                    // Mission Time
                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "Mission Time"
                            font.pixelSize: 10
                            color: "#333"
                            horizontalAlignment: Text.AlignHCenter
                        }
                        TextField {
                            id: missionTimeDisplay
                            text: backend ? backend.missionTime : "-"
                            readOnly: true
                            implicitWidth: 130
                            color: "#333"
                            font.pixelSize: 11
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "#f8f9fa"
                                border.color: "#ced4da"
                                border.width: 1
                                radius: 3
                            }
                            ToolTip.text: "Mission elapsed time"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }
                    }

                    // Epoch Time
                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "Epoch Time"
                            font.pixelSize: 10
                            color: "#333"
                            horizontalAlignment: Text.AlignHCenter
                        }
                        TextField {
                            id: epochTimeDisplay
                            text: backend ? backend.epochTime : "-"
                            readOnly: true
                            implicitWidth: 130
                            color: "#333"
                            font.pixelSize: 11
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "#f8f9fa"
                                border.color: "#ced4da"
                                border.width: 1
                                radius: 3
                            }
                            ToolTip.text: "Time since epoch"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }
                    }

                    // Zulu Time
                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "Zulu Time"
                            font.pixelSize: 10
                            color: "#333"
                            horizontalAlignment: Text.AlignHCenter
                        }
                        TextField {
                            id: zuluTimeDisplay
                            text: backend ? backend.zuluTime : "-"
                            readOnly: true
                            implicitWidth: 130
                            color: "#333"
                            font.pixelSize: 11
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "#f8f9fa"
                                border.color: "#ced4da"
                                border.width: 1
                                radius: 3
                            }
                            ToolTip.text: "Wall clock time (UTC + 0)"
                            ToolTip.visible: hovered
                            ToolTip.delay: 500
                        }
                    }
                }
            }
        }

        // Main Content Area with Resizable Split Layout
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            // Main left section with simulation models and variables
            SplitView {
                SplitView.fillWidth: true
                orientation: Qt.Horizontal

                // Simulation Models Panel
                Rectangle {
                    SplitView.minimumWidth: 200
                    SplitView.preferredWidth: 300
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
                                id: modelsTreeListView
                                model: ListModel {
                                    id: modelsTreeModel
                                }

                                delegate: Rectangle {
                                    width: modelsTreeListView.width
                                    height: 25
                                    color: mouseArea.containsMouse ? "#e9ecef" : "transparent"

                                    MouseArea {
                                        id: mouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            console.log("Selected:", model.name);
                                        }
                                        onDoubleClicked: {
                                            // Only add leaf nodes (items with fullPath) to variables
                                            if (model.fullPath && model.fullPath !== "") {
                                                console.log("Adding to watch:", model.fullPath);
                                                if (backend) {
                                                    var success = backend.addVariableToWatch(model.fullPath, model.name.trim().replace(/^[-\s]*/, ''));
                                                    if (success) {
                                                        console.log("Successfully added:", model.fullPath);
                                                    } else {
                                                        console.log("Variable already being watched:", model.fullPath);
                                                    }
                                                }
                                            }
                                        }
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

                // Variables Panel
                Rectangle {
                    SplitView.fillWidth: true
                    SplitView.minimumWidth: 400
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

                                Text {
                                    text: "Variable"
                                    Layout.preferredWidth: 200
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: "Description"
                                    Layout.fillWidth: true
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: "Value"
                                    Layout.preferredWidth: 150
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: "Type"
                                    Layout.preferredWidth: 100
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                            }
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ListView {
                                id: variablesListView
                                model: ListModel {
                                    id: variablesModel
                                    // Dynamic model - variables added via backend signals
                                }

                                delegate: Rectangle {
                                    width: parent ? parent.width : 0
                                    height: 25
                                    color: index % 2 ? "#f8f9fa" : "white"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 0

                                        Text {
                                            text: model.variablePath || model.variable || ""
                                            Layout.preferredWidth: 200
                                            font.pixelSize: 11
                                            color: "#333"
                                        }
                                        Text {
                                            text: model.description || ""
                                            Layout.fillWidth: true
                                            font.pixelSize: 11
                                            color: "#333"
                                        }
                                        Text {
                                            text: model.value || ""
                                            Layout.preferredWidth: 150
                                            font.pixelSize: 11
                                            color: "#333"
                                        }
                                        Text {
                                            text: model.type
                                            Layout.preferredWidth: 100
                                            font.pixelSize: 11
                                            color: "#666"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Event Logs Panel
            Rectangle {
                SplitView.minimumWidth: 250
                SplitView.preferredWidth: 350
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

                            Text {
                                text: "Level"
                                Layout.preferredWidth: 70
                                font.bold: true
                                font.pixelSize: 12
                            }
                            Text {
                                text: "Log"
                                Layout.fillWidth: true
                                font.bold: true
                                font.pixelSize: 12
                            }
                        }
                    }

                    // Container for ScrollView and auto-scroll button
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ScrollView {
                            anchors.fill: parent

                            ListView {
                                id: eventLogsListView
                                model: ListModel {
                                    id: eventLogsModel
                                    ListElement {
                                        level: "INFO"
                                        log: "Simulator initialized successfully"
                                    }
                                    ListElement {
                                        level: "INFO"
                                        log: "Loading spacecraft configuration..."
                                    }
                                    ListElement {
                                        level: "WARNING"
                                        log: "Battery level below optimal range"
                                    }
                                    ListElement {
                                        level: "INFO"
                                        log: "Orbit propagation started"
                                    }
                                    ListElement {
                                        level: "DEBUG"
                                        log: "Attitude control system active"
                                    }
                                    ListElement {
                                        level: "INFO"
                                        log: "Telemetry data received"
                                    }
                                    ListElement {
                                        level: "ERROR"
                                        log: "Communication timeout"
                                    }
                                    ListElement {
                                        level: "INFO"
                                        log: "System recovery completed"
                                    }
                                    ListElement {
                                        level: "CRITICAL"
                                        log: "Critical failure in power system"
                                    }
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
                                        Qt.callLater(function() {
                                            positionViewAtIndex(count - 1, ListView.End);
                                        });
                                        userAtBottom = true;
                                    }
                                }

                                // Initialize as being at bottom with auto-scroll enabled
                                Component.onCompleted: {
                                    Qt.callLater(function() {
                                        if (count > 0) {
                                            positionViewAtIndex(count - 1, ListView.End);
                                        }
                                    });
                                    userAtBottom = true;
                                    autoScrollEnabled = true;
                                }

                                delegate: Rectangle {
                                    width: parent ? parent.width : 0
                                    height: 40
                                    color: {
                                        if (model.level === "ERROR")
                                            return "#ffe6e6";
                                        if (model.level === "WARNING")
                                            return "#fff3cd";
                                        if (model.level === "CRITICAL")
                                            return "#ff0000";
                                        return index % 2 ? "#f8f9fa" : "white";
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 5

                                        Rectangle {
                                            Layout.preferredWidth: 60
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
                                color: parent.pressed ? "#0056b3" : "#007bff"
                                radius: 20
                                border.color: "#0056b3"
                                border.width: 1

                                // Drop shadow effect
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    anchors.leftMargin: 2
                                    color: "#00000040"
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
                text: window.statusText
                font.pixelSize: 12
                color: "#333"
            }
        }
    }

    // Progress Dialog for time-based simulation progression
    ProgressDialog {
        id: progressDialog
    }

    // Scale Dialog for simulation rate control
    ScaleDialog {
        id: scaleDialog
    }
}
