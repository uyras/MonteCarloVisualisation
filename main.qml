import QtQuick 2.4
import QtCanvas3D 1.1
import QtQuick.Window 2.2
import QtWebEngine 1.7
import QtWebChannel 1.0

import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0
import QtCharts 2.2

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
        property alias t: addFramesDlg.y
        property alias h: addFramesDlg.h
        property alias hx: addFramesDlg.hx
        property alias hy: addFramesDlg.hy
        property alias hz: addFramesDlg.hz
        property alias a: addFramesDlg.a
        property alias ax: addFramesDlg.ax
        property alias ay: addFramesDlg.ay
        property alias az: addFramesDlg.az
    }

    Component.onCompleted: {
        webChannel.registerObject("simulator", simulator);
        newAnimationDlg.open()
        simulator.stepDone.connect(Js.onCalculationStep);
        simulator.allDone.connect(Js.onCalculationFinished);
        simulator.renderComplete.connect(Js.onRenderComplete);
        chartLines.append(0,0);
        chartLines.append(1,2);
        chartLines.append(2,4);
        chartLines.append(3,2);
        chartLines2.append(3,0);
        chartLines2.append(2,2);
        chartLines2.append(1,4);
        chartLines2.append(0,2);
    }

    WebChannel {
        id: webChannel
    }

    WebEngineView {
        id: wew
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        anchors.left: parent.left
        anchors.right: chartRoot.left
        url: "qrc:/spins.html"
        webChannel: webChannel
        width: 90;
    }

    Item {
        id: chartRoot
        width: 200
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: timeSlider.bottom;
        Item {
            y: parent.height
            width: parent.height
            height: parent.width
            rotation: 270
            transformOrigin: Item.TopLeft
            ChartView {
                id: chart
                anchors.fill: parent

                ValueAxis {
                    id: va1
                    min: 0
                    max: 4
                }

                ValueAxis {
                    id: va2
                    min: 0
                    max: 4
                }

                ValueAxis {
                    id: va3
                    min: 0
                    max: 3
                }

                LineSeries {
                    id: chartLines
                    name: "one"
                }

                LineSeries {
                    id: chartLines2
                    name: "two"
                }
            }
        }
    }

    Rectangle {
        id: checkBoxItem
        width: checkBoxList.width
        height: checkBoxList.height
        anchors.right: wew.right
        color: "#80ffffff"
        radius: 10
        border.width: 1
        border.color: "white"
        Column {
            id: checkBoxList
            CheckBox {
                id: chbArrows
                text: "arrows"
                checked: true;
            }

            CheckBox {
                text: "surface"
            }
            CheckBox {
                text: "lattice"
            }
            CheckBox {
                text: "axis"
            }
            Button {
                text: "dbg"
                onClicked: Js.showProgressBar()
            }
            Button {
                text: "dbg2"
                onClicked: Js.hideProgressBar()
            }
            Button {
                text: "dbg3"
                onClicked: {

                    Js.hideProgressBar()
                }
            }
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
