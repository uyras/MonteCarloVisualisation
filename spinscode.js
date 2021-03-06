
var poses,mags,x=0,y=0;
var wc = new QWebChannel(qt.webChannelTransport, function(channel) {
    window.simulator = channel.objects.simulator;
    // connect to a signal
    simulator.draw.connect(simulate);
    simulator.setXY.connect(setXY);
    simulator.centerView.connect(centerView);
    simulator.isHelpOpenedValueChanged.connect(function(){
        $("#helpContent").toggle(simulator.isHelpOpened);
    });
});

$(document).ready(function() {
    $.get("qrc:///readme.md",function(data){
        var converter = new showdown.Converter();
        converter.setFlavor('github');
        $('#helpContent').append(converter.makeHtml(data));
        $('a').each(function(){
            if ($(this).attr('href')[0]!=='#'){
                $(this).attr('href',"#");
                //$( this ).replaceWith( $( this ).text() );
            }
        });
    });
    var cim = 'vec3 colormap(vec3 direction) {'+
            '        vec3 color_down = vec3(0.0, 0.0, 1.0);'+
            '        vec3 color_mid = vec3(1.0, 1.0, 1.0);'+
            '        vec3 color_up = vec3(1.0, 0.0, 0.0);'+
            '        if (direction.z < 0.0)'+
            '        return mix(color_mid, color_down, direction.z*-1.0);'+
            '        else'+
            '        return mix(color_mid, color_up, direction.z);'+
            '}';
    webglspins = new WebGLSpins(document.getElementById('webgl-canvas'), {
                                    cameraLocation: [0, 0, 10],
                                    centerLocation: [0, 0, 0],
                                    upVector: [0, 1, 0],
                                    levelOfDetail: 5,
                                    colormapImplementation: cim,
                                    renderers: [
                                        WebGLSpins.renderers.ARROWS,
                                        [WebGLSpins.renderers.SPHERE, [0.0, 0.0, 0.2, 0.2]],
                                         [WebGLSpins.renderers.COORDINATESYSTEM,[0.0,0.2,0.2,0.2]]
                                    ]

                                });
});



function simulate() {
    poses = [];
    mags = [];
    simulator.getPoses(function(res){ poses = JSON.parse(res); runVis(); });
    simulator.getMags(function(res){ mags = JSON.parse(res); runVis(); });
}

function runVis(){
    if (poses.length && mags.length){
        webglspins.updateSpins(poses, mags);
        //var surfaceIndices = WebGLSpins.generateCartesianSurfaceIndices(x, y);
        //webglspins.updateOptions({surfaceIndices: surfaceIndices});
        window.simulator.finishRrender();
    }
}

function setXY(newX, newY){
    webglspins.updateOptions({
                                 cameraLocation: [(newX-1)/2,(newY-1)/2,Math.max(newX,newY)*1.3],
                                 centerLocation: [(newX-1)/2,(newY-1)/2,0],
                                 upVector: [0,1,0]
                             });
    x=newX;
    y=newY;
}

function centerView(){
    setXY(x,y);
}
