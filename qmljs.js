var requiredFrames;

var isTimerStepComplete;
var isRenderComplete;

var startRenderTime=0;
var stopRenderTime=0;
var incVal = 1;

function dateNow(){ return new Date().getTime(); }

function onAnimateTimer(){
    isTimerStepComplete = true;
    /*console.log([
                    "timer "+timeSlider.value+" done",
                    isTimerStepComplete,
                    isRenderComplete
]);*/
    if (isRenderComplete)
        makeNextRenderStep();
}

function onRenderComplete(){
    isRenderComplete = true;
    stopRenderTime = dateNow();
    /*console.log([
                    "render "+timeSlider.value+" done",
                    isTimerStepComplete,
                    isRenderComplete
]);*/
    if (isTimerStepComplete)
        makeNextRenderStep();
}

function makeNextRenderStep(){
    if (window.isAnimationStarted){
        updateTimerInterval();
        timeSlider.value += incVal;
        isTimerStepComplete = false;
        animationTimer.start();

        if (timeSlider.value === timeSlider.to){
            stopAnimation();
        }
    }
}

function startAnimation(){
    isTimerStepComplete = false;
    window.isAnimationStarted = true;
    animationTimer.start();
}

function stopAnimation(){
    window.isAnimationStarted = false;
}

function onSliderChanged(){
    simulator.step = timeSlider.value;
    isRenderComplete = false;
    startRenderTime = dateNow();
    simulator.draw();
}

function updateTimerInterval(){
    var renderDelayNormal = 1000/stepsPerSecond;
    var renderDelay = stopRenderTime - startRenderTime;

    if (renderDelay < renderDelayNormal){ //if faster then needed
        incVal = 1;
        animationTimer.interval = Math.round(renderDelayNormal);
    } else { // if slower then needed
        animationTimer.interval = 20;
        incVal = Math.min(Math.max(Math.floor(renderDelay/renderDelayNormal),1),20);
    }

    if (false){ //for debug output
        var timeDelay = dateNow() - startRenderTime;
        var fps = Math.ceil(1000/(timeDelay));
        console.log([incVal,fps, renderDelay, renderDelayNormal, timeDelay,startRenderTime,stopRenderTime]);
    }
}

function onCalculationStarted(){
    showProgressBar();
    console.log("start simulations");
    simulator.setup(0,0,0,0,0,1,0,0,1,0.1);
    simulator.run(requiredFrames);
}

function onCalculationStep(val){
    //console.log("step "+val);
    pbItem.value = val+1;
}

function onCalculationFinished(){
    console.log("finish simulations");
    pbItem.indeterminate = true;
    timeSlider.onValueChanged();
    hideProgressBar();
}

function onCalculationForceStopped(){
    simulator.forceStop();
}

function showProgressBar(){
    pbPopUp.open();
    pbItem.value = 0;
    pbItem.to = requiredFrames;
    pbItem.indeterminate = false;
}

function hideProgressBar(){
    pbPopUp.close();
}

function onAddFrames(count){
    requiredFrames = count;
    addFramesDlg.close();
    onCalculationStarted();
}

function onNewAnimation(){
    console.log("inited");
    incVal = 1;
    window.nx = newAnimationDlg.nx;
    window.ny = newAnimationDlg.ny;
    simulator.init(newAnimationDlg.nx,newAnimationDlg.ny,newAnimationDlg.initState,newAnimationDlg.randomSeed);
    addFramesDlg.open();
}
