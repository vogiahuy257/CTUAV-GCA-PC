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
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import QGroundControl
import QGroundControl.Controllers
import QGroundControl.Controls
import QGroundControl.FactSystem
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.Vehicle
import QGroundControl.Fire 
// 3D Viewer modules
import Viewer3D

Item {
    id: _root

    // These should only be used by MainRootWindow
    property var planController:    _planController
    property var guidedController:  _guidedController

    property string currentTab: ""


    // Properties of UTM adapter
    property bool utmspSendActTrigger: false

    PlanMasterController {
        id:                     _planController
        flyView:                true
        Component.onCompleted:  start()
    }
    FireZoneManager {
        id: fireManager  // Khởi tạo ở cấp cao nhất
    }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:     _planController.missionController
    property var    _geoFenceController:    _planController.geoFenceController
    property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property var    _guidedController:      guidedActionsController
    property var    _guidedValueSlider:     guidedValueSlider
    property var    _widgetLayer:           widgetLayer
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl

    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
    }

    function dropMainStatusIndicatorTool() {
        toolbar.dropMainStatusIndicatorTool();
    }

    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 10
        //visible: _activeVehicle.type === "Mock Link" // Tính năng development, không cần thiết
        z: 100

        QGCButton {
            text: "Tạo vùng cháy"
            onClicked: {
                if (_activeVehicle && _activeVehicle.coordinate.isValid) {
                    const coord = fireManager.generateRandomFireZone(_activeVehicle.coordinate, 20, 50)
                    fireManager.createFireZone(
                        coord,
                        50,
                        "Khu vực Tây Nguyên",
                        "Đang cháy",
                        5,
                        "https://hocviendrone.vn/wp-content/uploads/2021/07/Drone-tren-cao.jpg",
                        new Date(2025, 6, 11, 8, 30, 0)
                    )

                    console.log("Chi tiết _activeVehicle:");
                    Object.keys(_activeVehicle).forEach(key => {
                        let value = _activeVehicle[key];
                        let type = typeof value;
                        console.log(`${key} [${type}]:`, value);
                    });


                }
            }
        }

        QGCButton {
            text: "Xóa toàn bộ"
            onClicked: {
                fireManager.clearAllFireZones()
                // console.log("🧹 Đã xoá toàn bộ vùng cháy.")
            }
        }
    }

    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeBottomInset:    _pipView.leftEdgeBottomInset
        bottomEdgeLeftInset:    _pipView.bottomEdgeLeftInset
    }

    FlyViewToolBar {
        id:         toolbar
        visible:    !QGroundControl.videoManager.fullScreen
    }

    Item {
        id:                 mapHolder
        // anchors.top:        toolbar.bottom
        z: -1
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.left:       parent.left
        anchors.right:      parent.right

        FlyViewMap {
            id:                     mapControl
            planMasterController:   _planController
            rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
            pipView:                _pipView
            pipMode:                !_mainWindowIsMap
            toolInsets:             customOverlay.totalToolInsets
            mapName:                "FlightDisplayView"
            enabled:                !viewer3DWindow.isOpen

            fireManager: fireManager
        }

        FlyViewVideo {
            id:         videoControl
            pipView:    _pipView
        }

        // bản đồ nhỏ ở dưới
            PipView {
                id:                     _pipView
                anchors.right:          parent.right
                anchors.top:            parent.top
                anchors.margins:        _toolsMargin
                anchors.topMargin:      100
                item1IsFullSettingsKey: "MainFlyWindowIsMap"
                item1:                  mapControl
                item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
                show:                   QGroundControl.videoManager.hasVideo && !QGroundControl.videoManager.fullScreen &&
                                            (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
                z:                      100

                property real leftEdgeBottomInset: visible ? width + anchors.margins : 0
                property real bottomEdgeLeftInset: visible ? height + anchors.margins : 0
            }


        // toàn bộ la bàn gốc trên
        FlyViewWidgetLayer {
            id:                     widgetLayer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            z:                      9999
            parentToolInsets:       _toolInsets
            mapControl:             _mapControl
            visible:                !QGroundControl.videoManager.fullScreen
            utmspActTrigger:        utmspSendActTrigger
            isViewer3DOpen:         viewer3DWindow.isOpen
        }

        FlyViewCustomLayer {
            id:                 customOverlay
            anchors.fill:       widgetLayer
            z:                  _fullItemZorder + 2
            parentToolInsets:   widgetLayer.totalToolInsets
            mapControl:         _mapControl
            visible:            !QGroundControl.videoManager.fullScreen
        }

        // Development tool for visualizing the insets for a paticular layer, show if needed
        // bất chế độ development
        FlyViewInsetViewer {
            id:                     widgetLayerInsetViewer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            z:                      widgetLayer.z + 1
            insetsToView:           widgetLayer.totalToolInsets
            visible:                false
        }

        GuidedActionsController {
            id:                 guidedActionsController
            missionController:  _missionController
            guidedValueSlider:     _guidedValueSlider
        }

        //-- Guided value slider (e.g. altitude)
        // bất chế độ development
        GuidedValueSlider {
            id:                 guidedValueSlider
            anchors.right:      parent.right
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            z:                  QGroundControl.zOrderTopMost
            visible:            false // QGroundControl.developmentMode
        }

        Viewer3D{
            id:                     viewer3DWindow
            anchors.fill:           parent
        }

        ControlMenuBottom {
            id:                     controlMenuBottom
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.bottomMargin:  60
            // anchors.margins:        _margins
            width: parent.width * 0.8
            // height: 80
            z:                      10

            currentTab: _root.currentTab
        }

        ControlMenuTop{
            id:                     controlMenuTop
            anchors.top:         parent.top
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.topMargin:  60
            width: parent.width * 0.8
            height: 24
            z:                      10

            currentTab: _root.currentTab

            onTabChanged: {
                _root.currentTab = newTab
            }
        }

        // Rectangle {
        //     width: parent.width
        //     height: 50
        //     anchors.bottom: parent.bottom
        //     gradient: Gradient {
        //         orientation: Gradient.Vertical  // Dọc: từ trên (0.0) xuống dưới (1.0)
        //         GradientStop {
        //             position: 0.0     // Trên cùng
        //             color: "#00000000"  // Trong suốt
        //         }
        //         GradientStop {
        //             position: 1.0     // Dưới cùng
        //             color: "#b5000000"  // Đen đậm với alpha
        //         }
        //     }
        // }


    }
}
