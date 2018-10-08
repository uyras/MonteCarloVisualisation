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
    property alias t: fieldT.value
    property alias h: fieldH.value
    property alias hx: fieldHX.value
    property alias hy: fieldHy.value
    property alias hz: fieldHZ.value
    property alias a: fieldA.value
    property alias ax: fieldAX.value
    property alias ay: fieldAY.value
    property alias az: fieldAZ.value

    contentItem: GridLayout {
        rowSpacing: 3
        columns: 2
        Text { text: "frames count" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

        SpinBox {
            id: fieldFramesCount
        }

        Text { text: "T"; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        SpinBox {
            id: fieldT
            value: 1
            stepSize: 0
            Layout.fillWidth: true;
        }

        Text { text: "H" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        SpinBox {
            id: fieldH
            stepSize: 0
            value: 1
            Layout.fillWidth: true;
        }

        Text { text: "H vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        Row {
            id: item1
            Layout.fillWidth: true;

            SpinBox {
                id: fieldHX
            }

            SpinBox {
                id: fieldHy
            }

            SpinBox {
                id: fieldHZ
            }

        }


        Text { text: "anisotropy" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }
        SpinBox {
            id: fieldA
            Layout.fillWidth: true;
        }

        Text { text: "anisotropy vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }



        Row {
            id: item2
            Layout.fillWidth: true;

            SpinBox {
                id: fieldAX
            }

            SpinBox {
                id: fieldAY
            }

            SpinBox {
                id: fieldAZ
            }

        }
    }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
