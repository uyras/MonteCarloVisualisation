#include "simulationengine.h"

simulationEngine::simulationEngine(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(run(unsigned long)), &worker, SLOT(mc(unsigned long)));
    connect(&worker, SIGNAL(allDone()), this, SLOT(finishStep()));
    connect(&worker, SIGNAL(stepDone(unsigned)), this, SIGNAL(stepDone(unsigned)));


    worker.moveToThread(&workerThread);
}

simulationEngine::~simulationEngine()
{
    workerThread.quit();
    workerThread.wait();
}

void simulationEngine::init(unsigned nx, unsigned ny, unsigned initialState, unsigned seed)
{
    cleanHistory();
    setXY(nx,ny);
    m_step = 0;
    stepsChanged();
    worker.generator.seed(seed);
    worker.nx = nx;
    worker.ny = ny;
    worker.N = nx*ny;
    worker.drop();
    switch (initialState) {
        case 0: worker.dropRandom(); break;
        case 1: worker.dropAllUp(); break;
        case 2: worker.dropChessboard(); break;
        case 3: worker.dropLineUpDown(); break;
    }
}

void simulationEngine::setup(
        double H,
        double hx,
        double hy,
        double hz,
        double T,
        double a,
        double ax,
        double ay,
        double az,
        double r)
{
    worker.Hc = H;
    worker.Hcd.x = hx;
    worker.Hcd.y = hy;
    worker.Hcd.z = hz;
    worker.Ha = a;
    worker.Had.x = ax;
    worker.Had.y = ay;
    worker.Had.z = az;
    worker.T = T;
    worker.r = r;
    worker.eCalc();
    workerThread.start();
}

const QString simulationEngine::getPoses() const
{
    if (worker.m_poses.length() < m_step+1)
        return "";

    QString str = "[";
    bool first = true;
    for (auto pos : worker.m_poses[m_step]){
        if (first)
            first = false;
        else str.append(',');
        str.append(QString::number(pos));
    }
    str.append(']');

    return str;
}

const QString simulationEngine::getMags() const
{
    if (worker.m_mags.length() < m_step+1)
        return "";

    QString str = "[";
    bool first = true;
    for (auto mag : worker.m_mags[m_step]){
        if (first)
            first = false;
        else str.append(',');
        str.append(QString::number(mag));
    }
    str.append(']');

    return str;
}

void simulationEngine::cleanHistory()
{
    worker.m_poses.clear();
    worker.m_mags.clear();
}

void simulationEngine::forceStop()
{
    workerThread.requestInterruption();
}

void simulationEngine::finishStep()
{
    workerThread.exit();
    fixStep();
    allDone();
}

void simulationEngine::fixStep()
{
    m_totalsteps = worker.m_poses.length();
    totalStepsChanged();
}
