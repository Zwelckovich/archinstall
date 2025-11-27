import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    id: root
    height: Screen.height
    width: Screen.width

    // Main background with BONSAI deep color
    Rectangle {
        id: background
        anchors.fill: parent
        color: config.bonsai_bg_deep
        z: 0
    }

    // Subtle gradient overlay for visual depth
    LinearGradient {
        anchors.fill: parent
        z: 1
        start: Qt.point(0, 0)
        end: Qt.point(parent.width, parent.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(124/255, 152/255, 133/255, 0.05) }
            GradientStop { position: 0.5; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(130/255, 164/255, 199/255, 0.05) }
        }
    }

    // Central login panel
    Item {
        id: mainPanel
        z: 3
        anchors.centerIn: parent
        width: 400
        height: 500

        // Elevated card background
        Rectangle {
            id: panelBackground
            anchors.fill: parent
            color: config.bonsai_bg_primary
            radius: 16
            border.width: 1
            border.color: config.bonsai_border_subtle

            // Subtle shadow
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 8
                radius: 32
                samples: 64
                color: Qt.rgba(10/255, 14/255, 20/255, 0.3)
            }
        }

        // BONSAI Logo/Title
        Text {
            id: titleText
            anchors {
                top: parent.top
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            text: "🌱 BONSAI"
            font.family: config.Font
            font.pixelSize: 32
            font.weight: Font.Light
            color: config.bonsai_green_primary
        }

        // Welcome text
        Text {
            id: welcomeText
            anchors {
                top: titleText.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            text: "Welcome Back"
            font.family: config.Font
            font.pixelSize: 14
            color: config.bonsai_text_muted
        }

        // User selection
        ComboBox {
            id: userSelect
            anchors {
                top: welcomeText.bottom
                topMargin: 40
                left: parent.left
                right: parent.right
                leftMargin: 50
                rightMargin: 50
            }
            height: 48
            model: userModel
            currentIndex: userModel.lastIndex
            textRole: "name"
            font.family: config.Font
            font.pixelSize: 14

            delegate: ItemDelegate {
                width: userSelect.width
                height: 48
                contentItem: Text {
                    text: name
                    font.family: config.Font
                    font.pixelSize: 14
                    color: config.bonsai_text_primary
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: hovered ? config.bonsai_bg_secondary : "transparent"
                }
            }

            background: Rectangle {
                color: config.bonsai_bg_secondary
                border.color: userSelect.activeFocus ? config.bonsai_green_primary : config.bonsai_border_primary
                border.width: 1
                radius: 8
            }

            contentItem: Text {
                leftPadding: 12
                text: userSelect.displayText
                font.family: config.Font
                font.pixelSize: 14
                color: config.bonsai_text_primary
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Password field
        TextField {
            id: passwordField
            anchors {
                top: userSelect.bottom
                topMargin: 20
                left: parent.left
                right: parent.right
                leftMargin: 50
                rightMargin: 50
            }
            height: 48
            echoMode: TextInput.Password
            placeholderText: "Password"
            font.family: config.Font
            font.pixelSize: 14
            color: config.bonsai_text_primary
            placeholderTextColor: config.bonsai_text_muted
            selectByMouse: true

            background: Rectangle {
                color: config.bonsai_bg_secondary
                border.color: passwordField.activeFocus ? config.bonsai_green_primary : config.bonsai_border_primary
                border.width: 1
                radius: 8
            }

            onAccepted: loginButton.clicked()
        }

        // Login button
        Button {
            id: loginButton
            anchors {
                top: passwordField.bottom
                topMargin: 30
                left: parent.left
                right: parent.right
                leftMargin: 50
                rightMargin: 50
            }
            height: 48
            text: "Sign In"
            font.family: config.Font
            font.pixelSize: 14
            font.weight: Font.Medium

            contentItem: Text {
                text: loginButton.text
                font: loginButton.font
                color: config.bonsai_text_inverted
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: loginButton.down ? config.bonsai_green_muted : 
                       loginButton.hovered ? config.bonsai_green_secondary : config.bonsai_green_primary
                radius: 8
                
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            onClicked: {
                sddm.login(userSelect.currentText, passwordField.text, sessionSelect.currentIndex)
            }
        }

        // Session selection
        ComboBox {
            id: sessionSelect
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                left: parent.left
                right: parent.right
                leftMargin: 50
                rightMargin: 50
            }
            height: 40
            model: sessionModel
            currentIndex: sessionModel.lastIndex
            textRole: "name"
            font.family: config.Font
            font.pixelSize: 12

            delegate: ItemDelegate {
                width: sessionSelect.width
                height: 40
                contentItem: Text {
                    text: name
                    font.family: config.Font
                    font.pixelSize: 12
                    color: config.bonsai_text_primary
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: hovered ? config.bonsai_bg_secondary : "transparent"
                }
            }

            background: Rectangle {
                color: config.bonsai_bg_secondary
                border.color: config.bonsai_border_subtle
                border.width: 1
                radius: 6
            }

            contentItem: Text {
                leftPadding: 10
                text: sessionSelect.displayText
                font.family: config.Font
                font.pixelSize: 12
                color: config.bonsai_text_secondary
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // Clock
    Text {
        id: clock
        visible: config.ClockEnabled == "true"
        anchors {
            top: parent.top
            right: parent.right
            margins: 50
        }
        font.family: config.Font
        font.pixelSize: 48
        font.weight: Font.Light
        color: config.bonsai_text_primary

        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
        }
    }

    // Date
    Text {
        id: date
        visible: config.ClockEnabled == "true"
        anchors {
            top: clock.bottom
            right: parent.right
            rightMargin: 50
            topMargin: 5
        }
        font.family: config.Font
        font.pixelSize: 16
        color: config.bonsai_text_muted

        function updateDate() {
            text = new Date().toLocaleDateString(Qt.locale(), "dddd, MMMM d")
        }
    }

    // Timer for clock updates
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            clock.updateTime()
            date.updateDate()
        }
    }

    Component.onCompleted: {
        clock.updateTime()
        date.updateDate()
        passwordField.forceActiveFocus()
    }
}