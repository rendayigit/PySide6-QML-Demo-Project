pragma Singleton
import QtQuick
import QtCore

QtObject {
    id: root

    // Settings for persistence
    property Settings settings: Settings {
        category: "theme"
    }

    // Only allow 'light' or 'dark' theme - load from settings on startup
    property string currentTheme: "light"

    // --- Light Theme Colors (from light.css) ---
    readonly property color light_accentBg: "#2777ff"
    readonly property color light_accentFg: "#ffffff"
    readonly property color light_destructiveBg: "#e01b24"
    readonly property color light_destructiveFg: "#ffffff"
    readonly property color light_successBg: "#2ec27e"
    readonly property color light_successFg: "#ffffff"
    readonly property color light_warningBg: "#e5a50a"
    readonly property color light_warningFg: "#000000cc"
    readonly property color light_errorBg: "#e01b24"
    readonly property color light_errorFg: "#ffffff"
    readonly property color light_windowBg: "#fafafa"
    readonly property color light_windowFg: "#000000cc"
    readonly property color light_viewBg: "#ffffff"
    readonly property color light_viewFg: "#000000cc"
    readonly property color light_headerbarBg: "#ebebeb"
    readonly property color light_headerbarFg: "#000000cc"
    readonly property color light_sidebarBg: "#ebebeb"
    readonly property color light_sidebarFg: "#000000cc"
    readonly property color light_cardBg: "#ffffff"
    readonly property color light_cardFg: "#000000cc"
    readonly property color light_dialogBg: "#ffffff"
    readonly property color light_dialogFg: "#000000cc"
    readonly property color light_popoverBg: "#ffffff"
    readonly property color light_popoverFg: "#000000cc"
    readonly property color light_thumbnailBg: "#ffffff"
    readonly property color light_thumbnailFg: "#000000cc"
    readonly property color light_border: "#00000012"

    // --- Dark Theme Colors (from dark.css) ---
    readonly property color dark_accentBg: "#2777ff"
    readonly property color dark_accentFg: "#ffffff"
    readonly property color dark_destructiveBg: "#c01c28"
    readonly property color dark_destructiveFg: "#ffffff"
    readonly property color dark_successBg: "#26a269"
    readonly property color dark_successFg: "#ffffff"
    readonly property color dark_warningBg: "#cd9309"
    readonly property color dark_warningFg: "#000000cc"
    readonly property color dark_errorBg: "#c01c28"
    readonly property color dark_errorFg: "#ffffff"
    readonly property color dark_windowBg: "#23252e"
    readonly property color dark_windowFg: "#ffffff"
    readonly property color dark_viewBg: "#272a34"
    readonly property color dark_viewFg: "#ffffff"
    readonly property color dark_headerbarBg: "#1a1c23"
    readonly property color dark_headerbarFg: "#ffffff"
    readonly property color dark_sidebarBg: "#1a1c23"
    readonly property color dark_sidebarFg: "#ffffff"
    readonly property color dark_cardBg: "#ffffff0d"
    readonly property color dark_cardFg: "#ffffff"
    readonly property color dark_dialogBg: "#303340"
    readonly property color dark_dialogFg: "#ffffff"
    readonly property color dark_popoverBg: "#303340"
    readonly property color dark_popoverFg: "#ffffff"
    readonly property color dark_thumbnailBg: "#303340"
    readonly property color dark_thumbnailFg: "#ffffff"
    readonly property color dark_border: "#00000040"

    // --- Logical Color Roles (used by QML components) ---
    property color accentColor: currentTheme === "dark" ? dark_accentBg : light_accentBg
    property color accentHover: currentTheme === "dark" ? "#1a5fb4" : "#1c71d8"
    property color accentText: currentTheme === "dark" ? dark_accentFg : light_accentFg
    property color destructiveColor: currentTheme === "dark" ? dark_destructiveBg : light_destructiveBg
    property color destructiveText: currentTheme === "dark" ? dark_destructiveFg : light_destructiveFg
    property color successColor: currentTheme === "dark" ? dark_successBg : light_successBg
    property color successText: currentTheme === "dark" ? dark_successFg : light_successFg
    property color warningColor: currentTheme === "dark" ? dark_warningBg : light_warningBg
    property color warningText: currentTheme === "dark" ? dark_warningFg : light_warningFg
    property color errorColor: currentTheme === "dark" ? dark_errorBg : light_errorBg
    property color errorText: currentTheme === "dark" ? dark_errorFg : light_errorFg
    property color windowBackground: currentTheme === "dark" ? dark_windowBg : light_windowBg
    property color windowText: currentTheme === "dark" ? dark_windowFg : light_windowFg
    property color panelBackground: currentTheme === "dark" ? dark_viewBg : light_viewBg
    property color panelText: currentTheme === "dark" ? dark_viewFg : light_viewFg
    property color headerBackground: currentTheme === "dark" ? dark_headerbarBg : light_headerbarBg
    property color headerText: currentTheme === "dark" ? dark_headerbarFg : light_headerbarFg
    property color sidebarBackground: currentTheme === "dark" ? dark_sidebarBg : light_sidebarBg
    property color sidebarText: currentTheme === "dark" ? dark_sidebarFg : light_sidebarFg
    property color cardBackground: currentTheme === "dark" ? dark_cardBg : light_cardBg
    property color cardText: currentTheme === "dark" ? dark_cardFg : light_cardFg
    property color dialogBackground: currentTheme === "dark" ? dark_dialogBg : light_dialogBg
    property color dialogText: currentTheme === "dark" ? dark_dialogFg : light_dialogFg
    property color popoverBackground: currentTheme === "dark" ? dark_popoverBg : light_popoverBg
    property color popoverText: currentTheme === "dark" ? dark_popoverFg : light_popoverFg
    property color thumbnailBackground: currentTheme === "dark" ? dark_thumbnailBg : light_thumbnailBg
    property color thumbnailText: currentTheme === "dark" ? dark_thumbnailFg : light_thumbnailFg
    property color borderColor: currentTheme === "dark" ? dark_border : light_border
    
    // Convenience aliases
    property color primaryText: windowText
    property color secondaryText: currentTheme === "dark" ? "#cccccc" : "#666666"
    property color disabledText: currentTheme === "dark" ? "#808080" : "#999999"
    property color buttonBackground: currentTheme === "dark" ? "#404040" : "#e0e0e0"
    property color buttonHover: currentTheme === "dark" ? "#505050" : "#d0d0d0"
    property color buttonPressed: currentTheme === "dark" ? "#606060" : "#c0c0c0"
    property color buttonText: windowText
    property color inputBackground: panelBackground
    property color inputBorder: borderColor
    property color inputText: windowText
    property color placeholderText: secondaryText
    property color selectionBackground: currentTheme === "dark" ? "#404040" : "#e0e0e0"
    property color highlightBackground: currentTheme === "dark" ? "#333333" : "#f0f0f0"
    property color hoverBackground: currentTheme === "dark" ? "#353535" : "#f5f5f5"
    property color statusBarBackground: headerBackground
    property color statusBarBorder: borderColor

    // --- Theme switching with persistence ---
    function setTheme(theme) {
        if (theme === "light" || theme === "dark") {
            currentTheme = theme;
            settings.setValue("selectedTheme", theme);  // Save to persistent storage
            console.log("Theme changed to:", theme, "and saved to settings");
        } else {
            console.warn("Invalid theme:", theme, "- using light theme");
            currentTheme = "light";
            settings.setValue("selectedTheme", "light");
        }
    }
    
    function toggleTheme() {
        setTheme(currentTheme === "dark" ? "light" : "dark");
    }
    
    function getCurrentTheme() {
        return currentTheme;
    }
    
    // Initialize theme on component completion
    Component.onCompleted: {
        // Load saved theme or default to light
        var savedTheme = settings.value("selectedTheme", "light");
        if (savedTheme === "light" || savedTheme === "dark") {
            currentTheme = savedTheme;
            console.log("Loaded theme from settings:", savedTheme);
        } else {
            console.log("Invalid saved theme:", savedTheme, "- using light theme");
            setTheme("light");
        }
    }
}
