import QtQuick 2.0
import QtCharts 2.2

ChartView {
    id: chart
    width: 400
    property int plotInterval: 100; //сколько МК шагов отображать на графике
    property int majorTicsCount: 5;
    property int minorTicsCount: 3;
    property bool showAllFrames: false;
    onPlotIntervalChanged: Js.updateTimeAxis();

    legend.markerShape: Legend.MarkerShapeCircle;

    property alias timePos: timePos
    property real timeFrom: 0
    property real timeTo: 100




    //----------------mx
    property alias mxMin: mxAxis.min
    property alias mxMax: mxAxis.max
    property alias mxEnabled: mxLine.visible

    VXYModelMapper{
        id: mxModel
        xColumn: 1
        yColumn: 0
        series: mxLine
        model: plotModel
    }

    LineSeries {
        id: mxLine
        name: "Mx"
        axisX: mxAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: mxAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "mx"
        visible: mxLine.visible
    }

    //----------------my
    property alias myMin: myAxis.min
    property alias myMax: myAxis.max
    property alias myEnabled: myLine.visible

    VXYModelMapper{
        id: myModel
        xColumn: 2
        yColumn: 0
        series: myLine
        model: plotModel
    }

    LineSeries {
        id: myLine
        name: "My"
        axisX: myAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: myAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "my"
        visible: myLine.visible
    }

    //----------------mz
    property alias mzMin: mzAxis.min
    property alias mzMax: mzAxis.max
    property alias mzEnabled: mzLine.visible

    VXYModelMapper{
        id: mzModel
        xColumn: 3
        yColumn: 0
        series: mzLine
        model: plotModel
    }

    LineSeries {
        id: mzLine
        name: "Mz"
        axisX: mzAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: mzAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "mz"
        visible: mzLine.visible
    }

    //----------------m
    property alias mMin: mAxis.min
    property alias mMax: mAxis.max
    property alias mEnabled: mLine.visible

    VXYModelMapper{
        id: mModel
        xColumn: 4
        yColumn: 0
        series: mLine
        model: plotModel
    }

    LineSeries {
        id: mLine
        name: "|M|"
        axisX: mAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: mAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "|M|"
        visible: mLine.visible
    }

    //----------------e
    property alias eMin: eAxis.min
    property alias eMax: eAxis.max
    property alias eEnabled: eLine.visible

    VXYModelMapper{
        id: eModel
        xColumn: 5
        yColumn: 0
        series: eLine
        model: plotModel
    }

    LineSeries {
        id: eLine
        name: "E"
        axisX: eAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: eAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "E"
        visible: eLine.visible
    }

    //----------------t
    property alias tMin: tAxis.min
    property alias tMax: tAxis.max
    property alias tEnabled: tLine.visible

    VXYModelMapper{
        id: tModel
        xColumn: 6
        yColumn: 0
        series: tLine
        model: plotModel
    }

    LineSeries {
        id: tLine
        name: "T"
        axisX: tAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: tAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "T"
        visible: tLine.visible
    }

    //----------------ax
    property alias axMin: axAxis.min
    property alias axMax: axAxis.max
    property alias axEnabled: axLine.visible

    VXYModelMapper{
        id: axModel
        xColumn: 7
        yColumn: 0
        series: axLine
        model: plotModel
    }

    LineSeries {
        id: axLine
        name: "Ax"
        axisX: axAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: axAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Ax"
        visible: axLine.visible
    }

    //----------------ay
    property alias ayMin: ayAxis.min
    property alias ayMax: ayAxis.max
    property alias ayEnabled: ayLine.visible

    VXYModelMapper{
        id: ayModel
        xColumn: 8
        yColumn: 0
        series: ayLine
        model: plotModel
    }

    LineSeries {
        id: ayLine
        name: "Ay"
        axisX: ayAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: ayAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Ay"
        visible: ayLine.visible
    }

    //----------------az
    property alias azMin: azAxis.min
    property alias azMax: azAxis.max
    property alias azEnabled: azLine.visible

    VXYModelMapper{
        id: azModel
        xColumn: 9
        yColumn: 0
        series: azLine
        model: plotModel
    }

    LineSeries {
        id: azLine
        name: "Az"
        axisX: azAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: azAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Az"
        visible: azLine.visible
    }

    //----------------a
    property alias aMin: aAxis.min
    property alias aMax: aAxis.max
    property alias aEnabled: aLine.visible

    VXYModelMapper{
        id: aModel
        xColumn: 10
        yColumn: 0
        series: aLine
        model: plotModel
    }

    LineSeries {
        id: aLine
        name: "|A|"
        axisX: aAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: aAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "|A|"
        visible: aLine.visible
    }

    //----------------hx
    property alias hxMin: hxAxis.min
    property alias hxMax: hxAxis.max
    property alias hxEnabled: hxLine.visible

    VXYModelMapper{
        id: hxModel
        xColumn: 11
        yColumn: 0
        series: hxLine
        model: plotModel
    }

    LineSeries {
        id: hxLine
        name: "Hx"
        axisX: hxAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: hxAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Hx"
        visible: hxLine.visible
    }

    //----------------hy
    property alias hyMin: hyAxis.min
    property alias hyMax: hyAxis.max
    property alias hyEnabled: hyLine.visible

    VXYModelMapper{
        id: hyModel
        xColumn: 12
        yColumn: 0
        series: hyLine
        model: plotModel
    }

    LineSeries {
        id: hyLine
        name: "Hy"
        axisX: hyAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: hyAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Hy"
        visible: hyLine.visible
    }

    //----------------hz
    property alias hzMin: hzAxis.min
    property alias hzMax: hzAxis.max
    property alias hzEnabled: hzLine.visible

    VXYModelMapper{
        id: hzModel
        xColumn: 13
        yColumn: 0
        series: hzLine
        model: plotModel
    }

    LineSeries {
        id: hzLine
        name: "Hz"
        axisX: hzAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: hzAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "Hz"
        visible: hzLine.visible
    }

    //----------------h
    property alias hMin: hAxis.min
    property alias hMax: hAxis.max
    property alias hEnabled: hLine.visible

    VXYModelMapper{
        id: hModel
        xColumn: 14
        yColumn: 0
        series: hLine
        model: plotModel
    }

    LineSeries {
        id: hLine
        name: "|H|"
        axisX: hAxis
        axisYRight: timeAxis
        visible: false
    }

    ValueAxis {
        id: hAxis
        tickCount: chart.majorTicsCount
        minorTickCount: chart.minorTicsCount
        reverse: true
        titleText: "|H|"
        visible: hLine.visible
    }


    // timeline and time position
    ValueAxis {
        id: timeAxis
        min: (showAllFrames)?0:timeFrom
        max: (showAllFrames)?simulator.totalSteps:timeTo
        tickCount: 11
        labelsAngle: 270
        labelFormat: "%d"
        titleText: "mc steps"
    }

    ValueAxis {
        id: timePosAxis
        min: 0
        max: 1
        tickCount: 3
        visible: false
    }

    LineSeries {
        id: timePos
        axisYRight: timeAxis
        axisX: timePosAxis
        name: "cursor"
        color: "#010000"
        XYPoint{x: 0; y: timeSlider.value }
        XYPoint{x: 1; y: timeSlider.value }
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: showAllFrames=!showAllFrames;
    }
}
