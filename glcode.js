Qt.include("rainbowvis.js")

var camera, scene, renderer;

var plane;
var planeColors;
var arrows = [];
var lines;

var arrowHeadLength = 0.3;
var arrowHeadWidth = 0.25;

var colorOne = new THREE.Color( 0x0000ff );
var colorTwo = new THREE.Color( 0xff0000 );
var colorFrom = -1;
var colorTo = 1;

var rainbow = new Rainbow();

var colorPlaneGeometry;

var lastMousePos = {x:0, y:0};
var cameraRadius = 5;
var center;

function initializeGL(canvas) {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 0.1, 1000);
    camera.position.z = cameraRadius;

    // add color plane to the scene
    var planeMaterial = new THREE.MeshBasicMaterial({    color: 0xffffff,
                                                   shading: THREE.SmoothShading,
                                                   wireframe: false,
                                                   opacity:0.7,
                                                   vertexColors: THREE.VertexColors,
                                                   transparent:true,
                                                   side: THREE.DoubleSide
                                               });

    plane = new THREE.Mesh(undefined, planeMaterial);
    plane.rotateY(Math.PI);
    center = plane.position;
    scene.add(plane);


    // add lines to the scene
    var linesMaterial = new THREE.LineBasicMaterial({    color: 0xffffff,
                                                   shading: THREE.SmoothShading,
                                                   wireframe: false,
                                                   vertexColors: THREE.VertexColors,
                                                   side: THREE.DoubleSide,
                                                    linewidth: 5
                                               });
    lines = new THREE.LineSegments( undefined, linesMaterial);
    scene.add(lines);


    renderer = new THREE.Canvas3DRenderer(
                { canvas: canvas, antialias: false, devicePixelRatio: canvas.devicePixelRatio     });
    renderer.setSize(canvas.width, canvas.height);

    rainbow.setNumberRange(colorFrom, colorTo);
    rainbow.setSpectrum("blue", "white", "red");
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
    scene.remove(arrows.pop());
}

function onSwitchArrows(){
    for (var i = 0; i < arrows.length; ++i ){
        arrows[i].visible = chbArrows.checked && !window.simplifiedArrows;
    }
    lines.visible = chbArrows.checked && window.simplifiedArrows;
    timeSlider.onValueChanged();
}

function updateSurface(){
    //update plane
    plane.geometry.dispose();
    plane.geometry = new THREE.PlaneBufferGeometry(window.nx-1, window.ny-1, window.nx-1, window.ny-1);
    planeColors = new THREE.BufferAttribute( new Float32Array( window.nx * window.ny * 3), 3 );
    planeColors.setDynamic(true);
    plane.geometry.addAttribute( 'color', planeColors);

    //update lines
    lines.geometry.dispose();
    lines.geometry = new THREE.BufferGeometry();
    var linePositions   = new THREE.BufferAttribute( new Float32Array( window.nx * window.ny * 6), 3 );
    var lineColors      = new THREE.BufferAttribute( new Float32Array( window.nx * window.ny * 6), 3 );
    linePositions.setDynamic(true);
    lineColors.setDynamic(true);
    lines.geometry.addAttribute( 'position', linePositions );
    lines.geometry.addAttribute( 'color', lineColors);
}

function updateArrows(data){
    var centerX = (window.nx-1)/2.;
    var centerY = (window.ny-1)/2.;
    if (data.length !== arrows.length){
        updateSurface();
        var steps, n;
        if (data.length>arrows.length){
            steps = data.length - arrows.length;
            for (n=0; n < steps; ++n)
                addArrow();
        } else {
            steps = arrows.length - data.length;
            for (n=0; n < steps; ++n)
                delArrow();
        }
    }
    var dir = new THREE.Vector3(  );
    var pos = new THREE.Vector3(  );
    var len = 0;
    var colorFactor;
    for (var i=0; i< data.length; ++i){

        colorFactor = (data[i][5] - colorFrom) / (colorTo - colorFrom);
        var newColor = new THREE.Color( parseInt( rainbow.colourAt(data[i][5]) ,16) );

        if (chbArrows.checked){
            pos.set(data[i][0] - centerX, data[i][1] - centerY, data[i][2]);
            dir.set(data[i][3], data[i][4], data[i][5]);

            if (window.simplifiedArrows){
                dir.add(pos);
                pos.toArray( lines.geometry.attributes.position.array, i * 6 );
                dir.toArray( lines.geometry.attributes.position.array, i * 6 + 3 );
                newColor.toArray( lines.geometry.attributes.color.array, i * 6 );
                newColor.toArray( lines.geometry.attributes.color.array, i * 6 + 3 );
                lines.geometry.attributes.position.needsUpdate = true;
                lines.geometry.attributes.color.needsUpdate = true;
            } else {
                len = dir.length();
                dir.normalize();

                if (!arrows[i].position.equals(pos))
                    arrows[i].position.copy( pos );
                if (arrows[i].len !== len)
                    arrows[i].setLength( len, len * arrowHeadLength, len * arrowHeadWidth );

                arrows[i].setDirection( dir );
                arrows[i].setColor(newColor);
            }
        }

        newColor.toArray(planeColors.array,((data.length - i - 1)*3));
    }
    planeColors.needsUpdate = true;
    onRender();
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
    onRender();
}

function onAnimate(){
    var incVal = 1;
    if (timeSlider.to > 100)
        incVal = 5
    else if (timeSlider.to > 1000)
        incVal = 10
    else if (timeSlider.to > 5000)
        incVal = 30
    else if (timeSlider.to > 10000)
        incVal = 100;
    timeSlider.value += incVal;
    if (timeSlider.value === timeSlider.to){
        animationTimer.stop();
    }
}

function onRender(){
    canvas3d.requestRender();
}

function dbg(){
}
