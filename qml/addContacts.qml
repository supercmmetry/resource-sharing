import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0

import "Global"


ApplicationWindow {
    id: window
    visible: true
    width: 240
    height: 200
    minimumHeight: 240
    minimumWidth: 200
    maximumWidth: 200
    maximumHeight: 240
    flags: Qt.Window | Qt.WindowTitleHint | Qt.CustomizeWindowHint
    title: "Add New Contact"
    color: Resources.contactHeaderContainerBackgroundColor
    Rectangle {
        id: container
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: Resources.contactHeaderContainerBackgroundColor
        Text {
            id: dhtIdHeader
            
            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
            width: parent.width / 2
            color: Resources.contactHeaderContainerForegroundColor
            font.family: "Segoe UI"
            font.pointSize: 13
            text:"IP Address: "
            bottomPadding: 5

        }

        TextField {
            id: dhtIdField
            color: Resources.contactSearchBarContainerForegroundColor
            font.pointSize: Resources.contactSearchBarContainerFontPointSize
            placeholderText: "Enter IP Address"
            placeholderTextColor: Resources.contactSearchBarContainerPlaceholderColor
            leftPadding: 0

            anchors.top: dhtIdHeader.bottom
            anchors.left: dhtIdHeader.left
            anchors.right: dhtIdHeader.right

            bottomPadding: 15
            background: Rectangle {
                width: parent.width
                height: parent.height
                color: Resources.transparentColor
            }

        }


        Text {
            id: nameHeader
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dhtIdField.bottom
            width: parent.width / 2
            color: Resources.contactHeaderContainerForegroundColor
            font.family: "Segoe UI"
            font.pointSize: 13
            text:"Name: "
            bottomPadding: 5

        }

        TextField {
            id: nameField
            color: Resources.contactSearchBarContainerForegroundColor
            font.pointSize: Resources.contactSearchBarContainerFontPointSize
            placeholderText: "Enter Name"
            placeholderTextColor: Resources.contactSearchBarContainerPlaceholderColor
            leftPadding: 0

            anchors.top: nameHeader.bottom
            anchors.left: dhtIdHeader.left
            anchors.right: dhtIdHeader.right

            bottomPadding: 5
            background: Rectangle {
                width: parent.width
                height: parent.height
                color: Resources.transparentColor
            }

        }

        RoundButton {
            id: btnCancel
            x: 10
            y: parent.height - height - 10
            height: 30
            width: 60
            radius: 5

            

            background: Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "#5e5c8d"
                border.color: "white"
                border.width: 1

                Text {
                    id: btnCancelText
                    text: "Cancel"
                    anchors.centerIn: parent
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                        parent.color = containsMouse ? "#3e3c6d" : "#5e5c8d";
                    }

                    onClicked: {
                        dhtIdField.text = ""
                        nameField.text = ""
                        window.close()
                    }
                }
            }
        }

        RoundButton {
            id: btnAdd
            x: parent.width - width - 10
            y: parent.height - height - 10
            height: 30
            width: 60
            radius: 5
            background: Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "#5e5c8d"
                border.color: "white"
                border.width: 1

                Text {
                    id: btnAddText
                    text: "Add"
                    anchors.centerIn: parent
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                        parent.color = containsMouse ? "#3e3c6d" : "#5e5c8d";
                    }

                    onClicked: {
                        if(dhtIdField.text.length > 0 && nameField.text.length > 0) {
                            mainBackend.addContact(dhtIdField.text, nameField.text)
                            window.close()
                        }
                    }
                }
            }
        }
    }
}