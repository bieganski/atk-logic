﻿#ifndef THREAD_DOWNLOAD_H
#define THREAD_DOWNLOAD_H

#include <QObject>
#include <QCoreApplication>
#include <QThread>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QUrl>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QEventLoop>
#include <pv/usb/usb_server.h>
#include <pv/static/log_help.h>
#include <pv/static/data_service.h>

extern int g_updataState;//0=正常，1=更新完成
extern int g_isUpdata;//0=无升级，1=升级中，2=升级完成

enum Status
{
    requestHead=0,
    requestBody,
    requestComplete
};

class ThreadDownload : public QObject
{
    Q_OBJECT
public:
    explicit ThreadDownload(USBServer* usbServer, USBControl* usb, QString path, QObject *parent = nullptr);
    ~ThreadDownload();
    void startDownload(qint32 index);
    void startUpdate();
    void startUpdate(QString fpgaURL, QString mcuURL);
    void startDownloadFirmware();
    void stopDownLoad();

private:
    bool updateData(bool isMCU, qint32 scheduleStart);

signals:
    void SendDownloadSchedule(qint32 schedule, qint32 type, qint32 index);

public slots:
    void onEnterBootloader(qint32 port, bool errorModel);

private slots:
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onFinishedRequest();
    void onReadyRead();
    void onError(QNetworkReply::NetworkError error);

public:
    USBControl* m_usb;

private:
    QThread m_thread;
    QNetworkAccessManager *m_netWorkManager;
    QNetworkReply *m_reply;
    USBServer* m_usbServer;
    qint32 m_port;
    qint32 m_index;

    QString m_mcuURL;
    QString m_fpgaURL;
    bool m_urlLock=false;
    QString m_fileName;
    QString m_url;
    Status m_state;
    bool m_isErrorModel=false;

    QString m_path;
    bool m_isDownloading=false;
    QFile m_file;
};

#endif // THREAD_DOWNLOAD_H
