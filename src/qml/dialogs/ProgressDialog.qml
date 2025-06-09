import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: progressDialog
    title: "Progress Simulation"
    width: 600
    height: 200
    modal: true
    anchors.centerIn: parent

    background: Rectangle {
        color: "#ffffff"
        border.color: "#dee2e6"
        border.width: 1
        radius: 4
    }

    contentItem: ColumnLayout {
        spacing: 20

        // Time selection row
        RowLayout {
            spacing: 20
            Layout.fillWidth: true

            // Hours
            ColumnLayout {
                spacing: 5
                Text {
                    text: "Hours:"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#333"
                }
                SpinBox {
                    id: hoursSpinBox
                    from: 0
                    to: 23
                    value: 0
                    implicitWidth: 80
                    
                    background: Rectangle {
                        color: "#ffffff"
                        border.color: "#ced4da"
                        border.width: 1
                        radius: 3
                    }
                    
                    contentItem: TextInput {
                        text: hoursSpinBox.textFromValue(hoursSpinBox.value, hoursSpinBox.locale)
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: !hoursSpinBox.editable
                        validator: hoursSpinBox.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }
                    
                    up.indicator: Rectangle {
                        x: hoursSpinBox.mirrored ? 0 : parent.width - width
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: hoursSpinBox.up.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▲"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                    
                    down.indicator: Rectangle {
                        x: hoursSpinBox.mirrored ? 0 : parent.width - width
                        y: parent.height / 2
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: hoursSpinBox.down.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▼"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // Minutes
            ColumnLayout {
                spacing: 5
                Text {
                    text: "Minutes:"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#333"
                }
                SpinBox {
                    id: minutesSpinBox
                    from: 0
                    to: 59
                    value: 0
                    implicitWidth: 80
                    
                    background: Rectangle {
                        color: "#ffffff"
                        border.color: "#ced4da"
                        border.width: 1
                        radius: 3
                    }
                    
                    contentItem: TextInput {
                        text: minutesSpinBox.textFromValue(minutesSpinBox.value, minutesSpinBox.locale)
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: !minutesSpinBox.editable
                        validator: minutesSpinBox.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }
                    
                    up.indicator: Rectangle {
                        x: minutesSpinBox.mirrored ? 0 : parent.width - width
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: minutesSpinBox.up.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▲"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                    
                    down.indicator: Rectangle {
                        x: minutesSpinBox.mirrored ? 0 : parent.width - width
                        y: parent.height / 2
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: minutesSpinBox.down.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▼"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // Seconds
            ColumnLayout {
                spacing: 5
                Text {
                    text: "Seconds:"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#333"
                }
                SpinBox {
                    id: secondsSpinBox
                    from: 0
                    to: 59
                    value: 0
                    implicitWidth: 80
                    
                    background: Rectangle {
                        color: "#ffffff"
                        border.color: "#ced4da"
                        border.width: 1
                        radius: 3
                    }
                    
                    contentItem: TextInput {
                        text: secondsSpinBox.textFromValue(secondsSpinBox.value, secondsSpinBox.locale)
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: !secondsSpinBox.editable
                        validator: secondsSpinBox.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }
                    
                    up.indicator: Rectangle {
                        x: secondsSpinBox.mirrored ? 0 : parent.width - width
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: secondsSpinBox.up.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▲"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                    
                    down.indicator: Rectangle {
                        x: secondsSpinBox.mirrored ? 0 : parent.width - width
                        y: parent.height / 2
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: secondsSpinBox.down.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▼"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // Milliseconds
            ColumnLayout {
                spacing: 5
                Text {
                    text: "Milliseconds:"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#333"
                }
                SpinBox {
                    id: millisecondsSpinBox
                    from: 0
                    to: 999
                    value: 0
                    implicitWidth: 100
                    
                    background: Rectangle {
                        color: "#ffffff"
                        border.color: "#ced4da"
                        border.width: 1
                        radius: 3
                    }
                    
                    contentItem: TextInput {
                        text: millisecondsSpinBox.textFromValue(millisecondsSpinBox.value, millisecondsSpinBox.locale)
                        font.pixelSize: 12
                        color: "#333"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: !millisecondsSpinBox.editable
                        validator: millisecondsSpinBox.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }
                    
                    up.indicator: Rectangle {
                        x: millisecondsSpinBox.mirrored ? 0 : parent.width - width
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: millisecondsSpinBox.up.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▲"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                    
                    down.indicator: Rectangle {
                        x: millisecondsSpinBox.mirrored ? 0 : parent.width - width
                        y: parent.height / 2
                        height: parent.height / 2
                        implicitWidth: 20
                        implicitHeight: 10
                        color: millisecondsSpinBox.down.pressed ? "#e6e6e6" : "#f8f9fa"
                        border.color: "#ced4da"
                        border.width: 1
                        
                        Text {
                            text: "▼"
                            font.pixelSize: 8
                            color: "#333"
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        // Buttons row
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Button {
                id: okayButton
                text: "Okay"
                implicitWidth: 80

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
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    var hours = hoursSpinBox.value;
                    var minutes = minutesSpinBox.value;
                    var seconds = secondsSpinBox.value;
                    var milliseconds = millisecondsSpinBox.value;

                    // Convert all time components to total milliseconds
                    var totalMilliseconds = (hours * 3600000) + (minutes * 60000) + (seconds * 1000) + milliseconds;

                    console.log("Progress simulation:", hours + "h", minutes + "m", seconds + "s", milliseconds + "ms");
                    console.log("Total milliseconds:", totalMilliseconds);
                    
                    if (backend) {
                        var success = backend.progressSimulation(totalMilliseconds);
                        if (success) {
                            console.log("PROGRESS command sent successfully");
                            progressDialog.close();
                        } else {
                            console.log("PROGRESS command failed");
                        }
                    }
                }
            }

            Button {
                id: closeButton
                text: "Close"
                implicitWidth: 80

                background: Rectangle {
                    color: parent.pressed ? "#e6e6e6" : "#f8f9fa"
                    radius: 4
                    border.color: "#ced4da"
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    color: "#333"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Progress dialog closed");
                    progressDialog.close();
                }
            }
        }
    }
}
