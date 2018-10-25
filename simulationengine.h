#ifndef SIMULATIONENGINE_H
#define SIMULATIONENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVector>
#include <QThread>
#include <QGuiApplication>
#include <QVector3D>

#include "montecarlocore.h"
#include "plotprovider.h"


class simulationEngine : public QObject
{
    Q_OBJECT

public:
    explicit simulationEngine(QObject *parent = nullptr);
    ~simulationEngine();

    // init the system, create an array of spins
    Q_INVOKABLE void init(unsigned nx, unsigned ny, unsigned initialState, unsigned seed);

    //setup parameters of simulation for nest MC steps
    Q_INVOKABLE void setup(double H, double hx, double hy, double hz, double T, double a, double ax, double ay, double az, double r = 0.1);

    Q_PROPERTY(unsigned short step MEMBER m_step NOTIFY stepValueChanged)
    Q_PROPERTY(ushort totalSteps MEMBER m_totalsteps NOTIFY totalStepsValueChanged)

    Q_INVOKABLE const QString getPoses() const;
    Q_INVOKABLE const QString getMags() const;

    Q_INVOKABLE void cleanHistory();
    Q_INVOKABLE void finishRrender(){renderComplete();}
    Q_INVOKABLE void forceStop();

    plotProvider m_plotData;

signals:
    // run simulations with required number of frames
    void run(unsigned long);

    // emitted by MC core when every step is done
    void stepDone(unsigned);
    // emitted when step is changed
    void stepValueChanged();
    // emitted when the total number of steps are changed
    void totalStepsValueChanged();

    // emitted when calculations and update of internal arrays are done
    void allDone();


    /******** transition signals, not directly used by this class *******/
    // emit thes when need to update X and Y of the system
    void setXY(unsigned x, unsigned y);
    // emit this when need to redraw current step
    void draw();
    // emit this when you need to set view centered
    void centerView();
    // emitted by visualisator when the render of current frame is complete
    void renderComplete();

public slots:
    void finishCalculations();

private:
    QThread workerThread;
    monteCarloCore worker;

    ushort m_step, m_totalsteps;
    void fillPlot();
};

#endif // SIMULATIONENGINE_H
