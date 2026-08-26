import QtQuick
import Quickshell.Io
import Quickshell.Networking
import "../Theme"
import "../Notifications"

Item {
    anchors.fill: parent

    Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            color: Theme.foreground
            font.family: "DepartureMono Nerd Font"
            font.pixelSize: 20
            text: Qt.formatDateTime(clock.date, "yyyy-MM-dd  hh:mm")
        }

        Text {
            color: Theme.foreground
            font.family: "DepartureMono Nerd Font"
            font.pixelSize: 20
	    text: "Battery  " + (battery.text().trim() || "?") + "%  (" + status.text().trim() + ")" 
    	}

        Text {
            color: Theme.foreground
            font.family: "DepartureMono Nerd Font"
            font.pixelSize: 20
            text: "Wifi  " + wifiText
        }   


    }

    QtObject {
        id: clock
        property date date: new Date()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.date = new Date()
    }

    FileView {
        id: battery
        path: "/sys/class/power_supply/BAT1/capacity"
    }

    FileView {
        id: status
        path: "/sys/class/power_supply/BAT1/status"
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            battery.reload()
            status.reload()
        }
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
                Component.onCompleted: {
                    if (modelData.connected) wifiText = modelData.name
                }
            }
        }
    }

    Text {
    	color: Theme.foreground
    	font.family: "DepartureMono Nerd Font"
    	font.pixelSize: 20
    	text: "Notifications  " + NotificationState.unreadCount + "/" + NotificationState.totalCount
    }

}
