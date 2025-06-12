import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../components" // Import CustomButton

/**
 * ScaleWindow - Simulation rate scale window component
 *
 * This window allows users to set the simulation rate scale.
 * Uses signals for clean separation of concerns.
 */
Window {
    id: scaleWindow

    title: "Simulation Rate"
    width: 450
    height: 150
    visible: false
    modality: Qt.NonModal  // Allow interaction with main window
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint

    // Signals for window actions
    signal scaleSimulationRequested(real scaleValue)
    signal windowCloseRequested

    color: ThemeManager.windowBackground

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Scale selection row
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "Scale:"
                font.pixelSize: 12
                font.bold: true
                color: ThemeManager.primaryText
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
                    color: ThemeManager.inputBackground
                    border.color: ThemeManager.inputBorderColor
                    border.width: 1
                    radius: 3
                }

                color: ThemeManager.inputText
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
                    color: ThemeManager.alternateBackground

                    Rectangle {
                        width: scaleSlider.visualPosition * parent.width
                        height: parent.height
                        color: ThemeManager.specialColor
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: scaleSlider.leftPadding + scaleSlider.visualPosition * (scaleSlider.availableWidth - width)
                    y: scaleSlider.topPadding + scaleSlider.availableHeight / 2 - height / 2
                    implicitWidth: 18
                    implicitHeight: 18
                    radius: 9
                    color: scaleSlider.pressed ? ThemeManager.specialColorPressed : ThemeManager.specialColor
                    border.color: ThemeManager.specialColorBorder
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

            CustomButton {
                id: okayButton

                buttonText: "Okay"
                normalColor: ThemeManager.specialColor
                pressedColor: ThemeManager.specialColorPressed
                borderColor: ThemeManager.specialColorBorder
                textColor: ThemeManager.primaryText
                boldText: true
                useLayoutAlignment: false
                posX: 0
                posY: 0

                onClicked: {
                    var scaleValue = parseFloat(scaleTextField.text);
                    
                    if (isNaN(scaleValue) || scaleValue <= 0.0) {
                        console.log("Invalid scale value:", scaleTextField.text);
                        scaleTextField.text = "1.0";
                        scaleSlider.value = 10;
                        return;
                    }

                    console.log("Setting simulation rate scale to:", scaleValue);
                    scaleWindow.scaleSimulationRequested(scaleValue);
                }
            }

            CustomButton {
                buttonText: "Close"
                useLayoutAlignment: false
                posX: 0
                posY: 0

                onClicked: {
                    scaleWindow.windowCloseRequested();
                }
            }
        }
    }
}
