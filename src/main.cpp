#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "version.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setApplicationName(QString::fromLocal8Bit(APPLICATION_NAME));
    app.setApplicationVersion(QString::fromLocal8Bit(APPLICATION_VERSION_STRING_FULL));
    app.setOrganizationName(QString::fromLocal8Bit(APPLICATION_COMPANY_NAME));
    app.setOrganizationDomain(QString::fromLocal8Bit(APPLICATION_COMPANY_DOMAIN));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
