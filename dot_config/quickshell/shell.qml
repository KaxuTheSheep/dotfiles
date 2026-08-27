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

        property string view: "overview"  

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.opacity)
            border.color: Theme.accent
            border.width: 1
            radius: 0

	    Loader {
		id: loader
                anchors.fill: parent
                sourceComponent: panel.view === "notifications" ? notifComp : overviewComp
	    }
	    
	    Connections {
		target: loader.item
		function onActivateRequested(target) { panel.view = target }
	    }
        }

        Component { id: overviewComp; Overview {} }
        Component { id: notifComp; Notifications {} }

        Item {
            anchors.fill: parent
            focus: panel.visible
            Keys.onPressed: (event) => {
    		const item = loader.item
		switch (event.key) {
			case Qt.Key_N: panel.view = "notifications"; break
        		case Qt.Key_O: panel.view = "overview"; break
			case Qt.Key_C: case Qt.Key_M: case Qt.Key_P: case Qt.Key_S:
            			break // Connections/Music/Power/Workspacesreserved
        		case Qt.Key_H: case Qt.Key_K: case Qt.Key_Left: case Qt.Key_Up:
            			if (item && item.moveFocus) item.moveFocus(-1)
            			break
        		case Qt.Key_L: case Qt.Key_J: case Qt.Key_Right: case Qt.Key_Down:
            			if (item && item.moveFocus) item.moveFocus(1)
            			break
        		case Qt.Key_Tab:
            			if (item && item.cycleRegion) item.cycleRegion()
            			break
        		case Qt.Key_Return: case Qt.Key_Enter:
            			if (item && item.activate) item.activate()
            			break
        		case Qt.Key_Space: case Qt.Key_Escape:
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
