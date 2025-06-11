import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components/dialogs"
import "../components" // Import CustomButton

Dialog {
    id: progressDialog
    title: "Progress Simulation"
    width: 600
    height: 200
    modal: true
    anchors.centerIn: parent

    // Signals for dialog actions
    signal progressSimulationRequested(int totalMilliseconds)
    signal dialogCloseRequested

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
            spacing: 15
            Layout.fillWidth: true

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

                    progressDialog.progressSimulationRequested(totalMilliseconds);
                }
            }

            CustomButton {
                buttonText: "Close"
                useLayoutAlignment: false
                posX: 0
                posY: 0

                onClicked: {
                    progressDialog.dialogCloseRequested();
                }
            }
        }
    }
}
