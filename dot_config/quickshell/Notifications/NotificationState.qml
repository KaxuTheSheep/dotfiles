pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    property int mode: 0
    property var history: [] 
    readonly property int unreadCount: history.filter(h => !h.read).length
    readonly property int totalCount: history.length

    property NotificationServer server: NotificationServer {
        onNotification: notif => {
            notif.tracked = true
            root.history = [{ notif, read: false }].concat(root.history)

            const allow = root.mode === 0
                || (root.mode === 1 && notif.urgency === NotificationUrgency.Critical)
            if (allow) Toasts.push(notif)
        }
    }

    function markRead(index) {
        const h = root.history.slice()
        h[index] = { notif: h[index].notif, read: true }
        root.history = h
    }

    function dismiss(index) {
        const h = root.history.slice()
        h.splice(index, 1)
        root.history = h
    }

    function setMode(m) { root.mode = m }
}
