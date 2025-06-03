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
                text: parent.title
                color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                font.bold: true
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                
                Label {
                    text: "Theme:"
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                }
                
                Switch {
                    id: themeSwitch
                    text: checked ? "Dark" : "Light"
                    checked: settingsDialog.isDarkTheme
                    
                    onToggled: {
                        settingsDialog.isDarkTheme = checked
                        settingsDialog.themeChanged(checked)
                    }
                    
                    // Custom styling for the switch
                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 26
                        x: themeSwitch.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: themeSwitch.checked ? "#2196F3" : (settingsDialog.isDarkTheme ? "#555555" : "#cccccc")
                        border.color: themeSwitch.checked ? "#2196F3" : (settingsDialog.isDarkTheme ? "#777777" : "#999999")
                        
                        Rectangle {
                            x: themeSwitch.checked ? parent.width - width - 2 : 2
                            y: 2
                            width: 22
                            height: 22
                            radius: 11
                            color: "#ffffff"
                            border.color: themeSwitch.checked ? "#2196F3" : "#999999"
                            
                            Behavior on x {
                                NumberAnimation { duration: 200 }
                            }
                        }
                    }
                    
                    contentItem: Text {
                        text: themeSwitch.text
                        font: themeSwitch.font
                        opacity: enabled ? 1.0 : 0.3
                        color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: themeSwitch.indicator.width + themeSwitch.spacing
                    }
                }
                
                Item {
                    Layout.fillWidth: true
                }
            }
        }
        
        // Spacer
        Item {
            Layout.fillHeight: true
        }
        
        // Buttons
        RowLayout {
            Layout.fillWidth: true
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "OK"
                onClicked: settingsDialog.accept()
                
                background: Rectangle {
                    color: parent.pressed ? (settingsDialog.isDarkTheme ? "#1976D2" : "#1976D2") : 
                           parent.hovered ? (settingsDialog.isDarkTheme ? "#2196F3" : "#2196F3") :
                           (settingsDialog.isDarkTheme ? "#2196F3" : "#2196F3")
                    radius: 4
                    border.color: settingsDialog.isDarkTheme ? "#1976D2" : "#1976D2"
                    border.width: 1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                text: "Cancel"
                onClicked: settingsDialog.reject()
                
                background: Rectangle {
                    color: parent.pressed ? (settingsDialog.isDarkTheme ? "#424242" : "#e0e0e0") : 
                           parent.hovered ? (settingsDialog.isDarkTheme ? "#555555" : "#f5f5f5") :
                           (settingsDialog.isDarkTheme ? "#3c3c3c" : "#ffffff")
                    radius: 4
                    border.color: settingsDialog.isDarkTheme ? "#555555" : "#cccccc"
                    border.width: 1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: settingsDialog.isDarkTheme ? "#ffffff" : "#333333"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
