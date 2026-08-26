pragma Singleton
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property string dir: Qt.resolvedUrl(Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/quickshell/timers"
    property var timers: []   // { id, label, targetEpoch, important }

    function addRelative(seconds, label, important) {
        addAbsolute(Date.now()/1000 + seconds, label, important)
    }
    function addAbsolute(epochSeconds, label, important) {
        const t = { id: Date.now()+"-"+Math.random(), label, targetEpoch: epochSeconds, important }
        timers = timers.concat([t])
        writeTimer(t)
    }
    function writeTimer(t) {
        // one JSON file per timer, id as filename — deleted on fire
    }
    function loadOnStartup() {
        // read dir, push any file whose targetEpoch < now into a
        // "missed" list surfaced in the Notifications module, rather
        // than silently dropping them
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            const now = Date.now()/1000
            root.timers.filter(t => t.targetEpoch <= now).forEach(t => {
                NotificationState.history = [{ appName: "Timer", summary: t.label, urgency: t.important ? 2 : 0 }].concat(NotificationState.history)
                if (t.important || NotificationState.mode !== 2) Toasts.push({ appName: "Timer", summary: t.label, urgency: t.important ? 2 : 0 })
            })
            root.timers = root.timers.filter(t => t.targetEpoch > now)
        }
    }
}
