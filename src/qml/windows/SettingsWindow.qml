import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../services"

/**
 * SettingsWindow - Application settings configuration window
 *
 * This window provides user interface for configuring application settings.
 */
Window {
    id: root

    readonly property int min_width: 350
    readonly property int min_height: 250

    title: "Settings"

    width: min_width
    height: min_height

    minimumWidth: root.min_width
    minimumHeight: root.min_height

    // Properties for settings
    property string selectedTheme: "light" // Default to light theme

    // Signals for settings changes
    signal settingsApplied
    signal settingsCanceled

    color: ThemeManager.windowBackground

    // Load theme setting from ThemeManager on open
    Component.onCompleted: {
        // Set initial theme based on ThemeManager
        selectedTheme = ThemeManager.getCurrentTheme();
        themeSwitcher.isRightSelected = selectedTheme === "dark";
    }

    // Main content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Theme selection row
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Theme: "
                font.pixelSize: 12
                color: ThemeManager.componentForeground
            }

            Switcher {
                id: themeSwitcher

                Layout.preferredWidth: 150
                Layout.preferredHeight: 30

                leftText: "Light"
                rightText: "Dark"
                isRightSelected: root.selectedTheme === "dark"

                onOptionToggled: function (isRightSelected) {
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
                buttonText: "Okay"
                normalColor: ThemeManager.primaryComponentBackground
                hoveredColor: ThemeManager.primaryComponentHoverBackground
                pressedColor: ThemeManager.primaryComponentPressedBackground
                textColor: ThemeManager.primaryComponentForeground
                borderColor: ThemeManager.border

                onClicked: {
                    root.settingsApplied();
                    root.visible = false;
                }
            }

            CustomButton {
                buttonText: "Cancel"

                onClicked: {
                    root.close();
                }
            }
        }
    }
}
