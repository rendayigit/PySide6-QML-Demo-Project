import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * SettingsWindow - Application settings configuration window
 *
 * This window provides user interface for configuring application settings.
 */
Window {
    id: root

    title: "Settings"
    width: 400
    height: 300
    minimumWidth: 350
    minimumHeight: 250

    flags: Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint
    modality: Qt.NonModal

    // Properties for settings
    property string selectedTheme: "light" // Default to light theme

    // Signals for settings changes
    signal themeChanged(string theme)
    signal settingsApplied
    signal settingsCanceled

    // Main content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                text: "Theme:"
                font.pixelSize: 12
                color: "#333"
            }

            Switcher {
                id: themeSwitcher
                leftText: "Light"
                rightText: "Dark"
                isRightSelected: root.selectedTheme === "dark"
                Layout.alignment: Qt.AlignLeft

                onOptionToggled: {
                    root.selectedTheme = isRightSelected ? "dark" : "light";
                }
            }
        }

        // Spacer to push buttons to bottom
        Item {
            Layout.fillHeight: true
        }

        // Button row
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Spacer to push buttons to the right
            Item {
                Layout.fillWidth: true
            }

            CustomButton {
                buttonText: "Apply"
                buttonWidth: 80
                buttonHeight: 30
                normalColor: "#10b981"
                pressedColor: "#059669"
                borderColor: "#047857"
                textColor: "white"
                boldText: true

                onClicked: {
                    root.themeChanged(root.selectedTheme);
                    root.settingsApplied();
                }
            }

            CustomButton {
                buttonText: "Cancel"
                buttonWidth: 80
                buttonHeight: 30
                normalColor: "#6b7280"
                pressedColor: "#4b5563"
                borderColor: "#374151"
                textColor: "white"

                onClicked: {
                    root.settingsCanceled();
                    root.visible = false;
                }
            }

            CustomButton {
                buttonText: "OK"
                buttonWidth: 80
                buttonHeight: 30
                normalColor: "#3b82f6"
                pressedColor: "#2563eb"
                borderColor: "#1d4ed8"
                textColor: "white"
                boldText: true

                onClicked: {
                    root.themeChanged(root.selectedTheme);
                    root.settingsApplied();
                    root.visible = false;
                }
            }
        }
    }
}
