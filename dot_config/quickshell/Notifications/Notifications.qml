import QtQuick
import "../Theme"
import "."

Item {
    anchors.fill: parent

    Row {
        anchors.top: parent.top
        spacing: 8
        Repeater {
            model: ["Normal", "Suppressed", "Silent"]
            delegate: Text {
                text: modelData
                color: NotificationState.mode === index ? Theme.accent : Theme.foreground
                font.family: "DepartureMono Nerd Font"
                MouseArea { anchors.fill: parent; onClicked: NotificationState.setMode(index) }
            }
        }
    }

    ListView {
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.fill: parent
        model: NotificationState.history
	delegate: Row {
		width: parent.width
		Component.onCompleted: if (!modelData.read) NotificationState.markRead(index)
		Text {
			color: (modelData.notif.urgency === NotificationUrgency.Critical) ? Theme.color1 : Theme.foreground
			font.family: "DepartureMono Nerd Font"
			text: modelData.notif.appName + "  " + modelData.notif.summary
        	}
        	Text {
            		text: " [x]"
            		color: Theme.accent
            	MouseArea { anchors.fill: parent; onClicked: NotificationState.dismiss(index) }
        	}
    	}
    }
}
