import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ColumnLayout{
    property alias text: pbtext.text
    property alias indeterminate: pb.indeterminate
    property int value: 0
    property int to: 0
    height: 150
    width: 500
    signal clicked();

    ProgressBar{
        Layout.fillWidth: true
        id: pb
        Layout.preferredHeight: 50
        value: parent.value / parent.to
    }

    Text{
        id: pbtext;
        text: (indeterminate) ? "finishing..." : "step "+value+" of "+to;
        verticalAlignment: Text.AlignVCenter
        Layout.fillWidth: true
        font.pixelSize: 25
        horizontalAlignment: Text.AlignHCenter
        Layout.fillHeight: true
    }

    Button{
        id: pbCancel
        text: "stop"
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        onClicked: parent.clicked();
    }
}
