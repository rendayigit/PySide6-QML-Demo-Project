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
    readonly property color dark_titleBarForeground: "#ffffff"

    readonly property color dark_componentBackground: "#353535"
    readonly property color dark_componentForeground: "#ffffff"

    readonly property color dark_primaryComponentBackground: "#3584e4"
    readonly property color dark_primaryComponentForeground: "#242424"

    readonly property color dark_secondaryComponentBackground: "#6f6f6f"
    readonly property color dark_secondaryComponentForeground: "#ffffff"

    readonly property color dark_tertiaryComponentBackground: "#444444"
    readonly property color dark_tertiaryComponentForeground: "#ffffff"

    readonly property color dark_alternativePrimaryComponentBackground: "#494949"
    readonly property color dark_alternativePrimaryComponentForeground: "#ffffff"

    readonly property color dark_alternativeSecondaryComponentBackground: "#a4a4a4"
    readonly property color dark_alternativeSecondaryComponentForeground: "#000000"

    readonly property color dark_destructiveBackground: "#c01c28"
    readonly property color dark_destructiveForeground: "#ffffff"

    readonly property color dark_successBackground: "#26a269"
    readonly property color dark_successForeground: "#ffffff"

    readonly property color dark_warningBackground: "#cd9309"
    readonly property color dark_warningForeground: "#000000"

    readonly property color dark_infoBackground: "#ffff0d"
    readonly property color dark_infoForeground: "#000000"

    readonly property color dark_border: "#000040"

    readonly property color darkBlue_background1: "#303340" // TODO: Implement
    readonly property color darkBlue_background2: "#272a34" // TODO: Implement
    readonly property color darkBlue_background3: "#23252e" // TODO: Implement
    readonly property color darkBlue_background4: "#1a1c23" // TODO: Implement

    // Light Theme Colors
    readonly property color light_windowBackground: "#fafafa"
    readonly property color light_windowForeground: "#000000"
    
    readonly property color light_titleBarBackground: "#ebebeb"
    readonly property color light_titleBarForeground: "#2c2c2c"

    readonly property color light_componentBackground: "#ffffff"
    readonly property color light_componentForeground: "#2c2c2c"

    readonly property color light_primaryComponentBackground: "#3584e4"
    readonly property color light_primaryComponentForeground: "#242424"

    readonly property color light_secondaryComponentBackground: "#e0e0e0"
    readonly property color light_secondaryComponentForeground: "#000000"

    readonly property color light_tertiaryComponentBackground: "#999999"
    readonly property color light_tertiaryComponentForeground: "#000000"

    readonly property color light_alternativePrimaryComponentBackground: "#ebebeb"
    readonly property color light_alternativePrimaryComponentForeground: "#000000"

    readonly property color light_alternativeSecondaryComponentBackground: "#f0f0f0"
    readonly property color light_alternativeSecondaryComponentForeground: "#000000"

    readonly property color light_destructiveBackground: "#e01b24"
    readonly property color light_destructiveForeground: "#ffffff"

    readonly property color light_successBackground: "#2ec27e"
    readonly property color light_successForeground: "#ffffff"

    readonly property color light_warningBackground: "#e5a50a"
    readonly property color light_warningForeground: "#000000"

    readonly property color light_infoBackground: "#ffff0d"
    readonly property color light_infoForeground: "#000000"

    readonly property color light_border: "#000012"

    // --- Logical Color Roles (used by QML components) ---
    property color windowBackground : currentTheme === "dark" ? dark_windowBackground : light_windowBackground
    property color windowForeground : currentTheme === "dark" ? dark_windowForeground : light_windowForeground

    property color titleBarBackground : currentTheme === "dark" ? dark_titleBarBackground : light_titleBarBackground
    property color titleBarForeground : currentTheme === "dark" ? dark_titleBarForeground : light_titleBarForeground

    property color componentBackground : currentTheme === "dark" ? dark_componentBackground : light_componentBackground
    property color componentForeground : currentTheme === "dark" ? dark_componentForeground : light_componentForeground
    property color componentHoverBackground : componentBackground.lighter(1.2)
    property color componentPressedBackground : componentBackground.darker(1.2)

    property color primaryComponentBackground : currentTheme === "dark" ? dark_primaryComponentBackground : light_primaryComponentBackground
    property color primaryComponentForeground : currentTheme === "dark" ? dark_primaryComponentForeground : light_primaryComponentForeground
    property color primaryComponentHoverBackground : primaryComponentBackground.lighter(1.2)
    property color primaryComponentPressedBackground : primaryComponentBackground.darker(1.2)

    property color secondaryComponentBackground : currentTheme === "dark" ? dark_secondaryComponentBackground : light_secondaryComponentBackground
    property color secondaryComponentForeground : currentTheme === "dark" ? dark_secondaryComponentForeground : light_secondaryComponentForeground
    property color secondaryComponentHoverBackground : secondaryComponentBackground.lighter(1.2)
    property color secondaryComponentPressedBackground : secondaryComponentBackground.darker(1.2)

    property color tertiaryComponentBackground : currentTheme === "dark" ? dark_tertiaryComponentBackground : light_tertiaryComponentBackground
    property color tertiaryComponentForeground : currentTheme === "dark" ? dark_tertiaryComponentForeground : light_tertiaryComponentForeground
    property color tertiaryComponentPressedBackground : tertiaryComponentBackground.darker(1.2)
    property color tertiaryComponentHoverBackground : tertiaryComponentBackground.lighter(1.2)

    property color alternativePrimaryComponentBackground : currentTheme === "dark" ? dark_alternativePrimaryComponentBackground : light_alternativePrimaryComponentBackground
    property color alternativePrimaryComponentForeground : currentTheme === "dark" ? dark_alternativePrimaryComponentForeground : light_alternativePrimaryComponentForeground
    property color alternativePrimaryComponentHoverBackground : alternativePrimaryComponentBackground.lighter(1.2)
    property color alternativePrimaryComponentPressedBackground : alternativePrimaryComponentBackground.darker(1.2)

    property color alternativeSecondaryComponentBackground : currentTheme === "dark" ? dark_alternativeSecondaryComponentBackground : light_alternativeSecondaryComponentBackground
    property color alternativeSecondaryComponentForeground : currentTheme === "dark" ? dark_alternativeSecondaryComponentForeground : light_alternativeSecondaryComponentForeground
    property color alternativeSecondaryComponentHoverBackground : alternativeSecondaryComponentBackground.lighter(1.2)
    property color alternativeSecondaryComponentPressedBackground : alternativeSecondaryComponentBackground.darker(1.2)

    property color destructiveBackground : currentTheme === "dark" ? dark_destructiveBackground : light_destructiveBackground
    property color destructiveForeground : currentTheme === "dark" ? dark_destructiveForeground : light_destructiveForeground
    property color destructiveHoverBackground : destructiveBackground.lighter(1.2)
    property color destructivePressedBackground : destructiveBackground.darker(1.2)

    property color border : currentTheme === "dark" ? dark_border : light_border

    property color successBackground : currentTheme === "dark" ? dark_successBackground : light_successBackground
    property color successForeground : currentTheme === "dark" ? dark_successForeground : light_successForeground
    property color successHoverBackground : successBackground.lighter(1.2)
    property color successPressedBackground : successBackground.darker(1.2)

    property color warningBackground : currentTheme === "dark" ? dark_warningBackground : light_warningBackground
    property color warningForeground : currentTheme === "dark" ? dark_warningForeground : light_warningForeground
    property color warningHoverBackground : warningBackground.lighter(1.2)
    property color warningPressedBackground : warningBackground.darker(1.2)

    property color infoBackground : currentTheme === "dark" ? dark_infoBackground : light_infoBackground
    property color infoForeground : currentTheme === "dark" ? dark_infoForeground : light_infoForeground
    property color infoHoverBackground : infoBackground.lighter(1.2)
    property color infoPressedBackground : infoBackground.darker(1.2)

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
