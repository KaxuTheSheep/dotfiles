import QtQuick
import Quickshell.Services.Notifications
import "../Theme"
import "."

Item {
    id: root
    anchors.fill: parent

    enum ViewMode { List, AddTimer }
    property int viewMode: Notifications.ViewMode.List

    property int region: 0
    property int modeIndex: NotificationState.mode
    property int timerIndex: 0
    property int listIndex: 0
    property int stripIndex: 0 // 0-2 = mode entries, 3 = timer button

    function cycleRegion() { region = (region + 1) % 3 }

    function moveFocus(delta) {
        if (region === 0) {
            stripIndex = Math.max(0, Math.min(3, stripIndex + delta))
            if (stripIndex <= 2) modeIndex = stripIndex
        } else if (region === 1) {
            const len = TimerState.timers.length
            if (len > 0) timerIndex = (timerIndex + delta + len) % len
        } else {
            const len = NotificationState.history.length
            if (len > 0) listIndex = (listIndex + delta + len) % len
        }
    }

    function activate() {
        if (region === 0) {
            if (stripIndex <= 2) {
                NotificationState.setMode(stripIndex)
            } else {
                root.viewMode = Notifications.ViewMode.AddTimer
            }
        } else if (region === 1) {
        } else if (NotificationState.history.length > 0) {
            NotificationState.dismiss(listIndex)
            if (listIndex >= NotificationState.history.length)
                listIndex = Math.max(0, NotificationState.history.length - 1)
        }
    }

    function killOrDismiss() {
        if (region === 1 && TimerState.timers.length > 0) {
            TimerState.completeTimer(TimerState.timers[timerIndex].id)
            if (timerIndex >= TimerState.timers.length)
                timerIndex = Math.max(0, TimerState.timers.length - 1)
        } else if (region === 2 && NotificationState.history.length > 0) {
            NotificationState.dismiss(listIndex)
            if (listIndex >= NotificationState.history.length)
                listIndex = Math.max(0, NotificationState.history.length - 1)
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Q) {
            killOrDismiss()
            event.accepted = true
        }
    }

    Column {
        anchors.fill: parent
        spacing: 8 
        Row {
            width: parent.width
            height: 28

            ListView {
                id: modeList
                width: parent.width - timerButton.width - 12
                height: parent.height
                orientation: ListView.Horizontal
                interactive: false
                spacing: 12
                model: ["Normal", "Suppressed", "Silent"]
                currentIndex: root.modeIndex
                highlight: FocusRing { visible: root.region === 0 && root.stripIndex <= 2 }
                highlightFollowsCurrentItem: true
                delegate: Text {
                    text: modelData
                    color: NotificationState.mode === index ? Theme.accent : Theme.foreground
                    font.family: "DepartureMono Nerd Font"
                }
            }

            Item {
                id: timerButton
                width: timerLabel.implicitWidth + 8
                height: parent.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: timerLabel
                    text: "⏱ Timer"
                    color: Theme.foreground
                    font.family: "DepartureMono Nerd Font"
                    anchors.centerIn: parent
                }

                FocusRing {
                    anchors.fill: parent
                    visible: root.region === 0 && root.stripIndex === 3
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.region = 0
                        root.stripIndex = 3
                        root.viewMode = Notifications.ViewMode.AddTimer
                    }
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.color8 }

        // ---- Timers — collapses to fixed "No Timers" placeholder when
        // empty so the notifications list below doesn't jump.
        Item {
            width: parent.width
            height: TimerState.timers.length > 0 ? Math.min(120, TimerState.timers.length * 22) : 22

            Text {
                visible: TimerState.timers.length === 0
                text: "No Timers"
                color: Theme.color8
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 12
                anchors.centerIn: parent
            }

            ListView {
                visible: TimerState.timers.length > 0
                anchors.fill: parent
                clip: true
                model: TimerState.timers
                currentIndex: root.timerIndex
                highlight: FocusRing { visible: root.region === 1 }
                highlightFollowsCurrentItem: true
                delegate: Item {
                    width: ListView.view.width
                    height: 20
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 4
                        spacing: 10
                        Text {
                            text: modelData.name
                            color: Theme.foreground
                            font.family: "DepartureMono Nerd Font"
                            width: 120
                            elide: Text.ElideRight
                        }
                        Text {
                            text: TimerState.clockLabel(modelData.targetEpochMs)
                                + " — " + TimerState.remainingLabel(modelData.targetEpochMs)
                            color: Theme.accent
                            font.family: "DepartureMono Nerd Font"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.color8 }

        // ---- Notifications — unchanged from the working file, just now
        // region 2 instead of region 1.
        ListView {
            id: notifList
            width: parent.width
            height: parent.height - modeList.height - 8 - 1 - (TimerState.timers.length > 0 ? Math.min(120, TimerState.timers.length * 22) : 22) - 8 - 1
            model: NotificationState.history
            currentIndex: root.listIndex
            highlight: FocusRing { visible: root.region === 2 }
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

    Loader {
        anchors.fill: parent
        active: root.viewMode === Notifications.ViewMode.AddTimer
        sourceComponent: TimerAdd {
            onSubmitted: function(name, absolute, values) {
                var target
                if (absolute) {
                    var now = new Date()
                    var d = new Date(now.getFullYear(), values[1] - 1, values[2],
                                      values[3], values[4], values[5])
                    target = d.getTime()
                } else {
                    var deltaMs = ((values[0] * 24 + values[1]) * 60 + values[2]) * 60000
                                  + values[3] * 1000
                    target = Date.now() + deltaMs
                }
                TimerState.addTimer(name, target)
                root.viewMode = Notifications.ViewMode.List
            }
            onCancelled: root.viewMode = Notifications.ViewMode.List
        }
    }
}
