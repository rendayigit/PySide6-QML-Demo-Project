import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import "../components"
import "../services"

Window {
    id: root

    readonly property int min_width: 520
    readonly property int min_height: 200

    title: "Progress Simulation"

    width: min_width
    height: min_height

    minimumWidth: root.min_width
    minimumHeight: root.min_height

    // Signals for window actions
    signal progressSimulationRequested(string totalMilliseconds)
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
                buttonText: "Okay"
                normalColor: ThemeManager.primaryComponentBackground
                hoveredColor: ThemeManager.primaryComponentHoverBackground
                pressedColor: ThemeManager.primaryComponentPressedBackground
                borderColor: ThemeManager.border
                textColor: ThemeManager.primaryComponentForeground

                onClicked: {
                    var days = daysSpinBox.value;
                    var hours = hoursSpinBox.value;
                    var minutes = minutesSpinBox.value;
                    var seconds = secondsSpinBox.value;
                    var milliseconds = millisecondsSpinBox.value;

                    // Convert all time components to total milliseconds
                    var totalMilliseconds = days * 86400000 + hours * 3600000 + minutes * 60000 + seconds * 1000 + milliseconds;

                    root.progressSimulationRequested(totalMilliseconds.toString());
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
