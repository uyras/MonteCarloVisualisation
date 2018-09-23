import QtQuick 2.4
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.3

GridLayout {
    rowSpacing: 3
    columns: 2
    Text { text: "nx" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

    SpinBox {
        id: spinBox
    }
    Text { text: "ny" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

    SpinBox {
        id: spinBox2
    }

    Text { text: "initial state"; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; Layout.columnSpan: 2 }

    ComboBox {
        id: comboBox
        Layout.columnSpan: 2
        model: [
            "random",
            "all up",
            "chessboard",
            "line up / line down"
        ]
    }
}
