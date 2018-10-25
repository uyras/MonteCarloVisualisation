#include "simulationengine.h"

simulationEngine::simulationEngine(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(run(unsigned long)), &worker, SLOT(mc(unsigned long)));
    connect(&worker, SIGNAL(mcAllDone()), this, SLOT(finishCalculations()));
    connect(&worker, SIGNAL(mcStepDone(unsigned)), this, SIGNAL(stepDone(unsigned)));


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
    stepValueChanged();
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
    worker.m_energies.clear();
}

void simulationEngine::forceStop()
{
    workerThread.requestInterruption();
}

void simulationEngine::finishCalculations()
{
    workerThread.exit();

    //update value of totalStepps
    m_totalsteps = ushort(worker.m_poses.length());
    totalStepsValueChanged();

    fillPlot();
    allDone();
}

void simulationEngine::fillPlot()
{
    int i,j;
    int start = m_plotData.rowCount(QModelIndex());
    int end = worker.m_poses.length();
    m_plotData.beginAddRow(end-start);
    double totalMag[3];
    for (i = start; i < end; ++i){
        //QVector3D totalMag;
        totalMag[0]=0; totalMag[1]=0; totalMag[2]=0;
        for (j = 0; j < int(worker.N); ++j){
            totalMag[0]+=worker.m_mags[i][j*3+0];
            totalMag[1]+=worker.m_mags[i][j*3+1];
            totalMag[2]+=worker.m_mags[i][j*3+2];
        }
        totalMag[0] /= worker.N;
        totalMag[1] /= worker.N;
        totalMag[2] /= worker.N;
        m_plotData.addRow({
                              double(i),
                              totalMag[0],
                              totalMag[1],
                              totalMag[2],
                              sqrt(totalMag[0]*totalMag[0]+totalMag[1]*totalMag[1]+totalMag[2]*totalMag[2]),
                              worker.m_energies[i],
                              worker.T,
                              worker.Had.x,
                              worker.Had.y,
                              worker.Had.z,
                              worker.Ha,
                              worker.Hcd.x,
                              worker.Hcd.y,
                              worker.Hcd.z,
                              worker.Hc
                          });
    }
    m_plotData.endAddRow();
}
