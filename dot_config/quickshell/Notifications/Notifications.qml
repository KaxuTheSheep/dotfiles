import QtQuick
import Quickshell.Services.Notifications
import "../Theme"
import "."

Item {
    id: root
    anchors.fill: parent

    property int region: 0
    property int modeIndex: NotificationState.mode
    property int listIndex: 0

    function cycleRegion() { region = (region + 1) % 2 }
    function moveFocus(delta) {
        if (region === 0) {
            modeIndex = Math.max(0, Math.min(2, modeIndex + delta))
        } else {
            const len = NotificationState.history.length
            if (len > 0) listIndex = (listIndex + delta + len) % len
        }
    }
    function activate() {
        if (region === 0) {
            NotificationState.setMode(modeIndex)
        } else if (NotificationState.history.length > 0) {
            NotificationState.dismiss(listIndex)
            if (listIndex >= NotificationState.history.length)
                listIndex = Math.max(0, NotificationState.history.length - 1)
        }
    }

    Column {
        anchors.fill: parent
        spacing: 8

        ListView {
            id: modeList
            width: parent.width
            height: 28
            orientation: ListView.Horizontal
            interactive: false
            spacing: 12
            model: ["Normal", "Suppressed", "Silent"]
            currentIndex: root.modeIndex
            highlight: FocusRing { visible: root.region === 0 }
            highlightFollowsCurrentItem: true
            delegate: Text {
                text: modelData
                color: NotificationState.mode === index ? Theme.accent : Theme.foreground
                font.family: "DepartureMono Nerd Font"
            }
        }

        ListView {
            id: notifList
            width: parent.width
            height: parent.height - modeList.height - 8
            model: NotificationState.history
            currentIndex: root.listIndex
            highlight: FocusRing { visible: root.region === 1 }
            highlightFollowsCurrentItem: true
            delegate: Item {
                width: notifList.width
                height: 20
                Component.onCompleted: if (!modelData.read) NotificationState.markRead(index)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 4
                    color: (modelData.notif.urgency === NotificationUrgency.Critical) ? Theme.color1 : Theme.foreground
                    font.family: "DepartureMono Nerd Font"
                    text: modelData.notif.appName + "  " + modelData.notif.summary
                }
            }
        }
    }
}
