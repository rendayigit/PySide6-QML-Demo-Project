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

    readonly property color accent: "#2777ff"

    // Dark Theme Colors
    readonly property color dark_windowBackground: "#242424"
    readonly property color dark_windowForeground: "#ffffff"
    readonly property color dark_titleBarBackground: "#303030"
    readonly property color dark_componentBackground: "#353535"
    readonly property color dark_componentHoverBackground: "#3b3b3b"
    readonly property color dark_componentForeground: "#ffffff"
    readonly property color dark_primaryComponentBackground: "#3584e4"
    readonly property color dark_primaryComponentHoverBackground: "#4990e7"
    readonly property color dark_secondaryComponentBackground: "#6f6f6f"
    readonly property color dark_secondaryComponentHoverBackground: "#787878"
    readonly property color dark_tertiaryComponentBackground: "#444444"
    readonly property color dark_tertiaryComponentHoverBackground: "#4f4f4f"
    readonly property color dark_alternativePrimaryComponentBackground: "#494949"
    readonly property color dark_alternativePrimaryComponentHoverBackground: "#585858"
    readonly property color dark_alternativeSecondaryComponentBackground: "#a4a4a4"
    readonly property color dark_alternativeSecondaryComponentHoverBackground: "#a7a7a7"
    readonly property color dark_destructiveBackground: "#c01c28"
    readonly property color dark_destructiveHoverBackground: "#c6323d"
    readonly property color dark_destructiveForeground: "#ffffff"
    readonly property color dark_border: "#000040"
    readonly property color dark_successBackground: "#26a269"
    readonly property color dark_successForeground: "#ffffff"
    readonly property color dark_warningBackground: "#cd9309"
    readonly property color dark_warningForeground: "#000000"
    readonly property color dark_yellowBackground: "#ffff0d"
    readonly property color darkBlue_background1: "#303340"
    readonly property color darkBlue_background2: "#272a34"
    readonly property color darkBlue_background3: "#23252e"
    readonly property color darkBlue_background4: "#1a1c23"

    // Light Theme Colors
    readonly property color light_windowBackground: "#fafafa"
    readonly property color light_windowForeground: "#000000cc"
    readonly property color light_titleBarBackground: "#ebebeb"
    readonly property color light_componentBackground: "#ffffff"
    readonly property color light_componentHoverBackground: "#f9f9f9"
    readonly property color light_componentForeground: "#2c2c2c"
    readonly property color light_primaryComponentBackground: "#3584e4"
    readonly property color light_primaryComponentHoverBackground: "#4990e7"
    readonly property color light_secondaryComponentBackground: "#e0e0e0"
    readonly property color light_secondaryComponentHoverBackground: "#cccccc"
    readonly property color light_tertiaryComponentBackground: "#999999"
    readonly property color light_tertiaryComponentHoverBackground: "#949494"
    readonly property color light_alternativePrimaryComponentBackground: "#ebebeb"
    readonly property color light_alternativePrimaryComponentHoverBackground: "#dbdbdb"
    readonly property color light_alternativeSecondaryComponentBackground: "#f0f0f0"
    readonly property color light_alternativeSecondaryComponentHoverBackground: "#f3f3f3"
    readonly property color light_destructiveBackground: "#e01b24"
    readonly property color light_destructiveHoverBackground: "#e33139"
    readonly property color light_destructiveForeground: "#ffffff"
    readonly property color light_border: "#000012"
    readonly property color light_successBackground: "#2ec27e"
    readonly property color light_successForeground: "#ffffff"
    readonly property color light_warningBackground: "#e5a50a"
    readonly property color light_warningForeground: "#000000"
    readonly property color light_yellowBackground: "#ffff0d"

    // --- Logical Color Roles (used by QML components) ---
    property color windowBackground : currentTheme === "dark" ? dark_windowBackground : light_windowBackground
    property color windowForeground : currentTheme === "dark" ? dark_windowForeground : light_windowForeground
    property color titleBarBackground : currentTheme === "dark" ? dark_titleBarBackground : light_titleBarBackground
    property color componentBackground : currentTheme === "dark" ? dark_componentBackground : light_componentBackground
    property color componentHoverBackground : currentTheme === "dark" ? dark_componentHoverBackground : light_componentHoverBackground
    property color componentForeground : currentTheme === "dark" ? dark_componentForeground : light_componentForeground
    property color primaryComponentBackground : currentTheme === "dark" ? dark_primaryComponentBackground : light_primaryComponentBackground
    property color primaryComponentHoverBackground : currentTheme === "dark" ? dark_primaryComponentHoverBackground : light_primaryComponentHoverBackground
    property color secondaryComponentBackground : currentTheme === "dark" ? dark_secondaryComponentBackground : light_secondaryComponentBackground
    property color secondaryComponentHoverBackground : currentTheme === "dark" ? dark_secondaryComponentHoverBackground : light_secondaryComponentHoverBackground
    property color tertiaryComponentBackground : currentTheme === "dark" ? dark_tertiaryComponentBackground : light_tertiaryComponentBackground
    property color tertiaryComponentHoverBackground : currentTheme === "dark" ? dark_tertiaryComponentHoverBackground : light_tertiaryComponentHoverBackground
    property color alternativePrimaryComponentBackground : currentTheme === "dark" ? dark_alternativePrimaryComponentBackground : light_alternativePrimaryComponentBackground
    property color alternativePrimaryComponentHoverBackground : currentTheme === "dark" ? dark_alternativePrimaryComponentHoverBackground : light_alternativePrimaryComponentHoverBackground
    property color alternativeSecondaryComponentBackground : currentTheme === "dark" ? dark_alternativeSecondaryComponentBackground : light_alternativeSecondaryComponentBackground
    property color alternativeSecondaryComponentHoverBackground : currentTheme === "dark" ? dark_alternativeSecondaryComponentHoverBackground : light_alternativeSecondaryComponentHoverBackground
    property color destructiveBackground : currentTheme === "dark" ? dark_destructiveBackground : light_destructiveBackground
    property color destructiveHoverBackground : currentTheme === "dark" ? dark_destructiveHoverBackground : light_destructiveHoverBackground
    property color destructiveForeground : currentTheme === "dark" ? dark_destructiveForeground : light_destructiveForeground
    property color border : currentTheme === "dark" ? dark_border : light_border
    property color successBackground : currentTheme === "dark" ? dark_successBackground : light_successBackground
    property color successForeground : currentTheme === "dark" ? dark_successForeground : light_successForeground
    property color warningBackground : currentTheme === "dark" ? dark_warningBackground : light_warningBackground
    property color warningForeground : currentTheme === "dark" ? dark_warningForeground : light_warningForeground
    property color yellowBackground : currentTheme === "dark" ? dark_yellowBackground : light_yellowBackground

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
