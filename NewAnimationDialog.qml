import QtQuick 2.4
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.3

CenterDialog {
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel
    title: "Start new simulation"

    property alias nx: fieldNx.value
    property alias ny: fieldNy.value
    property alias initState: fieldInitState.currentIndex
    property alias randomSeed: fieldRandomSeed.value

    contentItem: GridLayout {
        rowSpacing: 3
        columns: 2
        Text {  text: "nx" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

        SpinBox {
            id: fieldNx;
            editable: true;
            from: 1
            to: 500
            value: 10
        }

        Text { text: "ny" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }
        SpinBox {
            id: fieldNy;
            editable: true;
            from: 1
            to: 500
            value: 10
        }

        Text { text: "initial state"; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

        ComboBox {
            id: fieldInitState
            model: [
                "random",
                "all up",
                "chessboard",
                "line up / line down"
            ]
        }

        Text { text: "random seed" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

        SpinBox {
            id: fieldRandomSeed;
            editable: true;
            from: 1
            to: 99999
            value: 1
        }
    }
}

