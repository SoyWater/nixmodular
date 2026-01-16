pragma Singleton

import Quickshell
import QtQuick

Singleton {

    property alias enabled: clock.enabled
    readonly property date date: clock.date
    readonly property int hours: clock.hours
    readonly property int minutes: clock.minutes
    readonly property string formatted: {
        Qt.formatDateTime(clock.date, "ddd d MMM hh:mm")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
