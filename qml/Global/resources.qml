pragma Singleton
import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0

QtObject {
    property var transparentColor: "#00000000"

    property var windowBackgroundColor: "#2f2d52"
    property var windowCornerRadius: 6
    property var windowDropShadowHorizontalPadding: 8
    property var windowDropShadowVerticalPadding: 8

    property var windowTitleBarHeight: 30
    property var windowTitleBarBackgroundColor: "#242345"
    property var windowTitleBarForegroundColor: "#7f7da2"
    property var windowTitleBarCloseButtonBackgroundColor: "#ff6256"
    property var windowTitleBarRestoreButtonBackgroundColor: "#ffbf2f"
    property var windowTitleBarMinimizeButtonBackgroundColor: "#29cb42"
    property var windowTitleBarButtonOffset: 7
    property var windowTitleBarButtonRadius: 6
    property var windowTitleBarFontPointSize: 10
    property var windowTitleBarBottomOffset: 20


    property var leftChatBubbleBackgroundColor: "#ffffff"
    property var rightChatBubbleBackgroundColor: "#859ffe"
    property var chatBackgroundColor: "#ddddf7"
    property var chatBubbleRadius: 3
    property var chatBubblePadding: 20
    property var leftChatBubbleForegroundColor: "#8d88b0"
    property var rightChatBubbleForegroundColor: "#f1f3ff"
    property var chatBubbleFontPointSize: 10
    property var consecutiveBubbleSpacing: 40
    property var consecutiveSameBubbleSpacing: 5
    property var chatBubbleOutgrowthOffset: 10
    property var chatBubbleHorizontalPadding: 10
    property var chatBubbleVerticalPadding: 10
    property var chatBubbleDropShadowVerticalOffset: 1
    property var chatBubbleDropShadowHorizontalOffset: 1

    property var chatListViewScrollBarHorizontalOffset: 10

    property var chatMessageContainerBackgroundColor: "#ffffff"
    property var chatMessageContainerHeight: 40

    property var chatHeaderContainerHeight: 40
    property var chatHeaderContainerBackgroundColor: "#5e5c8d"
    property var chatHeaderForegroundColor: "#c2c1ed"
    property var chatHeaderFontPointSize: 10

    property var contactHeaderContainerBackgroundColor: "#2e2c51"
    property var contactHeaderContainerForegroundColor: "#d3cdf9"
    property var contactHeaderContainerPressedForegroundColor: "#ffffff"
    property var contactHeaderContainerPopupBackgroundColor: "#bbb9e1"
    property var contactHeaderContainerFontPointSize: 12
    property var contactHeaderContainerLeftPadding: 10
    property var contactHeaderContainerFocusColor: "#e8e8f5"
    property var contactHeaderBorderColor: "#393776"

    property var contactSearchBarContainerBackgroundColor: "#3f3e60"
    property var contactSearchBarContainerForegroundColor: "#b9b7df"
    property var contactSearchBarContainerPlaceholderColor: "#a5a2dd"
    property var contactSearchBarBorderColor: "#464469"
    property var contactSearchBarContainerHeight: 40
    property var contactSearchBarContainerFontPointSize: 10
    property var contactSearchBarFocusColor: "#e8e8f5"

    property var contactContainerBackgroundColor: "#3f3e60"
    property var contactContainerForegroundColor: "#b9b7df"
    property var contactContainerVerticalPadding: 10
    property var contactRowForegroundColor: "#b8b7d9"
    property var contactRowRecentTextForegroundColor: "#7c79a0"
    property var contactRowFocusColor: "#373658"

    property var extrasContainerBackgroundColor: "#474b7b"
    property var extrasContainerForegroundColor: "#dad4f6"

    property var profileImageHeight: 40
    property var profileImageWidth: 40
    property var profileNameFontPointSize: 9


    property var onlineMarkerColor: "lightgreen"
    property var offlineMarkerColor: "white"

    property var msgCountMarkerSize: 15
    property var msgCountMarkerColor: "#02db58"
    property var msgCountMarkerForegroundColor: "white"


    property var contactDelegate: Component {
        id: contact
        Rectangle {
            id: contactRow

            height: cr_image.height + 20
            width: parent.width
            color: transparentColor
            property var url: imageUrl
            property var listViewTree: parent.parent


            Loader {
                id: cr_image; sourceComponent: profileImageItem; x: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                id: cr_textContent

                anchors.left: cr_image.right
                width: cr_msgcount.x - x - 10
                color: transparentColor
                Text {
                    id: cr_text
                    text: name
                    clip: true
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    topPadding: contactRow.height / 4
                    leftPadding: 10
                    rightPadding: 20
                    color: contactRowForegroundColor
                    font.pointSize: profileNameFontPointSize
                }
            }

            Rectangle {
                id: cr_msgcount
                anchors.verticalCenter: parent.verticalCenter
                height: msgCountMarkerSize
                x: parent.width - width - contactSearchBarContainerHeight / 4
                radius: 3
                visible: false
                color: msgCountMarkerColor

            }

            MouseArea {
                id: cr_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    contactRow.color = cr_mouseArea.containsMouse ? contactRowFocusColor : transparentColor
                }

                onClicked: {
                    contactRow.listViewTree.currentIndex = index
                    //console.log(contactRow.listViewTree.model.get(index))
                }
            }

        }
    }

    property var profileImageItem: Component {
        id: profileImageItem
        Rectangle {
            width: profileImageWidth
            height: profileImageHeight
            color: transparentColor

            Image {
                property var root: parent.parent.parent
                source: root.url
                width: parent.width
                height: parent.height
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: opacityMask
                }
            }

            Rectangle {
                id: opacityMask
                width: parent.width
                height: parent.height
                radius: Math.min(parent.width, parent.height) / 2
                visible: false

            }

        }
    }

    property var fileDelegate: Component {
        id: fileComponent
        Rectangle {
            id: fileRow

            height: 60
            width: parent.width
            color: transparentColor
            property var listViewTree: parent.parent

 
            Rectangle {
                id: cr_textContent
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                width: parent.width - 120
                color: transparentColor
                Text {
                    id: cr_text
                    text: name
                    clip: true
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    topPadding: fileRow.height / 4
                    leftPadding: 10
                    rightPadding: 20
                    color: contactRowForegroundColor
                    font.pointSize: 11
                }
                Text {
                    id: cr_public
                    text: pubstr
                    clip: true
                    anchors.top: cr_text.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    leftPadding: 10
                    topPadding: 5
                    color: contactRowRecentTextForegroundColor
                    font.pointSize: 10
                }
            }

            
            MouseArea {
                id: cr_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    fileRow.color = cr_mouseArea.containsMouse ? contactRowFocusColor : transparentColor
                }

                onClicked: {
                    fileRow.listViewTree.currentIndex = index
                    //console.log(contactRow.listViewTree.model.get(index))
                }
            }

            RoundButton {
                id: btnFileAction
                anchors.left: cr_textContent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 2
                width: btnFileActionText.width + 10
                radius: 5
                visible: true
                background: Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width - 5
                    radius: parent.radius
                    color: "#5e5c8d"
                    border.color: "white"
                    border.width: 1

                    Text {
                        id: btnFileActionText
                        text: contactModelProvider.model.getDHTId(listViewTree.contactCurrentIndex) === '127.0.0.1' ? "Delete" : "Download"
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
                            if(btnFileActionText.text === "Delete") {
                                mainBackend.deleteFile(name)
                            }
                        }
                    }
                }
            }

            RoundButton {
                id: btnPublic
                anchors.left: btnFileAction.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 2
                width: btnPublicText.width + 10
                radius: 5
                visible: contactModelProvider.model.getDHTId(listViewTree.contactCurrentIndex) === '127.0.0.1'
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "#5e5c8d"
                    border.color: "white"
                    border.width: 1

                    Text {
                        id: btnPublicText
                        text: pubstr === "(public)" ? "Make Private" : "Make Public"
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
                            if(pubstr === "(public)") {
                                mainBackend.makePrivate(name)
                            } else if (pubstr === "(private)") {
                                mainBackend.makePublic(name)
                            } else {
                                mainBackend.makePublic(name)
                            }
                        }
                    }
                }
            }

        }
    }

}

