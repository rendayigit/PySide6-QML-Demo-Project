import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: scaleDialog
    title: "Simulation Rate"
    width: 450
    height: 150
    modal: true
    anchors.centerIn: parent

    property string commandString: "RATE"  // Default command, can be overridden

    background: Rectangle {
        color: "#ffffff"
        border.color: "#dee2e6"
        border.width: 1
        radius: 4
    }

    contentItem: ColumnLayout {
        spacing: 20

        // Scale selection row
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "Scale:"
                font.pixelSize: 12
                font.bold: true
                color: "#333"
                Layout.alignment: Qt.AlignVCenter
            }

            TextField {
                id: scaleTextField
                text: "1.0"
                implicitWidth: 80
                validator: DoubleValidator {
                    bottom: 0.1
                    top: 10.0
                    decimals: 1
                }

                background: Rectangle {
                    color: "#ffffff"
                    border.color: "#ced4da"
                    border.width: 1
                    radius: 3
                }

                color: "#333"
                font.pixelSize: 12
                horizontalAlignment: TextInput.AlignHCenter

                onTextChanged: {
                    var value = parseFloat(text);
                    if (!isNaN(value) && value >= 0.1 && value <= 10.0) {
                        scaleSlider.value = value * 10;
                    }
                }
            }

            Slider {
                id: scaleSlider
                from: 1
                to: 100
                value: 10
                stepSize: 1
                Layout.fillWidth: true

                background: Rectangle {
                    x: scaleSlider.leftPadding
                    y: scaleSlider.topPadding + scaleSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: scaleSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#e9ecef"

                    Rectangle {
                        width: scaleSlider.visualPosition * parent.width
                        height: parent.height
                        color: "#ffcc00"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: scaleSlider.leftPadding + scaleSlider.visualPosition * (scaleSlider.availableWidth - width)
                    y: scaleSlider.topPadding + scaleSlider.availableHeight / 2 - height / 2
                    implicitWidth: 18
                    implicitHeight: 18
                    radius: 9
                    color: scaleSlider.pressed ? "#e6b800" : "#ffcc00"
                    border.color: "#d4af37"
                    border.width: 1
                }

                onValueChanged: {
                    var scaleValue = (value / 10.0).toFixed(1);
                    scaleTextField.text = scaleValue;
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
                    var scaleValue = parseFloat(scaleTextField.text);
                    
                    if (isNaN(scaleValue) || scaleValue <= 0.0) {
                        console.log("Invalid scale value:", scaleTextField.text);
                        scaleTextField.text = "1.0";
                        scaleSlider.value = 10;
                        return;
                    }

                    console.log("Setting simulation rate scale to:", scaleValue);
                    
                    if (backend) {
                        var success = backend.setSimulationRate(scaleValue);
                        if (success) {
                            console.log("RATE command sent successfully");
                            scaleDialog.close();
                        } else {
                            console.log("RATE command failed");
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
                    console.log("Scale dialog closed");
                    scaleDialog.close();
                }
            }
        }
    }
}
