import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.12
import QtQuick.Dialogs 1.0
import QtGraphicalEffects 1.0

import "Global"

ApplicationWindow {
    id: window
    visible: true
    width: 960
    height: 480

    minimumHeight: 480
    minimumWidth: 640

    title: "Student Resource Management"
    flags: Qt.Window | Qt.FramelessWindowHint

    color: Resources.transparentColor

    property var isFullScreen: false
    property var prevHeight: 480
    property var prevWidth: 640
    property var prevWindowX: 0
    property var prevWindowY: 0


    Rectangle {
        id: windowLayer
        height: parent.height - Resources.windowDropShadowVerticalPadding
        width: parent.width - Resources.windowDropShadowHorizontalPadding
        radius: Resources.windowCornerRadius
        color: Resources.windowBackgroundColor
        

        Rectangle {
            id: windowTitleBar
            width: parent.width
            height: Resources.windowTitleBarHeight
            color: Resources.windowTitleBarBackgroundColor
            radius: parent.radius

            Text {
                id: windowTitleBarText
                text: window.title
                font.pointSize: Resources.windowTitleBarFontPointSize
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: Resources.windowTitleBarForegroundColor
            }

            Rectangle {
                id: windowTitleBarCornerRadiusOffset
                //offset to hide corner radius at bottom of titlebar.
                width: parent.width
                height: parent.radius
                color: parent.color
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: windowTitleBarMoveArea
                height: parent.height
                width: parent.width

                property int previousX
                property int previousY

                onPressed: {
                    previousX = mouseX
                    previousY = mouseY
                }

                onMouseXChanged: {
                    window.setX(window.x + mouseX - previousX)
                }

                onMouseYChanged: {
                    window.setY(window.y + mouseY - previousY)
                }
            }

            RoundButton {
                id: windowTitleBarCloseButton
                x: Resources.windowTitleBarButtonOffset
                anchors.verticalCenter: parent.verticalCenter
                height: windowTitleBarText.height
                radius: Resources.windowTitleBarButtonRadius
                background: Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    radius: parent.radius
                    color: Resources.windowTitleBarCloseButtonBackgroundColor
                    height: 2 * parent.radius
                    width: 2 * parent.radius
                }
                onClicked: {
                    backendWindow.onClose();
                    window.close()
                }
            }

            RoundButton {
                id: windowTitleBarRestoreButton
                x: windowTitleBarCloseButton.x + windowTitleBarCloseButton.width + Resources.windowTitleBarButtonOffset
                anchors.verticalCenter: parent.verticalCenter
                height: windowTitleBarText.height
                radius: Resources.windowTitleBarButtonRadius
                background: Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    radius: parent.radius
                    color: Resources.windowTitleBarRestoreButtonBackgroundColor
                    height: 2 * parent.radius
                    width: 2 * parent.radius
                }

                onClicked: {
                    if(isFullScreen) {
                        isFullScreen = false
                        window.height = prevHeight
                        window.width = prevWidth
                        window.x = prevWindowX
                        window.y = prevWindowY
                    } else {
                        prevHeight = window.height
                        prevWidth = window.width
                        isFullScreen = true
                        window.height = Screen.height
                        window.width = Screen.width
                        prevWindowX = window.x
                        prevWindowY = window.y
                        window.x = 0
                        window.y = 0
                    }
                }
            }

            RoundButton {
                id: windowTitleBarMinimizeButton
                x: windowTitleBarRestoreButton.x + windowTitleBarRestoreButton.width + Resources.windowTitleBarButtonOffset
                anchors.verticalCenter: parent.verticalCenter
                height: windowTitleBarText.height
                radius: Resources.windowTitleBarButtonRadius
                background: Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    radius: parent.radius
                    color: Resources.windowTitleBarMinimizeButtonBackgroundColor
                    height: 2 * parent.radius
                    width: 2 * parent.radius
                }

                onClicked: {
                    window.visibility = Window.Minimized
                }
            }

        }

        //chat layouts

        Rectangle {
            id: chatHeaderContainer
            anchors.top: windowTitleBar.bottom

            anchors.right: chatContainer.right
            height: Resources.chatHeaderContainerHeight
            width: chatContainer.width
            color: Resources.chatHeaderContainerBackgroundColor

            Text {
                id: chatHeaderText
                x: 30
                anchors.verticalCenter: parent.verticalCenter
                color: Resources.chatHeaderForegroundColor
                font.pointSize: Resources.chatHeaderFontPointSize
                text: contactModelProvider.model.getName(contactListView.currentIndex)
                rightPadding: 10
            }


            RoundButton {
                id: btnAddFile
                anchors.left: chatHeaderText.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 2
                width: btnAddText.width + 10
                radius: 5
                visible: contactModelProvider.model.getDHTId(contactListView.currentIndex) === '127.0.0.1'
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "#5e5c8d"
                    border.color: "white"
                    border.width: 1

                    Text {
                        id: btnAddText
                        text: "Add Files"
                        anchors.centerIn: parent
                        font.pointSize: 8
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            parent.color = containsMouse ? "#3e3c6d" : "#5e5c8d";
                        }

                        onClicked: {
                            addFileDialog.visible = true;
                        }
                    }
                }
            }








        }

        Rectangle {
            id: chatContainer
            x: parent.width / 3

            width: 2 * parent.width / 3
            anchors.bottom: parent.bottom
            anchors.top: chatHeaderContainer.bottom

            color: Resources.contactContainerBackgroundColor

            

            ListView {
                id: fileListView
                anchors.left: parent.left
                anchors.right: parent.right
                y: Resources.contactContainerVerticalPadding
                height: parent.height - 2 * Resources.contactContainerVerticalPadding
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                flickableDirection: Flickable.VerticalFlick
                model: fileModelProvider.model

                delegate: Resources.fileDelegate
                property var contactCurrentIndex

                onCurrentIndexChanged: {
                    
                }
            }
        }

        

        //contact layouts


        Rectangle {
            id: contactSearchBarContainer
            anchors.top: windowTitleBar.bottom
            anchors.left: windowTitleBar.left
            anchors.right: chatContainer.left
            height: Resources.contactSearchBarContainerHeight
            color: Resources.contactSearchBarContainerBackgroundColor
            border.width: 1
            border.color: Resources.contactSearchBarBorderColor

            Button {
                id: searchButton
                width: parent.height
                height: parent.height



                background: Rectangle {

                    width: parent.width
                    height: parent.height
                    color: Resources.transparentColor


                    Canvas {
                        id: searchButtonCanvas
                        anchors.fill: parent
                        contextType: "2d"

                        onPaint: {
                            context.reset();
                            var centreX = width / 2.5;
                            var centreY = width / 2.2;
                            var radius = width / 7
                            context.lineWidth = 2;
                            context.beginPath();
                            context.moveTo(centreX + radius, centreY);
                            context.arc(centreX, centreY, radius, 0, 2 * Math.PI, false);
                            var fx = centreX + radius * Math.cos(Math.PI / 4);
                            var fy = centreY + radius * Math.sin(Math.PI / 4);
                            context.moveTo(fx, fy);
                            context.lineTo(fx + 5, fy + 5)
                            context.strokeStyle = searchButton.hovered ? Resources.contactSearchBarFocusColor : Resources.contactSearchBarContainerForegroundColor;

                            context.stroke();

                        }
                    }


                }

                onHoveredChanged:  {
                    searchButtonCanvas.requestPaint();
                }

                onClicked: {
                    mainBackend.search(searchField.text)
                }
            }

            TextField {
                id: searchField
                anchors.left: searchButton.right
                anchors.right: addContactsButton.left
                height: parent.height
                color: Resources.contactSearchBarContainerForegroundColor
                font.pointSize: Resources.contactSearchBarContainerFontPointSize
                placeholderText: "Search"
                placeholderTextColor: Resources.contactSearchBarContainerPlaceholderColor
                leftPadding: 0
                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: Resources.transparentColor
                }

                onTextChanged: {
                    mainBackend.search(searchField.text)
                }

            }

            Button {
                id: addContactsButton
                anchors.right: contactSearchBarContainer.right
                anchors.top: contactSearchBarContainer.top
                width: Resources.contactSearchBarContainerHeight
                height: Resources.contactSearchBarContainerHeight
                background: Rectangle {
                    id: addContactsButtonLayer
                    height: parent.height
                    width: parent.width
                    color: Resources.transparentColor

                    Canvas {
                        id: addContactsButtonCanvas
                        contextType: "2d"
                        anchors.fill: parent

                        onPaint: {
                            context.reset();
                            context.lineWidth = 2;
                            var cx = width / 2;
                            var cy = height / 2;
                            var length = Math.min(height, width) / 3;
                            context.beginPath();
                            context.moveTo(cx - length / 2, cy);
                            context.lineTo(cx + length / 2, cy);
                            context.moveTo(cx, cy - length / 2);
                            context.lineTo(cx, cy + length / 2);
                            context.strokeStyle = addContactsButton.hovered ? Resources.contactSearchBarFocusColor : Resources.contactSearchBarContainerForegroundColor;
                            context.stroke();
                        }

                    }


                }

                onHoveredChanged: {
                    addContactsButtonCanvas.requestPaint();
                }

                onClicked: {
                    mainBackend.openAddContactsWindow()
                }
            }
        }

        Rectangle {
            id: contactContainer
            anchors.top: contactSearchBarContainer.bottom
            anchors.bottom: extrasContainer.top
            anchors.left: parent.left
            anchors.right: chatContainer.left
            color: Resources.contactContainerBackgroundColor
            property var selectedItemName
            ListView {
                id: contactListView
                anchors.left: parent.left
                anchors.right: parent.right
                y: Resources.contactContainerVerticalPadding
                height: parent.height - 2 * Resources.contactContainerVerticalPadding
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                flickableDirection: Flickable.VerticalFlick
                model: contactModelProvider.model

                delegate: Resources.contactDelegate

                onCurrentIndexChanged: {
                    mainBackend.loadChat(contactModelProvider.model.getDHTId(currentIndex))
                    fileListView.contactCurrentIndex = currentIndex
                }
            }
        }

        Rectangle {
            id: extrasContainer
            radius: Resources.windowCornerRadius
            height: Resources.chatMessageContainerHeight
            anchors.right: chatHeaderContainer.left
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: Resources.extrasContainerBackgroundColor

            Text {
                id: dhtIdText
                text: mainBackend.ipaddr
                font.pointSize: 10
                font.family: "Segoe UI"
                color: "#d3cdf9"
                
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                topPadding: 5
                bottomPadding: 5
                
            }

            //conceal top corner radius
            Rectangle {
                width: parent.width
                height: parent.radius
                color: parent.color
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }

            //conceal right corner radius
            Rectangle {
                width: parent.radius
                height: parent.height
                color: parent.color
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }

        FileDialog {
            id: addFileDialog
            title: "Choose a file."

            onAccepted: {
                mainBackend.addFile(addFileDialog.fileUrls)
            }
        }

    }

    DropShadow {
        id: windowLayerDropShadow
        anchors.fill: windowLayer
        cached: true
        verticalOffset: 1
        horizontalOffset: 1
        radius: 8
        samples: 16
        color: "#80000000"
        source: windowLayer
    }

    MouseArea {
        id: windowHorizontalResizeArea
        width: 5
        anchors.right: windowLayer.right
        anchors.top: windowLayer.top
        anchors.bottom: windowLayer.bottom

        cursorShape: Qt.SizeHorCursor

        property int previousX

        onPressed: previousX = mouseX

        onMouseXChanged: {
            var dx = mouseX - previousX
            var newWidth = window.width + dx
            if(newWidth >= window.minimumWidth) {
                window.setWidth(newWidth)
            } else {
                if(window.width !== window.minimumWidth) {
                    window.setWidth(window.minimumWidth)
                }
            }
        }
    }

    MouseArea {
        id: windowVerticalResizeArea
        height: 5
        anchors.right: windowLayer.right
        anchors.left: windowLayer.left
        anchors.bottom: windowLayer.bottom

        cursorShape: Qt.SizeVerCursor

        property int previousY

        onPressed: previousY = mouseY

        onMouseYChanged: {
            var dy = mouseY - previousY
            var newHeight = window.height + dy
            if(newHeight >= 480) {
                window.setHeight(newHeight)
            } else {
                if(window.height !== window.minimumHeight) {
                    window.setHeight(window.minimumHeight)
                }
            }
        }
    }

}
