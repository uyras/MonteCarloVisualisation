import QtQuick 2.4
import QtQuick.Window 2.2
import QtWebEngine 1.7
import QtWebChannel 1.0

import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0

import "qmljs.js" as Js

Window {
    id: window
    title: qsTr("FePtMagDynamicVisualisation2")
    width: 640
    height: 360
    visible: true

    property int stepsPerSecond: 30 //how many frames should be in one second of video

    property int nx: 0;
    property int ny: 0;
    property bool isAnimationStarted: false;

    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height

        property alias nx: newAnimationDlg.nx
        property alias ny: newAnimationDlg.ny
        property alias initState: newAnimationDlg.initState
        property alias randomSeed: newAnimationDlg.randomSeed

        property alias framesCount: addFramesDlg.framesCount
        property alias t: addFramesDlg.tStore
        property alias h: addFramesDlg.hStore
        property alias hx: addFramesDlg.hxStore
        property alias hy: addFramesDlg.hyStore
        property alias hz: addFramesDlg.hzStore
        property alias a: addFramesDlg.aStore
        property alias ax: addFramesDlg.axStore
        property alias ay: addFramesDlg.ayStore
        property alias az: addFramesDlg.azStore

        property alias showPlotCheckbox: showPlotCheckbox.checked
    }

    Component.onCompleted: {
        webChannel.registerObject("simulator", simulator);
        newAnimationDlg.open()
        simulator.stepDone.connect(Js.onCalculationStep);
        simulator.allDone.connect(Js.onCalculationFinished);
        simulator.renderComplete.connect(Js.onRenderComplete);
        plotModel.minMaxChanged.connect(function(){console.log(JSON.stringify(plotModel.minmax))}); //needed for better debug
    }

    WebChannel {
        id: webChannel
    }

    WebEngineView {
        id: wew
        url: "qrc:/spins.html"
        webChannel: webChannel
        width: 90;
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        anchors.left: parent.left
        anchors.right: (showPlotCheckbox.checked) ? layoutSeparator.left : parent.right
    }

    Rectangle {
        id: layoutSeparator
        width: 5
        x: parent.width - 300
        color: "#dbdbdb"
        border.width: 0
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        visible: showPlotCheckbox.checked

        MouseArea {
            id: dragArea
            anchors.fill: parent
            cursorShape: Qt.SplitHCursor
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: window.width / 3
            drag.maximumX: window.width-200
        }
    }

    PlotRoot {
        id: plot
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        anchors.left: layoutSeparator.right
        anchors.right: parent.right
        visible: showPlotCheckbox.checked

        mxMin: plotModel.minmax.mxMin
        mxMax: plotModel.minmax.mxMax
        mxEnabled: chkPlot_mx.checked

        myMin: plotModel.minmax.myMin
        myMax: plotModel.minmax.myMax
        myEnabled: chkPlot_my.checked

        mzMin: plotModel.minmax.mzMin
        mzMax: plotModel.minmax.mzMax
        mzEnabled: chkPlot_mz.checked

        mMin: plotModel.minmax.mMin
        mMax: plotModel.minmax.mMax
        mEnabled: chkPlot_m.checked

        eMin: plotModel.minmax.eMin
        eMax: plotModel.minmax.eMax
        eEnabled: chkPlot_e.checked

        tMin: plotModel.minmax.tMin
        tMax: plotModel.minmax.tMax
        tEnabled: chkPlot_t.checked

        axMin: plotModel.minmax.axMin
        axMax: plotModel.minmax.axMax
        axEnabled: chkPlot_ax.checked

        ayMin: plotModel.minmax.ayMin
        ayMax: plotModel.minmax.ayMax
        ayEnabled: chkPlot_ay.checked

        azMin: plotModel.minmax.azMin
        azMax: plotModel.minmax.azMax
        azEnabled: chkPlot_az.checked

        aMin: plotModel.minmax.aMin
        aMax: plotModel.minmax.aMax
        aEnabled: chkPlot_a.checked

        hxMin: plotModel.minmax.hxMin
        hxMax: plotModel.minmax.hxMax
        hxEnabled: chkPlot_hx.checked

        hyMin: plotModel.minmax.hyMin
        hyMax: plotModel.minmax.hyMax
        hyEnabled: chkPlot_hy.checked

        hzMin: plotModel.minmax.hzMin
        hzMax: plotModel.minmax.hzMax
        hzEnabled: chkPlot_hz.checked

        hMin: plotModel.minmax.hMin
        hMax: plotModel.minmax.hMax
        hEnabled: chkPlot_h.checked
    }

    Button {
        text: "settings"
        onClicked: imgSettings.open()
        anchors.right: wew.right

        Menu {
            id: imgSettings
            y: parent.height
            x: parent.width - width

            MenuItem {
                id: showPlotCheckbox
                text: "show plot"
                checkable: true
                checked: false
            }

            MenuSeparator{}


            MenuItem {
                id: chkPlot_e
                text: "E"
                checkable: true
                enabled: plotModel.minmax.eMin!==plotModel.minmax.eMax
            }

            MenuItem {
                id: chkPlot_t
                text: "T"
                checkable: true
                enabled: plotModel.minmax.tMin!==plotModel.minmax.tMax
            }

            Menu {
                title: "Vector M"

                MenuItem {
                    id: chkPlot_m
                    text: "|M|"
                    checkable: true
                    enabled: plotModel.minmax.mMin!==plotModel.minmax.mMax
                }

                MenuItem {
                    id: chkPlot_mx
                    text: "Mx"
                    checkable: true
                    enabled: plotModel.minmax.mxMin!==plotModel.minmax.mxMax
                }

                MenuItem {
                    id: chkPlot_my
                    text: "My"
                    checkable: true
                    enabled: plotModel.minmax.myMin!==plotModel.minmax.myMax
                }

                MenuItem {
                    id: chkPlot_mz
                    text: "Mz"
                    checkable: true
                    enabled: plotModel.minmax.mzMin!==plotModel.minmax.mzMax
                    checked: true
                }
            }

            Menu {
                title: "Vector A"

                MenuItem {
                    id: chkPlot_a
                    text: "A"
                    checkable: true
                    enabled: plotModel.minmax.aMin!==plotModel.minmax.aMax
                }

                MenuItem {
                    id: chkPlot_ax
                    text: "Ax"
                    checkable: true
                    enabled: plotModel.minmax.axMin!==plotModel.minmax.axMax
                }

                MenuItem {
                    id: chkPlot_ay
                    text: "Ay"
                    checkable: true
                    enabled: plotModel.minmax.ayMin!==plotModel.minmax.ayMax
                }

                MenuItem {
                    id: chkPlot_az
                    text: "Az"
                    checkable: true
                    enabled: plotModel.minmax.azMin!==plotModel.minmax.azMax
                }
            }


            Menu{
                title: "Vector H"

                MenuItem {
                    id: chkPlot_h
                    text: "|H|"
                    checkable: true
                    enabled: plotModel.minmax.hMin!==plotModel.minmax.hMax
                }

                MenuItem {
                    id: chkPlot_hx
                    text: "Hx"
                    checkable: true
                    enabled: plotModel.minmax.hxMin!==plotModel.minmax.hxMax
                }

                MenuItem {
                    id: chkPlot_hy
                    text: "Hy"
                    checkable: true
                    enabled: plotModel.minmax.hyMin!==plotModel.minmax.hyMax
                }

                MenuItem {
                    id: chkPlot_hz
                    text: "Hz"
                    checkable: true
                    enabled: plotModel.minmax.hzMin!==plotModel.minmax.hzMax
                }
            }

            /*MenuItem {
                text: "сделать хорошо"
                onClicked: chart.zoomIn()
            }
            MenuItem {
                text: "еще лучше"
                onClicked: chart.zoomOut()
            }*/
        }
    }

    Slider {
        id: timeSlider
        height: 40
        to: simulator.totalSteps-1
        stepSize: 1
        value: 0
        anchors.bottom: toolBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        onValueChanged: Js.onSliderChanged();
    }

    Timer {
        id: animationTimer
        interval: 1000/stepsPerSecond
        repeat: false
        running: false
        onTriggered: Js.onAnimateTimer();
    }

    ToolBar {
        id: toolBar
        y: 172
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            id: row
            anchors.fill: parent

            ToolButton {
                id: btnNew
                text: "Add frames"
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-add-24px.svg"
                onClicked: addFramesDlg.open()
            }

            ToolButton {
                id: btnSettings
                text: "Simulation settings"
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-settings-24px.svg"
                onClicked: newAnimationDlg.open()
            }

            ToolSeparator {}
            Item{ Layout.fillWidth: true; }
            ToolSeparator {}



            ToolButton {
                id: btnToStart
                text: "Go to start"
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-skip_previous-24px.svg"
                onClicked: timeSlider.value = 0;
            }
            ToolButton {
                id: btnPrevStep
                text: "Previous step"
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-fast_rewind-24px.svg"
                onClicked: timeSlider.value -= 1;
            }
            ToolButton {
                id: btnPause
                text: "Pause animation"
                display: AbstractButton.IconOnly
                visible: isAnimationStarted
                icon.source: "icons/outline-pause_circle_outline-24px.svg"
                onClicked: Js.stopAnimation()
            }
            ToolButton {
                id: btnPlay
                text: "Play animation"
                display: AbstractButton.IconOnly
                visible: !isAnimationStarted
                icon.source: "icons/outline-play_circle_filled_white-24px.svg"
                onClicked: {
                    if (timeSlider.value === timeSlider.to)
                        timeSlider.value = timeSlider.from;
                    Js.startAnimation();
                }
            }
            ToolButton {
                id: btnNextStep
                text: qsTr("Next step")
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-fast_forward-24px.svg"
                onClicked: timeSlider.value += 1;
            }
            ToolButton {
                id: btnToEnd
                text: qsTr("Go to end")
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-skip_next-24px.svg"
                onClicked: timeSlider.value = timeSlider.to;
            }

            ToolSeparator {}

            Item{ Layout.fillWidth: true; }

            ToolSeparator {}

            Label {
                text: (timeSlider.to === -1) ? "no frames" : (timeSlider.value+1) + "/" + (timeSlider.to+1)
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }

            ToolButton {
                id: btnCenterView
                text: "Center view"
                display: AbstractButton.IconOnly
                icon.source: "icons/baseline-center_focus_strong-24px.svg"
                onClicked: simulator.centerView();
            }

            ToolButton {
                id: btnSave
                text: qsTr("Tool Button")
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-save-24px.svg"
            }
        }
    }

    NewAnimationDialog{
        id: newAnimationDlg
        closePolicy: Popup.NoAutoClose
        onAccepted: Js.onNewAnimation();

        nx: 10
        ny: 10
        initState: 1
        randomSeed: 1
    }

    AddFramesDialog {
        id: addFramesDlg
        closePolicy: Popup.NoAutoClose
        onAccepted: Js.onAddFrames(addFramesDlg.framesCount)
    }

    Popup {
        id: pbPopUp
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width*0.8
        height: 150
        modal: true
        closePolicy: Popup.NoAutoClose
        contentItem: CalculationStatusBar {
            id: pbItem
            width: parent.width
            height: parent.height
            onClicked: Js.onCalculationForceStopped()
        }
    }
}
