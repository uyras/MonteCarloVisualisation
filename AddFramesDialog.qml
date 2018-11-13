import QtQuick 2.4
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.3

CenterDialog {
    id: addFramesDlg
    dim: true
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel
    title: "add frames to simulation"

    property alias framesCount: fieldFramesCount.value
    property alias t: fieldT.realValue
    property alias tStore: fieldT.value
    property alias h: fieldH.realValue
    property alias hStore: fieldH.value
    property alias hx: fieldHx.realValue
    property alias hxStore: fieldHx.value
    property alias hy: fieldHy.realValue
    property alias hyStore: fieldHy.value
    property alias hz: fieldHz.realValue
    property alias hzStore: fieldHz.value
    property alias a: fieldA.realValue
    property alias aStore: fieldA.value
    property alias ax: fieldAx.realValue
    property alias axStore: fieldAx.value
    property alias ay: fieldAy.realValue
    property alias ayStore: fieldAy.value
    property alias az: fieldAz.realValue
    property alias azStore: fieldAz.value

    property bool unitWarningH: (fieldHGroup.hVecLen2 < 0.8 || fieldHGroup.hVecLen2 > 1.2)
    property bool unitWarningA: (fieldAGroup.aVecLen2 < 0.8 || fieldAGroup.aVecLen2 > 1.2)

    contentItem: GridLayout {
        rowSpacing: 3
        columns: 2
        Text { text: "frames count" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

        SpinBox {
            id: fieldFramesCount
            editable: true;
            from: 1
            to: 10000;
            value: 100
        }

        Text { text: "T"; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        DoubleSpinBox {
            id: fieldT
            value: 0.01 * factor
            realStepSize: 1.0
            realFrom: 0.01
            realTo: 10000
            decimals: 2
            editable: true;
            Layout.fillWidth: true;
        }

        Text { text: "H" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        DoubleSpinBox {
            id: fieldH
            value: 0.0 * factor
            realStepSize: 1.0
            realFrom: 0.0
            realTo: 10000
            decimals: 2
            editable: true;
            Layout.fillWidth: true;
        }

        Text { text: "H vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        Row {
            id: fieldHGroup
            Layout.fillWidth: true;
            property real hVecLen2: fieldHx.realValue*fieldHx.realValue + fieldHy.realValue*fieldHy.realValue + fieldHz.realValue*fieldHz.realValue

            DoubleSpinBox {
                id: fieldHx
                value: 0.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }

            DoubleSpinBox {
                id: fieldHy
                value: 0.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }

            DoubleSpinBox {
                id: fieldHz
                value: 1.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }
        }
        Text {
            text: "It is better to set H vector unit-length";
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter;
            color: "red";
            visible: unitWarningH;
            Layout.columnSpan: 2;
            Layout.bottomMargin: 5
        }


        Text { text: "anisotropy" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }
        DoubleSpinBox {
            id: fieldA
            value: 1.0 * factor
            realStepSize: 1.0
            realFrom: 0.0
            realTo: 10000
            decimals: 2
            editable: true;
            Layout.fillWidth: true;
        }

        Text { text: "anisotropy vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }



        Row {
            id: fieldAGroup
            Layout.fillWidth: true;
            property real aVecLen2: fieldAx.realValue*fieldAx.realValue + fieldAy.realValue*fieldAy.realValue + fieldAz.realValue*fieldAz.realValue

            DoubleSpinBox {
                id: fieldAx
                value: 0.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }

            DoubleSpinBox {
                id: fieldAy
                value: 0.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }

            DoubleSpinBox {
                id: fieldAz
                value: 1.0 * factor
                realStepSize: 0.05
                realFrom: 0.0
                realTo: 1
                decimals: 2
                editable: true;
            }
        }
        Text {
            text: "It is better to set Anisotropy vector unit-length";
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter;
            color: "red";
            visible: unitWarningA;
            Layout.columnSpan: 2;
            Layout.bottomMargin: 5
        }
    }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
