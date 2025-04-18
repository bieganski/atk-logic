﻿#ifndef SESSIONCONTROLLER_H
#define SESSIONCONTROLLER_H


#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "pv/static/data_service.h"
#include <pv/static/log_help.h>

enum ChannelTriggerButton {Null, RisingEdge, HighLevel, FallingEdge, LowLevel, DoubleEdge};

class SessionController : public QObject
{
    Q_OBJECT
public:
    SessionController(QObject *parent = nullptr);

private:
    bool cisInit();
    void init();

private:
    DataService* m_dataService;
    Session* m_session=nullptr;

signals:
    void sessionDrawUpdate(qint32 isPoll=-1);
    void zoomUnitShow(QString text);
    void sendDeviceRecvSchedule(qint32 schedule, qint32 type, qint32 state_);
    void sendDecodeAnalysis(Segment* segment, qint64 start, qint64 end, qint64 maxSample, bool isContinuous);
    void sendRestartDevice(Segment* segment, qint64 maxUnit, bool isContinuous);
    void measureDataChanged();
    void sendDecodeSchedule(QString decodeID, double schedule);
    void sendVernierTriggerPosition(quint64 position);
    void saveSessionSettings(QString path);
    void loadSessionSettings(QString name, QString path);
    void channelNameModification(qint32 channelID, QString name);
    void appendMeasure(qint32 measureID);
    void appendVernier();
    void appendDecode(QString json);
    void calcMeasureDataComplete(qint32 measureID);
    void sendGlitchString(QString str);
    void sendDecodeReset(QString decodeID);
    void sendZipDirSchedule(qint32 schedule);
    void sendUnZipDirSchedule(qint32 schedule);

public slots:
    //state 0=自动,1=强制显示最大,2=放大,3=缩小,4=显示0点
    void onRefreshZoom(qint32 state);
    void onSessionSelect();
    Q_INVOKABLE void onAppendDecode(QString json, bool end);
    void onDecodeToPosition(qint64 position, qint64 maxSample_);

    //以下QML变量
public:
    Q_INVOKABLE void initFile();
    Q_INVOKABLE void resetBindingPort();
    Q_INVOKABLE void errorInit();
    Q_INVOKABLE void wheelRoll(bool isUp,qint32 x);
    Q_INVOKABLE void showViewScope(qint64 start,qint64 end,bool isZoom);
    Q_INVOKABLE void setWidth(qint32 width);
    Q_INVOKABLE bool start(QJsonObject json,qint32 type);
    Q_INVOKABLE bool getProgressBarShow();
    Q_INVOKABLE void stop();
    Q_INVOKABLE bool pwmStart(qint8 index, qint32 hz, qint32 duty);
    Q_INVOKABLE bool pwmStop(qint8 index);
    Q_INVOKABLE QString newDecode();
    Q_INVOKABLE bool decode(QString decodeID, QJsonObject json);
    Q_INVOKABLE void stopAllDecode();
    Q_INVOKABLE void restartAllDecode();
    Q_INVOKABLE void restartDecode(QString decodeID);
    Q_INVOKABLE void setRecodeJSON(QString decodeID, QJsonObject json);
    Q_INVOKABLE void stopDecode(QString decodeID);
    Q_INVOKABLE bool resetDecode(QString decodeID, QJsonObject json);
    Q_INVOKABLE void removeDecode(QString decodeID);
    Q_INVOKABLE void cleanAllDecode();
    Q_INVOKABLE void setDecodeShowJson(QString decodeID, QJsonObject json);
    Q_INVOKABLE QVariantMap getShowConfig();
    Q_INVOKABLE void setScrollBarPosition(double position);
    Q_INVOKABLE void saveData(QString path, QString sessionName);
    Q_INVOKABLE void saveBinData(QString path, qint32 type, QString channels);
    Q_INVOKABLE bool needSaveData();
    Q_INVOKABLE bool hasData();
    Q_INVOKABLE void channelNameChanged(qint8 channelID, QString name);
    Q_INVOKABLE void threadStop(bool waitClose=false);
    Q_INVOKABLE void setLiveFollowing(bool isEnable);
    Q_INVOKABLE bool setGlitchRemoval(QJsonArray json);
    Q_INVOKABLE QJsonArray getGlitchRemoval();
    Q_INVOKABLE void openFile(QString path);
    Q_INVOKABLE qint64 getChannelMaxSample(qint8 channelID);
    Q_INVOKABLE void deleteSetDirectory(QString path);
    Q_INVOKABLE QString getChannelName(qint8 channelID);
    Q_INVOKABLE void log(QString log);
    Q_INVOKABLE void forceRefresh();
    Q_INVOKABLE void resetDisplayRange();
    Q_INVOKABLE void fpgaActive();
    Q_INVOKABLE void fpgaDormancy();
    Q_INVOKABLE void restartGlitchRemoval();
    Q_INVOKABLE bool isGlitchRemoval();
    Q_INVOKABLE void startDecodeTmp();
    Q_INVOKABLE void setMeasureSelect(qint32 measureID);
    Q_INVOKABLE void saveDecodeTable(QString filePath);
    Q_INVOKABLE void setShowStart(qint64 showStart, qint32 refreshState=-1);
    Q_INVOKABLE void switchVernier(bool isUp,bool isZoom);
    Q_INVOKABLE qint64 getShowStart();
    Q_INVOKABLE qint64 getShowStart(qint64 showStart);
    Q_INVOKABLE qint64 getShowStartMultiply();
    Q_INVOKABLE qint64 getXWheelPosition(bool isUp, qint32 count=1);
    Q_INVOKABLE void reloadDecoder();

    const QString &sessionName() const;
    void setSessionName(const QString &newSessionName);

    qint32 sessionType() const;
    void setSessionType(int newSessionType);

    const QString &sessionID() const;

    qint32 isInit() const;
    void setIsInit(int newIsInit);

    qint32 sessionPort() const;
    void setSessionPort(int newSessionPort);

    qint32 channelCount() const;
    void setChannelCount(qint32 newChannelCount);

    const QString &filePath() const;
    void setFilePath(const QString &newFilePath);

signals:
    void isInitChanged();
    void timerDrawUpdate(qint64 showStart);
    void measureSelectChanged();

private:
    QString m_sessionName="";
    QString m_sessionID="";
    bool m_isBinding=false;
    bool m_progressBarShow=false;
    qint32 m_sessionPort=-10;
    qint32 m_sessionType=-1;
    qint32 m_isInit=0;
    qint32 m_channelCount=0;
    QString m_filePath="";
    QStringList m_decodeTmp;

    Q_PROPERTY(QString sessionName READ sessionName WRITE setSessionName)
    Q_PROPERTY(int sessionType READ sessionType WRITE setSessionType)
    Q_PROPERTY(QString sessionID READ sessionID)
    Q_PROPERTY(int isInit READ isInit WRITE setIsInit NOTIFY isInitChanged)
    Q_PROPERTY(int sessionPort READ sessionPort WRITE setSessionPort)
    Q_PROPERTY(qint32 channelCount READ channelCount WRITE setChannelCount)
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath)
};

#endif // SESSIONCONTROLLER_H
