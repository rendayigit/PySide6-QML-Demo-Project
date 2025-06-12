import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../components"
import "../services"

Window {
    id: progressWindow
    title: "Progress Simulation"
    width: 520
    height: 200
    visible: false
    modality: Qt.NonModal  // Allow interaction with main window
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint

    // Signals for window actions
    signal progressSimulationRequested(int totalMilliseconds)
    signal windowCloseRequested

    color: ThemeManager.windowBackground

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Time selection row
        RowLayout {
            spacing: 15
            Layout.alignment: Qt.AlignHCenter

            TimeSpinBox {
                id: daysSpinBox
                label: "Days:"
                minimumValue: 0
                maximumValue: 999999
                currentValue: 0
                spinBoxWidth: 80
            }

            TimeSpinBox {
                id: hoursSpinBox
                label: "Hours:"
                minimumValue: 0
                maximumValue: 23
                currentValue: 0
                spinBoxWidth: 80
            }

            TimeSpinBox {
                id: minutesSpinBox
                label: "Minutes:"
                minimumValue: 0
                maximumValue: 59
                currentValue: 0
                spinBoxWidth: 80
            }

            TimeSpinBox {
                id: secondsSpinBox
                label: "Seconds:"
                minimumValue: 0
                maximumValue: 59
                currentValue: 0
                spinBoxWidth: 80
            }

            TimeSpinBox {
                id: millisecondsSpinBox
                label: "Milliseconds:"
                minimumValue: 0
                maximumValue: 999
                currentValue: 0
                spinBoxWidth: 100
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
                normalColor: "#ffcc00"
                pressedColor: "#e6b800"
                borderColor: "#d4af37"
                textColor: "black"
                boldText: true
                useLayoutAlignment: false
                posX: 0
                posY: 0

                onClicked: {
                    var days = daysSpinBox.value;
                    var hours = hoursSpinBox.value;
                    var minutes = minutesSpinBox.value;
                    var seconds = secondsSpinBox.value;
                    var milliseconds = millisecondsSpinBox.value;

                    // Convert all time components to total milliseconds
                    var totalMilliseconds = days * 86400000 + hours * 3600000 + minutes * 60000 + seconds * 1000 + milliseconds;

                    progressWindow.progressSimulationRequested(totalMilliseconds);
                }
            }

            CustomButton {
                buttonText: "Close"
                useLayoutAlignment: false
                posX: 0
                posY: 0

                onClicked: {
                    progressWindow.windowCloseRequested();
                }
            }
        }
    }
}
