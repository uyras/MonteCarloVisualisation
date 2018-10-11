#ifndef SIMULATIONENGINE_H
#define SIMULATIONENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVector>
#include <QThread>
#include <QGuiApplication>

#include "montecarlocore.h"


class simulationEngine : public QObject
{
    Q_OBJECT

public:
    explicit simulationEngine(QObject *parent = nullptr);
    ~simulationEngine();

    Q_INVOKABLE void init(unsigned nx, unsigned ny, unsigned initialState, unsigned seed);

    Q_INVOKABLE void setup(double H, double hx, double hy, double hz, double T, double a, double ax, double ay, double az, double r = 0.1);

    Q_PROPERTY(unsigned short step MEMBER m_step NOTIFY stepsChanged)
    Q_PROPERTY(ushort totalSteps MEMBER m_totalsteps NOTIFY totalStepsChanged)

    Q_INVOKABLE const QString getPoses() const;
    Q_INVOKABLE const QString getMags() const;

    Q_INVOKABLE void cleanHistory();
    Q_INVOKABLE void finishRrender(){renderComplete();}
    Q_INVOKABLE void forceStop();

signals:
    void run(unsigned long);
    void stepDone(unsigned);
    void draw();
    void stepsChanged();
    void totalStepsChanged();
    void setXY(unsigned x, unsigned y);
    void allDone();
    void renderComplete();

public slots:
    void finishStep();

private:
    QThread workerThread;
    monteCarloCore worker;

    ushort m_step, m_totalsteps;

    void fixStep();
};

#endif // SIMULATIONENGINE_H
