/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.Controls
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QtQuick.Controls


Rectangle {
    id: topRightPanel
    width: topRightPanel.visible ? contentWidth : 0
    height: 380

    border.width: 1
    border.color: qgcPal.globalTheme === QGCPalette.Light ? "#9dffffff": "#9d222222"

    color: qgcPal.toolbarBackground
    radius: ScreenTools.defaultFontPixelHeight / 2
    visible: panelVisibleCondition 
    clip: true


    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    onWidthChanged: {
        if (width === 0 && !visible) {
            visible = false
        }
    }

    onUserToggleVisibleChanged: {
        if (userToggleVisible) {
            visible = true
        }
    }

    property bool userToggleVisible: true
    property bool panelVisibleCondition: !QGroundControl.videoManager.fullScreen && _multipleVehicles && _settingEnableMVPanel
    property bool _settingEnableMVPanel: QGroundControl.settingsManager.appSettings.enableMultiVehiclePanel.value
    property bool _multipleVehicles: QGroundControl.multiVehicleManager.vehicles.count > 1

    property var vehicles: QGroundControl.multiVehicleManager.vehicles
    property var selectedVehicles: QGroundControl.multiVehicleManager.selectedVehicles
    property real contentWidth: Math.max(multiVehicleList.implicitWidth, swipeViewContainer.implicitWidth) + ScreenTools.defaultFontPixelHeight
    property real contentHeight: Math.min(maximumHeight, topRightPanelColumnLayout.implicitHeight + topRightPanelColumnLayout.spacing * (topRightPanelColumnLayout.children.length - 1))
    property real minimumHeight: selectedVehiclesLabel.height + swipeViewContainer.height
    property real maximumHeight

    QGCPalette {
        id: qgcPal
    }

    DeadMouseArea {
        anchors.fill: parent
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true
        Item {
            width: scrollView.width
            // visible: userToggleVisible
            implicitHeight: topRightPanelColumnLayout.implicitHeight

            ColumnLayout {
                id: topRightPanelColumnLayout
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: ScreenTools.defaultFontPixelHeight    // Padding trái
                    rightMargin: ScreenTools.defaultFontPixelHeight   // Padding phải
                }
                spacing: ScreenTools.defaultFontPixelHeight / 2

                Item { Layout.preferredHeight: ScreenTools.defaultFontPixelHeight *0.5 } // Spacer

                QGCLabel {
                    id: selectedVehiclesLabel
                    text: {
                        let ids = Array.from({
                            length: selectedVehicles.count
                        }, (_, i) => selectedVehicles.get(i).id).sort((a, b) => a - b).join(", ");
                        return qsTr("Selected: ") + ids;
                    }
                }

                MultiVehicleList {
                    id: multiVehicleList
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        visible: topRightPanel.height === maximumHeight

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 0
                            height: 1
                            color: QGroundControl.globalPalette.groupBorder
                        }

                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop {
                                position: 0.00
                                color: topRightPanel.color
                            }
                            GradientStop {
                                position: 0.05
                                color: "transparent"
                            }

                            GradientStop {
                                position: 0.95
                                color: "transparent"
                            }
                            GradientStop {
                                position: 1.00
                                color: topRightPanel.color
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 0
                            height: 1
                            color: QGroundControl.globalPalette.groupBorder
                        }
                    }
                }

                Rectangle {
                    id: swipeViewContainer
                    Layout.fillWidth: true
                    implicitHeight: swipePages.implicitHeight
                    implicitWidth: swipePages.implicitWidth
                    color: "transparent"

                    QGCSwipeView {
                        id: swipePages
                        anchors.fill: parent
                        spacing: ScreenTools.defaultFontPixelHeight
                        implicitHeight: Math.max(buttonsPage.implicitHeight, photoVideoPage.implicitHeight)
                        implicitWidth: Math.max(buttonsPage.implicitWidth, photoVideoPage.implicitWidth)

                        MvPanelPage {
                            id: buttonsPage
                            implicitHeight: buttonsColumnLayout.implicitHeight + ScreenTools.defaultFontPixelHeight * 2
                            implicitWidth: buttonsColumnLayout.implicitWidth + ScreenTools.defaultFontPixelHeight * 2

                            ColumnLayout {
                                id: buttonsColumnLayout
                                anchors.right: parent.right
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: ScreenTools.defaultFontPixelHeight / 2
                                implicitHeight: Math.max(selectionRowLayout.height, actionGridLayout.height) + ScreenTools.defaultFontPixelHeight * 2
                                implicitWidth: Math.max(selectionRowLayout.width, actionGridLayout.width) + ScreenTools.defaultFontPixelHeight * 4

                                QGCLabel {
                                    text: qsTr("Multi Vehicle Selection")
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                RowLayout {
                                    id: selectionRowLayout
                                    Layout.alignment: Qt.AlignHCenter

                                    QGCButton {
                                        text: qsTr("Select All")
                                        enabled: multiVehicleList.selectedVehicles && multiVehicleList.selectedVehicles.count !== QGroundControl.multiVehicleManager.vehicles.count
                                        onClicked: multiVehicleList.selectAll()
                                    }

                                    QGCButton {
                                        text: qsTr("Deselect All")
                                        enabled: multiVehicleList.selectedVehicles && multiVehicleList.selectedVehicles.count > 0
                                        onClicked: multiVehicleList.deselectAll()
                                    }
                                }

                                QGCLabel {
                                    text: qsTr("Multi Vehicle Actions")
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                GridLayout {
                                    id: actionGridLayout
                                    columns: 2
                                    columnSpacing: ScreenTools.defaultFontPixelHeight * 0.5
                                    rowSpacing: ScreenTools.defaultFontPixelHeight *0.5
                                    Layout.alignment: Qt.AlignHCenter

                                    QGCButton {
                                        text: qsTr("Arm")
                                        enabled: multiVehicleList.armAvailable()
                                        onClicked: _guidedController.confirmAction(_guidedController.actionMVArm)
                                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5
                                        leftPadding: 0
                                        rightPadding: 0
                                    }

                                    QGCButton {
                                        text: qsTr("Disarm")
                                        enabled: multiVehicleList.disarmAvailable()
                                        onClicked: _guidedController.confirmAction(_guidedController.actionMVDisarm)
                                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5
                                        leftPadding: 0
                                        rightPadding: 0
                                    }

                                    QGCButton {
                                        text: qsTr("Start")
                                        enabled: multiVehicleList.startAvailable()
                                        onClicked: _guidedController.confirmAction(_guidedController.actionMVStartMission)
                                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5
                                        leftPadding: 0
                                        rightPadding: 0
                                    }

                                    QGCButton {
                                        text: qsTr("Pause")
                                        enabled: multiVehicleList.pauseAvailable()
                                        onClicked: _guidedController.confirmAction(_guidedController.actionMVPause)
                                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5
                                        leftPadding: 0
                                        rightPadding: 0
                                    }
                                }

                            }
                        } // Page 1

                        MvPanelPage {
                            id: photoVideoPage
                            implicitHeight: photoVideoControlLoader.implicitHeight + ScreenTools.defaultFontPixelHeight * 2
                            implicitWidth: photoVideoControlLoader.implicitWidth + ScreenTools.defaultFontPixelHeight * 2

                            // We use a Loader to load the photoVideoControlComponent only when the active vehicle is not null
                            // This make it easier to implement PhotoVideoControl without having to check for the mavlink camera
                            // to be null all over the place

                            Loader {
                                id: photoVideoControlLoader
                                anchors.horizontalCenter: parent.horizontalCenter
                                sourceComponent: globals.activeVehicle ? photoVideoControlComponent : undefined

                                property real rightEdgeCenterInset: visible ? parent.width - x : 0

                                Component {
                                    id: photoVideoControlComponent

                                    PhotoVideoControl {}
                                }
                            }
                        } // Page 2
                    } // QGCSwipeView

                    QGCPageIndicator {
                        id: pageIndicator
                        count: swipePages.count
                        currentIndex: swipePages.currentIndex
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: ScreenTools.defaultFontPixelHeight / 4

                        delegate: Rectangle {
                            height: ScreenTools.defaultFontPixelHeight / 2
                            width: height
                            radius: width / 2
                            color: model.index === pageIndicator.currentIndex ? qgcPal.text : qgcPal.button
                            opacity: model.index === pageIndicator.currentIndex ? 0.9 : 0.3
                        }
                    }
                }

                Item { Layout.preferredHeight: ScreenTools.defaultFontPixelHeight }
            }
        }
    }
}
