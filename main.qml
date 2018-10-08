import QtQuick 2.4
import QtCanvas3D 1.1
import QtQuick.Window 2.2

import "glcode.js" as GLCode
import "viscode.js" as VisCode
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0

Window {
    id: window
    title: qsTr("FePtMagDynamicVisualisation2")
    width: 640
    height: 360
    visible: true

    property int nx: 0;
    property int ny: 0;

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

    property var simulationData: [ ];

    Component.onCompleted: {
        newAnimationDlg.open()
    }

    Canvas3D {
        id: canvas3d
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true
        renderOnDemand: true;

        onInitializeGL: {
            GLCode.initializeGL(canvas3d);
        }

        onPaintGL: {
            GLCode.paintGL(canvas3d);
        }

        onResizeGL: {
            GLCode.resizeGL(canvas3d);
        }

        MouseArea {
            id: canvasMouseArea
            anchors.fill: parent
            onPressed: GLCode.onMouseDown(mouse);
            onReleased: GLCode.onMouseUp(mouse);
            onPositionChanged: GLCode.onMouseMove(mouse);

            onWheel: GLCode.onWheelChanged(wheel)
        }
    }

    Rectangle {
        id: checkBoxItem
        width: checkBoxList.width
        height: checkBoxList.height
        color: "#80ffffff"
        radius: 10
        border.width: 1
        border.color: "white"
        Column {
            id: checkBoxList
            CheckBox {
                id: chbArrows
                text: "arrows"
                onClicked: GLCode.onSwitchArrows();
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
                onClicked: GLCode.dbg()
            }
        }
    }

    Slider {
        id: timeSlider
        height: 40
        to: simulationData.length-1
        stepSize: 1
        value: 0
        anchors.bottom: toolBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        onValueChanged: GLCode.updateArrows(simulationData[value]);
    }

    Timer {
        id: animationTimer
        interval: 50
        repeat: true
        running: false
        onTriggered: GLCode.onAnimate();
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
                visible: animationTimer.running
                icon.source: "icons/outline-pause_circle_outline-24px.svg"
                onClicked: animationTimer.stop();
            }
            ToolButton {
                id: btnPlay
                text: "Play animation"
                display: AbstractButton.IconOnly
                visible: !animationTimer.running
                icon.source: "icons/outline-play_circle_filled_white-24px.svg"
                onClicked: {
                    if (timeSlider.value === timeSlider.to)
                        timeSlider.value = timeSlider.from;
                    animationTimer.start();
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
        onAccepted: {
            console.log("inited");
            window.simulationData = [];
            window.nx = nx;
            window.ny = ny;
            simulator.init(nx,ny,initState,randomSeed);
            addFramesDlg.open();
        }

        nx: 10
        ny: 10
        initState: 1
        randomSeed: 1
    }

    AddFramesDialog {
        id: addFramesDlg
        closePolicy: Popup.NoAutoClose
        onAccepted: {
            console.log("started");
            for (var i=0; i<1000; ++i)
                simulationData.push(simulator.makeStep(0,0,0,0,0,1,0,0,1,0.1));
            timeSlider.to = simulationData.length-1;
            timeSlider.onValueChanged();
        }
    }

    /*
    Dialog {
        id: addFramesDlg
        dim: true
        modal: true
        standardButtons: Dialog.Save | Dialog.Cancel
        title: "add frames to simulation"
        contentItem: AddFramesDialog {}
    }

    Dialog {
        id: newAnimationDlg
        modal: true
        standardButtons: Dialog.Apply | Dialog.Cancel
        title: "Start new simulation"
        contentItem: NewAnimationDialog {}
        onAccepted: console.log("Ok clicked")
    }*/
}
