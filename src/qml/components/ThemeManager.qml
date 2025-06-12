pragma Singleton
import QtQuick

/**
 * ThemeManager - Singleton for managing application theme colors
 *
 * This singleton provides theme-aware colors that automatically adapt
 * to the current application theme (light, dark, or auto).
 * All components should use these colors instead of hardcoded values.
 */
QtObject {
    id: root

    // Theme state properties
    property bool isDarkTheme: false
    property string currentTheme: "auto"

    // Update theme state when backend changes
    function updateThemeState(theme, systemDark) {
        currentTheme = theme;
        if (theme === "auto") {
            isDarkTheme = systemDark;
        } else {
            isDarkTheme = (theme === "dark");
        }
    }

    // Background colors
    readonly property color windowBackground: isDarkTheme ? "#2b2b2b" : "#f8f9fa"
    readonly property color surfaceBackground: isDarkTheme ? "#3c3c3c" : "#ffffff"
    readonly property color panelBackground: isDarkTheme ? "#404040" : "#f8f9fa"
    readonly property color alternateBackground: isDarkTheme ? "#484848" : "#f1f3f4"

    // Border colors
    readonly property color borderColor: isDarkTheme ? "#555555" : "#dee2e6"
    readonly property color focusBorderColor: isDarkTheme ? "#0078d4" : "#007bff"
    readonly property color inputBorderColor: isDarkTheme ? "#666666" : "#ced4da"

    // Text colors
    readonly property color primaryText: isDarkTheme ? "#ffffff" : "#212529"
    readonly property color secondaryText: isDarkTheme ? "#cccccc" : "#6c757d"
    readonly property color disabledText: isDarkTheme ? "#888888" : "#adb5bd"
    readonly property color placeholderText: isDarkTheme ? "#999999" : "#6c757d"

    // Button colors
    readonly property color primaryButtonBg: isDarkTheme ? "#0078d4" : "#007bff"
    readonly property color primaryButtonBgPressed: isDarkTheme ? "#106ebe" : "#0056b3"
    readonly property color primaryButtonBgHover: isDarkTheme ? "#1a7fd4" : "#0069d9"
    readonly property color primaryButtonText: "#ffffff"

    readonly property color secondaryButtonBg: isDarkTheme ? "#5a5a5a" : "#6c757d"
    readonly property color secondaryButtonBgPressed: isDarkTheme ? "#4a4a4a" : "#545b62"
    readonly property color secondaryButtonBgHover: isDarkTheme ? "#656565" : "#5a6268"
    readonly property color secondaryButtonText: "#ffffff"

    readonly property color cancelButtonBg: isDarkTheme ? "#6b7280" : "#6c757d"
    readonly property color cancelButtonBgPressed: isDarkTheme ? "#4b5563" : "#545b62"
    readonly property color cancelButtonText: "#ffffff"

    // Accent colors (theme-independent)
    readonly property color successColor: "#10b981"
    readonly property color successColorPressed: "#059669"
    readonly property color successColorBorder: "#047857"

    readonly property color warningColor: "#f59e0b"
    readonly property color warningColorPressed: "#d97706"
    readonly property color warningColorBorder: "#b45309"

    readonly property color errorColor: "#ef4444"
    readonly property color errorColorPressed: "#dc2626"
    readonly property color errorColorBorder: "#b91c1c"

    readonly property color specialColor: "#ffcc00"
    readonly property color specialColorPressed: "#e6b800"
    readonly property color specialColorBorder: "#d4af37"

    // Control colors
    readonly property color controlBackground: isDarkTheme ? "#484848" : "#f8f9fa"
    readonly property color controlBackgroundPressed: isDarkTheme ? "#3a3a3a" : "#e9ecef"
    readonly property color controlBackgroundHover: isDarkTheme ? "#525252" : "#f1f3f4"

    // Input colors
    readonly property color inputBackground: isDarkTheme ? "#3c3c3c" : "#ffffff"
    readonly property color inputBackgroundDisabled: isDarkTheme ? "#2a2a2a" : "#e9ecef"
    readonly property color inputText: isDarkTheme ? "#ffffff" : "#495057"

    // Selection colors
    readonly property color highlightColor: isDarkTheme ? "#0078d4" : "#007bff"
    readonly property color highlightTextColor: "#ffffff"
    readonly property color selectionColor: isDarkTheme ? "rgba(0, 120, 212, 0.3)" : "rgba(0, 123, 255, 0.25)"

    // Status bar colors
    readonly property color statusBarBackground: isDarkTheme ? "#404040" : "#f0f0f0"
    readonly property color statusBarBorder: isDarkTheme ? "#555555" : "#dee2e6"

    // Group box colors
    readonly property color groupBoxBorder: isDarkTheme ? "#555555" : "#dee2e6"
    readonly property color groupBoxBackground: isDarkTheme ? "#3c3c3c" : "#ffffff"
    readonly property color groupBoxTitle: isDarkTheme ? "#ffffff" : "#495057"
}
