pragma Singleton
import QtQuick
import Quickshell

// Replaces the scaffolded single-timer stub described in gentoo-status.md.
// In-memory only — no persistence (deliberate, per Q4: "accept vanishing
// timers for now"). writeTimer/loadOnStartup are NOT reintroduced here.

QtObject {
    id: root

    // Each entry: { id, name, targetEpochMs }
    // targetEpochMs is always an absolute point in time — relative timers
    // are converted to an absolute target the moment they're created, so
    // the countdown logic never has to distinguish the two modes again
    // after creation. Only the add-form needs to know about "relative vs
    // absolute" as an input mode.
    property var timers: []

    property int _nextId: 1

    // now is the single tick source for every countdown row — one Timer,
    // not one per row, to avoid N independent QML Timers drifting/costing
    // more than needed for "a few" rows.
    property double nowMs: Date.now()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.nowMs = Date.now()
    }

    // Fires whenever a timer naturally expires or is force-completed via
    // 'q'. Notification.qml (or whatever owns the notification pipeline)
    // should connect to this and push a real notification through the
    // existing org.freedesktop.Notifications-backed NotificationState,
    // per Q3: expiry = fake/real notification either way, timer removed.
    signal timerCompleted(string name)

    function addTimer(name, targetEpochMs) {
        var list = timers.slice()
        list.push({ id: _nextId, name: name, targetEpochMs: targetEpochMs })
        _nextId += 1
        timers = list
        _resort()
    }

    // Q3 + early-dismiss answer: killing early is NOT silent discard,
    // it fakes completion — same signal, same downstream toast.
    function completeTimer(id) {
        var t = _find(id)
        if (!t) return
        timerCompleted(t.name)
        _remove(id)
    }

    // Called internally when nowMs passes a timer's target — natural
    // expiry path, same completion signal as early-dismiss.
    function _checkExpired() {
        var list = timers
        for (var i = list.length - 1; i >= 0; i--) {
            if (list[i].targetEpochMs <= nowMs) {
                timerCompleted(list[i].name)
                _remove(list[i].id)
            }
        }
    }

    onNowMsChanged: _checkExpired()

    function _remove(id) {
        timers = timers.filter(function(t) { return t.id !== id })
    }

    function _find(id) {
        for (var i = 0; i < timers.length; i++)
            if (timers[i].id === id) return timers[i]
        return null
    }

    // Q4: soonest-to-expire first.
    function _resort() {
        var list = timers.slice()
        list.sort(function(a, b) { return a.targetEpochMs - b.targetEpochMs })
        timers = list
    }

    function remainingLabel(targetEpochMs) {
        var deltaMs = Math.max(0, targetEpochMs - nowMs)
        var s = Math.floor(deltaMs / 1000)
        var days = Math.floor(s / 86400); s -= days * 86400
        var hrs  = Math.floor(s / 3600);  s -= hrs * 3600
        var mins = Math.floor(s / 60);    s -= mins * 60
        var secs = s
        var parts = []
        if (days > 0) parts.push(days + "d")
        if (hrs > 0 || days > 0) parts.push(hrs + "h")
        if (mins > 0 || hrs > 0 || days > 0) parts.push(mins + "m")
        parts.push(secs + "s")
        return parts.join(" ")
    }

    function clockLabel(targetEpochMs) {
        var d = new Date(targetEpochMs)
        function pad(n) { return (n < 10 ? "0" : "") + n }
        return pad(d.getHours()) + ":" + pad(d.getMinutes()) + ":" + pad(d.getSeconds())
    }
}
