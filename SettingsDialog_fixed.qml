pragma ComponentBehavior: Bound
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: settingsDialog
    title: "Settings"
    modal: true
    width: 400
    height: 300
    anchors.centerIn: parent
    
    property bool isDarkTheme: false
    
    signal themeChanged(bool darkTheme)
    
    background: Rectangle {
        color: settingsDialog.isDarkTheme ? "#3c3c3c" : "#ffffff"
        border.color: settingsDialog.isDarkTheme ? "#555555" : "#dee2e6"
        border.width: 1
        radius: 8
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Header
        Label {
            text: "Application Settings"
            font.pixelSize: 18
            font.bold: true
            color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
            Layout.fillWidth: true
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: settingsDialog.isDarkTheme ? "#555555" : "#dee2e6"
        }
        
        // Theme section
        GroupBox {
            title: "Appearance"
            Layout.fillWidth: true
            
            background: Rectangle {
                color: settingsDialog.isDarkTheme ? "#404040" : "#f8f9fa"
                border.color: settingsDialog.isDarkTheme ? "#555555" : "#dee2e6"
                border.width: 1
                radius: 4
            }
            
            label: Label {
                text: "Appearance"
                font.bold: true
                color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
            }
            
            RowLayout {
                anchors.fill: parent
                spacing: 10
                
                Label {
                    text: "Theme:"
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                    font.pixelSize: 14
                }
                
                Item { Layout.fillWidth: true }
                
                Label {
                    text: "Light"
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                    font.pixelSize: 12
                }
                
                Switch {
                    id: themeSwitch
                    checked: settingsDialog.isDarkTheme
                    
                    onCheckedChanged: {
                        settingsDialog.isDarkTheme = checked
                    }
                    
                    // Custom switch styling
                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 26
                        x: themeSwitch.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: themeSwitch.checked ? "#4CAF50" : "#E0E0E0"
                        border.color: themeSwitch.checked ? "#4CAF50" : "#CCCCCC"

                        Rectangle {
                            x: themeSwitch.checked ? parent.width - width - 2 : 2
                            y: 2
                            width: 22
                            height: 22
                            radius: 11
                            color: "white"
                            border.color: "#D0D0D0"
                            
                            Behavior on x {
                                NumberAnimation { duration: 200 }
                            }
                        }
                    }
                }
                
                Label {
                    text: "Dark"
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                    font.pixelSize: 12
                }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Item { Layout.fillWidth: true }
            
            Button {
                text: "Cancel"
                background: Rectangle {
                    color: parent.pressed ? (settingsDialog.isDarkTheme ? "#505050" : "#e9ecef") : (settingsDialog.isDarkTheme ? "#404040" : "#f8f9fa")
                    border.color: settingsDialog.isDarkTheme ? "#666666" : "#ced4da"
                    border.width: 1
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    // Reset theme to original state
                    themeSwitch.checked = settingsDialog.isDarkTheme
                    settingsDialog.close()
                }
            }
            
            Button {
                text: "OK"
                background: Rectangle {
                    color: parent.pressed ? "#0056b3" : "#007bff"
                    border.color: "#007bff"
                    border.width: 1
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    settingsDialog.themeChanged(themeSwitch.checked)
                    settingsDialog.close()
                }
            }
        }
    }
}
