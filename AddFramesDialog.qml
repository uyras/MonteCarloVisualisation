import QtQuick 2.4
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.3

GridLayout {
    rowSpacing: 3
    columns: 2
    Text { text: "frames count" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter }

    SpinBox {
        id: spinBox
    }

    Text { text: "T"; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

    SpinBox {
        id: spinBox1
        value: 1
        stepSize: 0
        Layout.fillWidth: true;
    }

    Text { text: "H" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

    SpinBox {
        stepSize: 0
        value: 1
        Layout.fillWidth: true;
    }

    Text { text: "H vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }

    Row {
        id: item1
        Layout.fillWidth: true;

        SpinBox {
            id: spinBox2
        }

        SpinBox {
            id: spinBox5
        }

        SpinBox {
            id: spinBox3
        }

    }


    Text { text: "anisotropy" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }
    SpinBox {
        id: spinBox6
        Layout.fillWidth: true;
    }

    Text { text: "anisotropy vector" ; Layout.alignment: Qt.AlignRight | Qt.AlignVCenter; }



    Row {
        id: item2
        Layout.fillWidth: true;

        SpinBox {
        }

        SpinBox {
        }

        SpinBox {
        }

    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
