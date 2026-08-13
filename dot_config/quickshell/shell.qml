import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "Theme"

ShellRoot {
    PanelWindow {
        id: panel
        visible: false
        anchors {
            top: true
        }
        margins.top: 12
        implicitWidth: 480
        implicitHeight: 240
        color: "transparent"

        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:overview"

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.opacity)
            border.color: Theme.accent
            border.width: 1
            radius: 0

            Text {
                anchors.centerIn: parent
                text: "Overview"
                color: Theme.foreground
                font.family: "DepartureMono Nerd Font"
            }
        }
    }

    IpcHandler {
        target: "overview"
        function toggle() { panel.visible = !panel.visible }
    }
}
