Qt.include("three.js")
Qt.include("arrowHelper.js")

var camera, scene, renderer;

var plane;
var arrows = [];

var arrowHeadLength = 0.3;
var arrowHeadWidth = 0.25;

var colorOne = new THREE.Color( 0x0000ff );
var colorTwo = new THREE.Color( 0xff0000 );
var colorFrom = -1;
var colorTo = 1;

var colorPlaneGeometry;

var lastMousePos = {x:0, y:0};
var cameraRadius = 5;
var center;

function initializeGL(canvas) {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 0.1, 1000);
    camera.position.z = cameraRadius;

    var material = new THREE.MeshBasicMaterial({    color: 0xffffff,
                                                   shading: THREE.SmoothShading,
                                                   wireframe: false,
                                                   opacity:0.7,
                                                   vertexColors: THREE.VertexColors,
                                                   transparent:true,
                                                   side: THREE.DoubleSide
                                               });

    /*colorPlaneGeometry = new THREE.PlaneBufferGeometry(2, 2, 2, 2);

    var lutColors = new Float32Array( [
                                     1,0,0,
                                     0,0,0,
                                     0,0,1,
                                         0,0,0,
                                         0,1,0,
                                         0,0,0,
                                         0,0,1,
                                         0,0,0,
                                         1,0,0
                                     ]);

    for ( var i = 0; i < simulationData[0].length; i ++ ) {
            lutColors[ 3 * i ] = i/9.;
            lutColors[ 3 * i + 1 ] = 0;
            lutColors[ 3 * i + 2 ] = (9-i/9.);
    }

    colorPlaneGeometry.addAttribute( 'color', new THREE.BufferAttribute( lutColors, 3 ) );*/

    plane = new THREE.Mesh(undefined, material);
    center = plane.position;
    scene.add(plane);


    renderer = new THREE.Canvas3DRenderer(
                { canvas: canvas, antialias: true, devicePixelRatio: canvas.devicePixelRatio     });
    renderer.setSize(canvas.width, canvas.height);
}

function resizeGL(canvas) {
    camera.aspect = canvas.width / canvas.height;
    camera.updateProjectionMatrix();

    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);
}

function paintGL(canvas) {
    renderer.render(scene, camera);
}

function addArrow(){
    var dir = new THREE.Vector3( 1,0,0 );

    var origin = new THREE.Vector3( 1,0,0 );
    var length = 1;
    var hex = 0xffff00;

    var arrowHelper = new THREE.ArrowHelper( dir, origin, length );
    scene.add( arrowHelper );
    arrows.push( arrowHelper );
}

function delArrow(){

}

function updateSurface(){
    plane.geometry = new THREE.PlaneBufferGeometry(window.nx-1, window.ny-1, window.nx-1, window.ny-1);
    plane.geometry.addAttribute( 'color', new THREE.BufferAttribute( new Float32Array( window.nx * window.ny * 3), 3 ) );
    plane.rotateY(Math.PI);
}

function updateArrows(data){
    var centerX = (window.nx-1)/2.;
    var centerY = (window.ny-1)/2.;
    if (data.length !== arrows.length){
        updateSurface();
        if (data.length>arrows.length){
            var steps = data.length-arrows.length;
            for (var n=0; n < steps; ++n)
                addArrow();
        }
    }
    var dir = new THREE.Vector3(  );
    var pos = new THREE.Vector3(  );
    var len = 0;
    var colorFactor;
    for (var i=0; i< data.length; ++i){
        pos.set(data[i][0] - centerX, data[i][1] - centerY, data[i][2]);
        dir.set(data[i][3], data[i][4], data[i][5]);
        len = dir.length();
        dir.normalize();

        arrows[i].position.copy( pos );
        arrows[i].setDirection( dir );
        arrows[i].setLength( len, len * arrowHeadLength, len * arrowHeadWidth );

        colorFactor = (data[i][5] - colorFrom) / (colorTo - colorFrom);
        var newColor = colorBetween(colorOne,colorTwo,colorFactor);
        arrows[i].setColor(newColor);
        newColor.toArray(plane.geometry.attributes.color.array,((data.length - i - 1)*3));
    }
    plane.geometry.colorsNeedUpdate = true;
}

function colorBetween(color1, color2, point){
    var result = new THREE.Color( );
    result.r = (color1.r + point * (color2.r - color1.r));
    result.g = (color1.g + point * (color2.g - color1.g));
    result.b = (color1.b + point * (color2.b - color1.b));
    return result;
}

function onWheelChanged(wheel){
    if (wheel.angleDelta.y > 0){
        updateCameraPos(0,0,-1);
    } else {
        updateCameraPos(0,0,1);
    }
}

var i=0;
function onMouseDown(mouse){
    lastMousePos.x = mouse.x;
    lastMousePos.y = mouse.y;
}

function onMouseUp(mouse){

}

function onMouseMove(mouse){
    if (canvasMouseArea.pressed){
        var radPerPixel = (Math.PI / 360);
        updateCameraPos(
                    (lastMousePos.x - mouse.x) * radPerPixel,
                    (lastMousePos.y - mouse.y) * radPerPixel,
                    0);
        lastMousePos.x = mouse.x;
        lastMousePos.y = mouse.y;
    }
}

function updateCameraPos(ct, cp, cr) {
    var offset = new THREE.Vector3();

    // so camera.up is the orbit axis
    var quat = new THREE.Quaternion().setFromUnitVectors( camera.up, new THREE.Vector3( 0, 1, 0 ) );
    var quatInverse = quat.clone().inverse();

    var position = camera.position;
    offset.copy( position ).sub( center );

    // rotate offset to "y-axis-is-up" space
    offset.applyQuaternion( quat );

    // angle from z-axis around y-axis
    var spherical = new THREE.Spherical();
    spherical.setFromVector3( offset );
    spherical.theta += ct;
    spherical.phi += cp;
    spherical.radius += cr;
    spherical.makeSafe();

    offset.setFromSpherical( spherical );

    // rotate offset back to "camera-up-vector-is-up" space
    offset.applyQuaternion( quatInverse );

    position.copy( center ).add( offset );
    camera.lookAt( center );

    camera.updateProjectionMatrix();
}

function onAnimate(){
    timeSlider.value += 1;
    if (timeSlider.value === timeSlider.to){
        animationTimer.stop();
    }
}

function dbg(){
}
