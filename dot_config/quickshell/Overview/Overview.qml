import QtQuick
import Quickshell.Io
import Quickshell.Networking
import "../Theme"
import "../Notifications"

Item {
    id: root
    anchors.fill: parent

    QtObject { id: clock; property date date: new Date() }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: clock.date = new Date() }

    FileView { id: battery; path: "/sys/class/power_supply/BAT1/capacity" }
    FileView { id: status;  path: "/sys/class/power_supply/BAT1/status" }
    Timer {
        interval: 30000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: { battery.reload(); status.reload() }
    }

    property string wifiText: "no wifi device"
    Instantiator {
        model: Networking.devices
        delegate: Instantiator {
            id: netInst
            required property var modelData
            active: modelData.type === DeviceType.Wifi
            model: modelData.networks
            delegate: Connections {
                required property var modelData
                target: modelData
                function onConnectedChanged() {
                    wifiText = modelData.connected ? modelData.name : wifiText
                }
                Component.onCompleted: { if (modelData.connected) wifiText = modelData.name }
            }
        }
    }

    readonly property var rowModel: [
        { key: "date", text: Qt.formatDateTime(clock.date, "yyyy-MM-dd  hh:mm"), activatable: false },
        { key: "battery", text: "Battery  " + (battery.text().trim() || "?") + "%  (" + status.text().trim() + ")", activatable: false },
        { key: "wifi", text: "Wifi  " + wifiText, activatable: false },
        { key: "notifications", text: "Notifications  " + NotificationState.unreadCount + "/" + NotificationState.totalCount, activatable: true }
    ]

    signal activateRequested(string target)

    function moveFocus(delta) {
        list.currentIndex = (list.currentIndex + delta + rowModel.length) % rowModel.length
    }
    function activate() {
        const row = rowModel[list.currentIndex]
        if (row.activatable) root.activateRequested(row.key)
    }

    function cycleRegion() {}

    ListView {
        id: list
        anchors.centerIn: parent
        width: 320
        height: contentHeight
        interactive: false
        model: root.rowModel
        currentIndex: 0
        highlight: FocusRing {}
        highlightFollowsCurrentItem: true
        delegate: Item {
            width: list.width
            height: 24
            Text {
                anchors.verticalCenter: parent.verticalCenter
                x: 4
                color: Theme.foreground
                font.family: "DepartureMono Nerd Font"
                font.pixelSize: 20
                text: modelData.text
            }
        }
    }
}
