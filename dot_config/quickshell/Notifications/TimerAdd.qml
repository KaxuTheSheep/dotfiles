import QtQuick
import "../Theme"
Item {
    id: root

    property bool absoluteMode: false
    property var fieldValues: [0, 0, 0, 0, 0, 0]

    signal submitted(string name, bool absolute, var values)
    signal cancelled()
    property alias nameField: nameInput

    Column {
        anchors.fill: parent
        spacing: 8

        Text {
            text: "New timer"
            color: Theme.foreground
            font.family: "DepartureMono Nerd Font"
            font.pixelSize: 14
        }

        Rectangle {
            width: parent.width
            height: 28
            color: "transparent"
            border.color: nameInput.activeFocus ? Theme.color3 : Theme.color8
            border.width: 1
            radius: 0

            TextInput {
                id: nameInput
                anchors.fill: parent
                anchors.margins: 6
                color: Theme.foreground
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 13
                clip: true 
                Keys.onEscapePressed: root.cancelled()
            }
        }

        Row {
            spacing: 8
            Text {
                text: (root.absoluteMode ? "> " : "  ") + "Absolute"
                color: root.absoluteMode ? Theme.color3 : Theme.color8
                font.family: "DepartureMono Nerd Font"
                MouseArea { anchors.fill: parent; onClicked: root.absoluteMode = true }
            }
            Text {
                text: (!root.absoluteMode ? "> " : "  ") + "Relative"
                color: !root.absoluteMode ? Theme.color3 : Theme.color8
                font.family: "DepartureMono Nerd Font"
                MouseArea { anchors.fill: parent; onClicked: root.absoluteMode = false }
            }
        }

        Row {
            spacing: 4
            Repeater {
                model: 3
                delegate: NumericBox {
                    label: root.absoluteMode
                        ? ["Y", "M", "D"][index]
                        : ["D", "H", "M"][index]
                    value: root.fieldValues[index]
                    onValueEdited: root.fieldValues[index] = v
                }
            }
	    Item { width: 12; height: 1 } 
	    Repeater {
                model: 3
                delegate: NumericBox {
                    label: root.absoluteMode
                        ? ["h", "m", "s"][index]
                        : ["S", "-", "-"][index]
                    enabled: root.absoluteMode || index === 0
                    value: root.fieldValues[3 + index]
                    onValueEdited: root.fieldValues[3 + index] = v
                }
            }
        }

        Row {
            spacing: 12
            Text {
                text: "[Enter] add   [Esc] cancel"
                color: Theme.color8
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 11
            }
        }
    }

    Keys.onReturnPressed: _submit()
    Keys.onEscapePressed: root.cancelled()

    function _submit() {
        if (nameInput.text.length === 0) return
        root.submitted(nameInput.text, absoluteMode, fieldValues)
    }

    component NumericBox: Rectangle {
        id: box
        property string label: ""
        property int value: 0
        property bool enabled: true
        signal valueEdited(int v)

        width: 34
        height: 34
        color: "transparent"
        border.color: input.activeFocus ? Theme.color3 : Theme.color8
        border.width: 1
        opacity: enabled ? 1.0 : 0.35

        Column {
            anchors.centerIn: parent
            spacing: 2
            TextInput {
                id: input
                text: String(box.value).padStart(2, "0")
                color: Theme.foreground
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 14
                horizontalAlignment: TextInput.AlignHCenter
                validator: IntValidator { bottom: 0; top: 9999 }
                enabled: box.enabled
                onTextChanged: box.valueEdited(parseInt(text || "0"))
                Keys.onEscapePressed: root.cancelled()
            }
            Text {
                text: box.label
                color: Theme.color8
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 9
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
