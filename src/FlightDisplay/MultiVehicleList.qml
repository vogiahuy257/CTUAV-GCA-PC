/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.Vehicle
import QGroundControl.FlightMap
import QGroundControl.FlightDisplay

Item {
    property real   _margin:              ScreenTools.defaultFontPixelWidth / 2
    property real   _widgetHeight:        ScreenTools.defaultFontPixelHeight * 2.5
    property var    _guidedController:    globals.guidedControllerFlyView
    property var    _activeVehicleColor:  "#1783c7"
    property var    _activeVehicle:       QGroundControl.multiVehicleManager.activeVehicle
    property var    selectedVehicles:     QGroundControl.multiVehicleManager.selectedVehicles

    property var implicitHeight: vehicleList.contentHeight

    function armAvailable() {
        for (var i = 0; i < selectedVehicles.count; i++) {
            var vehicle = selectedVehicles.get(i)
            if (vehicle.armed === false) {
                return true
            }
        }
        return false
    }


    function disarmAvailable() {
        for (var i = 0; i < selectedVehicles.count; i++) {
            var vehicle = selectedVehicles.get(i)
            if (vehicle.armed === true) {
                return true
            }
        }
        return false
    }

    function startAvailable() {
        for (var i = 0; i < selectedVehicles.count; i++) {
            var vehicle = selectedVehicles.get(i)
            if (vehicle.armed === true && vehicle.flightMode !== vehicle.missionFlightMode){
                return true
            }
        }
        return false
    }

    function pauseAvailable() {
        for (var i = 0; i < selectedVehicles.count; i++) {
            var vehicle = selectedVehicles.get(i)
            if (vehicle.armed === true && vehicle.pauseVehicleSupported) {
                return true
            }
        }
        return false
    }

    function selectVehicle(vehicleId) {
        QGroundControl.multiVehicleManager.selectVehicle(vehicleId)
    }

    function deselectVehicle(vehicleId) {
        QGroundControl.multiVehicleManager.deselectVehicle(vehicleId)
    }

    function toggleSelect(vehicleId) {
        if (!vehicleSelected(vehicleId)) {
            selectVehicle(vehicleId)
        } else {
            deselectVehicle(vehicleId)
        }
    }

    function selectAll() {
        var vehicles = QGroundControl.multiVehicleManager.vehicles
        for (var i = 0; i < vehicles.count; i++) {
            var vehicle = vehicles.get(i)
            var vehicleId = vehicle.id
            if (!vehicleSelected(vehicleId)) {
                selectVehicle(vehicleId)
            }
        }
    }

    function deselectAll() {
        QGroundControl.multiVehicleManager.deselectAllVehicles()
    }

    function vehicleSelected(vehicleId) {
        for (var i = 0; i < selectedVehicles.count; i++ ) {
            var currentId = selectedVehicles.get(i).id
            if (vehicleId === currentId) {
                return true
            }
        }
        return false
    }

    QGCListView {
        id:                 vehicleList
        anchors.left:       parent.left
        anchors.right:      parent.right
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        spacing:            ScreenTools.defaultFontPixelHeight / 2
        orientation:        ListView.Vertical
        model:              QGroundControl.multiVehicleManager.vehicles
        cacheBuffer:        _cacheBuffer < 0 ? 0 : _cacheBuffer
        clip:               true

        property real _cacheBuffer:     height * 2

        delegate: Rectangle {
            width:          vehicleList.width 
            height:         innerColumn.height + _margin * 2
            color:          QGroundControl.multiVehicleManager.activeVehicle == _vehicle ? _activeVehicleColor : qgcPal.button
            radius:         _margin
            border.width:   _vehicle && vehicleSelected(_vehicle.id) ? 2 : 0
            border.color:   qgcPal.text

            property var    _vehicle:   object

            QGCMouseArea {
                anchors.fill:       parent
                onClicked:          toggleSelect(_vehicle.id)
            }

            Column {
                id:                         innerColumn
                anchors.centerIn:           parent
                spacing:                    _margin

                RowLayout {
                    anchors.horizontalCenter:   parent.horizontalCenter
                    anchors.margins:    _margin
                    spacing:            _margin

                    IntegratedCompassAttitude {
                        id: compassWidget
                        compassRadius:              _widgetHeight / 2 - attitudeSize / 2
                        compassBorder:              0
                        attitudeSize:               ScreenTools.defaultFontPixelWidth / 2
                        attitudeSpacing:            attitudeSize / 2
                        usedByMultipleVehicleList:   true
                        vehicle:                     _vehicle
                    }

                    QGCLabel {
                        text: " | "
                        font.pointSize:       ScreenTools.largeFontPointSize
                        color:                qgcPal.text
                        Layout.alignment:     Qt.AlignHCenter
                    }

                    QGCLabel {
                        text:                 _vehicle ? _vehicle.id : ""
                        font.pointSize:       ScreenTools.largeFontPointSize
                        color:                qgcPal.text
                        Layout.alignment:     Qt.AlignHCenter
                    }

                    QGCLabel {
                        text: " | "
                        font.pointSize:       ScreenTools.largeFontPointSize
                        color:                qgcPal.text
                        Layout.alignment:     Qt.AlignHCenter
                    }

                    ColumnLayout {
                        spacing:              _margin
                        Layout.rightMargin:   compassWidget.width / 4
                        Layout.alignment:     Qt.AlignCenter

                        FlightModeMenu {
                            Layout.alignment:     Qt.AlignHCenter
                            font.pointSize:       ScreenTools.largeFontPointSize
                            color:                qgcPal.text
                            currentVehicle:       _vehicle
                        }

                        QGCLabel {
                            Layout.alignment:     Qt.AlignHCenter
                            text:                 _vehicle && _vehicle.armed ? qsTr("Armed") : qsTr("Disarmed")
                            color:                qgcPal.text
                        }
                    }
                }

                QGCFlickable {
                    anchors.horizontalCenter:   parent.horizontalCenter
                    width:          Math.min(contentWidth, vehicleList.width)
                    height:         control.height
                    contentWidth:   control.width
                    contentHeight:  control.height

                    TelemetryValuesBar {
                        id:                     control
                        settingsGroup:          factValueGrid.vehicleCardSettingsGroup
                        specificVehicleForCard: _vehicle
                    }
                }
            }
        }
    }
}
