#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine>
#include "simulationengine.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    simulationEngine simulator;

    QApplication app(argc, argv);
    app.setOrganizationName("Far Eastern Federal Univercity");
    app.setOrganizationDomain("cc.dvfu.ru");
    app.setApplicationName("FePt magnetisation dynamics visualisation");

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("simulator",&simulator);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
