import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../components"
import "../services"

/**
 * ScaleWindow - Simulation rate scale window component
 *
 * This window allows users to set the simulation rate scale.
 * Uses signals for clean separation of concerns.
 */
Window {
    id: root

    readonly property int min_width: 450
    readonly property int min_height: 150

    title: "Simulation Rate"

    width: min_width
    height: min_height

    minimumWidth: root.min_width
    minimumHeight: root.min_height

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
                color: ThemeManager.componentForeground
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
                    color: ThemeManager.primaryComponentBackground
                    border.color: ThemeManager.border
                    border.width: 1
                    radius: 3
                }

                color: ThemeManager.primaryComponentForeground
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
                    color: ThemeManager.componentBackground

                    Rectangle {
                        width: scaleSlider.visualPosition * parent.width
                        height: parent.height
                        color: ThemeManager.primaryComponentBackground
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: scaleSlider.leftPadding + scaleSlider.visualPosition * (scaleSlider.availableWidth - width)
                    y: scaleSlider.topPadding + scaleSlider.availableHeight / 2 - height / 2
                    implicitWidth: 18
                    implicitHeight: 18
                    radius: 9
                    color: scaleSlider.pressed ? ThemeManager.primaryComponentPressedBackground : ThemeManager.primaryComponentBackground
                    border.color: ThemeManager.componentBackground
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
                buttonText: "Okay"
                normalColor: ThemeManager.primaryComponentBackground
                hoveredColor: ThemeManager.primaryComponentHoverBackground
                pressedColor: ThemeManager.primaryComponentPressedBackground
                textColor: ThemeManager.primaryComponentForeground
                borderColor: ThemeManager.border

                onClicked: {
                    var scaleValue = parseFloat(scaleTextField.text);

                    if (isNaN(scaleValue) || scaleValue <= 0.0) {
                        console.log("Invalid scale value:", scaleTextField.text);
                        scaleTextField.text = "1.0";
                        scaleSlider.value = 10;
                        return;
                    }

                    console.log("Setting simulation rate scale to:", scaleValue);
                    root.scaleSimulationRequested(scaleValue);
                }
            }

            CustomButton {
                buttonText: "Close"

                onClicked: {
                    root.windowCloseRequested();
                }
            }
        }
    }
}
