pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Theme"

Singleton {
    id: root
    property var queue: []

    PanelWindow {
        id: toastWin
        visible: root.queue.length > 0
        anchors { top: true; right: true }
        margins { top: 12; right: 12 }
        implicitWidth: 320
        implicitHeight: 56
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.opacity)
            border.width: 1
            border.color: root.queue.length && root.queue[0].urgency === 2 ? Theme.color1 : Theme.accent
            Text {
                anchors.centerIn: parent
                color: Theme.foreground
                font.family: "DepartureMono Nerd Font"
                text: root.queue.length ? root.queue[0].appName + ": " + root.queue[0].summary : ""
            }
        }
    }

    function push(notif) {
        root.queue = root.queue.concat([notif])
        toastTimer.restart()
    }

    Timer {
        id: toastTimer
        interval: 4000
        onTriggered: root.queue = root.queue.slice(1)
    }
}
