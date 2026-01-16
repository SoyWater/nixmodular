import Quickshell
import QtQuick
import qs.Services
import qs.Commons

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: Colors.mSurface

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Time.formatted
        color: Colors.mPrimary
        font.pixelSize: 14
    }
}
