import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * TimeDisplay - Time information display component
 *
 * This component displays multiple time values: Simulation Time, Mission Time,
 * Epoch Time, and Zulu Time.
 */
RowLayout {
    id: root
    spacing: 15

    // Properties for time values - bound to backend
    property string simulationTime: "-"
    property string missionTime: "-"
    property string epochTime: "-"
    property string zuluTime: "-"

    // Simulation Time
    TimeField {
        label: "Simulation Time (s)"
        value: root.simulationTime
        tooltipText: "Simulation elapsed time in seconds"
    }

    // Mission Time
    TimeField {
        label: "Mission Time"
        value: root.missionTime
        tooltipText: "Mission elapsed time"
    }

    // Epoch Time
    TimeField {
        label: "Epoch Time"
        value: root.epochTime
        tooltipText: "Time since epoch"
    }

    // Zulu Time
    TimeField {
        label: "Zulu Time"
        value: root.zuluTime
        tooltipText: "Wall clock time (UTC + 0)"
    }
}
