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
    }

    property var simulationData: [
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.83534,-0.293583,-0.464774],
            [2,0,0,-0.500089,-0.756685,0.421116],
            [0,1,0,-0.843605,-0.509762,-0.168738],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.140612,-0.963233,0.228934],
            [0,2,0,0.651959,-0.00985708,-0.75819],
            [1,2,0,0.396676,0.588702,0.704328],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.83534,-0.293583,-0.464774],
            [2,0,0,-0.500089,-0.756685,0.421116],
            [0,1,0,-0.803447,-0.583701,-0.117328],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.011718,-0.938031,0.346353],
            [0,2,0,0.585115,-0.0273442,-0.810489],
            [1,2,0,0.310066,0.596101,0.740623],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.951286,-0.202605,-0.232392],
            [1,0,0,0.676121,-0.254182,-0.691558],
            [2,0,0,-0.3462,-0.923131,0.167256],
            [0,1,0,-0.794966,-0.44841,-0.408606],
            [1,1,0,-0.25757,-0.707212,-0.658414],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.492043,-0.236171,-0.837925],
            [1,2,0,0.290642,0.742164,0.603921],
            [2,2,0,-0.826061,0.187298,0.531548],
        ],
        [
            [0,0,0,-0.951286,-0.202605,-0.232392],
            [1,0,0,0.739176,-0.257751,-0.622241],
            [2,0,0,-0.357696,-0.896877,0.260127],
            [0,1,0,-0.8085,-0.471917,-0.351598],
            [1,1,0,-0.25757,-0.707212,-0.658414],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.533091,-0.19894,-0.822336],
            [1,2,0,0.290996,0.675372,0.677639],
            [2,2,0,-0.804177,0.162142,0.571848],
        ],
        [
            [0,0,0,-0.951286,-0.202605,-0.232392],
            [1,0,0,0.739176,-0.257751,-0.622241],
            [2,0,0,-0.531758,-0.787466,0.31166],
            [0,1,0,-0.8085,-0.471917,-0.351598],
            [1,1,0,-0.25757,-0.707212,-0.658414],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.582489,-0.202751,-0.787146],
            [1,2,0,0.290996,0.675372,0.677639],
            [2,2,0,-0.804177,0.162142,0.571848],
        ],
        [
            [0,0,0,-0.951286,-0.202605,-0.232392],
            [1,0,0,0.755599,-0.311608,-0.576169],
            [2,0,0,-0.531758,-0.787466,0.31166],
            [0,1,0,-0.773365,-0.534254,-0.341291],
            [1,1,0,-0.201113,-0.750797,-0.629172],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.582489,-0.202751,-0.787146],
            [1,2,0,0.290996,0.675372,0.677639],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.755599,-0.311608,-0.576169],
            [2,0,0,-0.450888,-0.816906,0.359673],
            [0,1,0,-0.773365,-0.534254,-0.341291],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.542317,-0.292372,-0.787661],
            [1,2,0,0.290996,0.675372,0.677639],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.755599,-0.311608,-0.576169],
            [2,0,0,-0.450888,-0.816906,0.359673],
            [0,1,0,-0.803591,-0.560328,-0.200684],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.0824383,-0.974944,0.20661],
            [0,2,0,0.550965,-0.19819,-0.810653],
            [1,2,0,0.290996,0.675372,0.677639],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.803962,-0.332693,-0.492909],
            [2,0,0,-0.500089,-0.756685,0.421116],
            [0,1,0,-0.803591,-0.560328,-0.200684],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.144605,-0.962617,0.229037],
            [0,2,0,0.559378,-0.206501,-0.802779],
            [1,2,0,0.364575,0.635882,0.680249],
            [2,2,0,-0.73775,0.19098,0.647496],
        ],
        [
            [0,0,0,-0.985776,-0.134263,-0.10109],
            [1,0,0,0.83534,-0.293583,-0.464774],
            [2,0,0,-0.500089,-0.756685,0.421116],
            [0,1,0,-0.841943,-0.507259,-0.183904],
            [1,1,0,-0.231361,-0.792164,-0.564755],
            [2,1,0,0.144605,-0.962617,0.229037],
            [0,2,0,0.672887,-0.160179,-0.722195],
            [1,2,0,0.364575,0.635882,0.680249],
            [2,2,0,-0.73775,0.19098,0.647496],
        ]
    ]

    Component.onCompleted: {
        //newAnimationDlg.open()
    }

    Canvas3D {
        id: canvas3d
        anchors.top: parent.top
        anchors.bottom: timeSlider.top
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true

        onInitializeGL: {
            GLCode.initializeGL(canvas3d);
            window.nx = window.ny = 3;
            timeSlider.onValueChanged();
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
                text: "arrows"
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
        interval: 100
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

            ToolButton {
                id: btnSave
                text: qsTr("Tool Button")
                display: AbstractButton.IconOnly
                icon.source: "icons/outline-save-24px.svg"
            }
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
