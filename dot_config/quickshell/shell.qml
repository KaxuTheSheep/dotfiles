import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "Theme"
import "Overview"
import "Notifications"

ShellRoot {
    PanelWindow {
        id: panel
        visible: false
        anchors { top: true }
        margins.top: 12
        implicitWidth: 480
        implicitHeight: 240
        color: "transparent"

        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:overview"
        WlrLayershell.keyboardFocus: visible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        property string view: "overview"   // "overview" | "notifications"

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.opacity)
            border.color: Theme.accent
            border.width: 1
            radius: 0

            Loader {
                anchors.fill: parent
                sourceComponent: panel.view === "notifications" ? notifComp : overviewComp
            }
        }

        Component { id: overviewComp; Overview {} }
        Component { id: notifComp; Notifications {} }

        // Grabs all keys while visible+exclusive; unmatched keys are
        // swallowed rather than falling through, by design.
        Item {
            anchors.fill: parent
            focus: panel.visible
            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Qt.Key_N: panel.view = "notifications"; break
                    case Qt.Key_Space:
                    case Qt.Key_Escape:
                        panel.view = "overview"
                        panel.visible = false
                        break
                    default: break
                }
                event.accepted = true
            }
        }
    }

    IpcHandler {
        target: "overview"
        function toggle() {
            panel.visible = !panel.visible
            if (panel.visible) panel.view = "overview"
        }
    }
}
