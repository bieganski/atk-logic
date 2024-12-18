﻿import QtQuick 2.13
import QtQuick.Controls 2.5
import "../config"
import "../style"

Popup{
    property int maxWidth: 200
    property int rowHeight: 30
    property var decodeJson
    property string decodeName
    id: mainPopup
    x: -contentWidth
    width: contentWidth
    height: contentHeight
    contentWidth: maxWidth+30;
    contentHeight: mainRectangle.height+2
    padding: 1
    clip: true;
    onOpened: refreshShow();
    background: Item{}
    Rectangle{
        id: mainRectangle
        width: parent.width
        height: rootListView.height+10
        radius: 4
        clip: true;
        color: Config.backgroundColor
        border{
            width: 1
            color: Config.lineColor
        }

        ListView{
            id: rootListView
            width: parent.width-2
            height: contentHeight
            clip: true
            currentIndex: -1
            flickableDirection: Flickable.AutoFlickDirection
            boundsBehavior: Flickable.StopAtBounds
            model: ListModel{
                id: list_Model
            }
            anchors{
                top: parent.top
                topMargin: 5
                left: parent.left
                leftMargin: 1
            }
            delegate: Column{
                id: showColumn
                width: parent?parent.width:0
                height: row_header.height+row_listview.height
                spacing: 0
                Component.onCompleted: {
                    for(var i in annotation_rows.data)
                        row_model.append(annotation_rows.data[i])
                }
                Item{
                    id: row_header
                    width: parent.width
                    height: rowHeight
                    Text {
                        text: name+":"
                        color: Config.textColor
                        font.pixelSize: 14
                        width: parent.width-clearItem.width-5
                        elide: Text.ElideRight
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 5
                        }
                    }
                    Item{
                        id: clearItem
                        height: parent.height
                        width: 85
                        anchors.right: parent.right
                        TextButton{
                            id: clearRowButton
                            text: "clear"
                            anchors{
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                                rightMargin: 5
                            }
                            width: 40
                            height: 16
                            textFontSize: 11
                            textColor: Config.iceBlue
                            textEnterColor: Config.subheadColor
                            backgroundRectangle{
                                border{
                                    width: 1
                                    color: Config.iceBlue
                                }
                                radius: 8
                            }
                            onPressed: row_header.setAllRowState(false);
                        }
                        TextButton{
                            id: allRowButton
                            text: "all"
                            anchors{
                                verticalCenter: parent.verticalCenter
                                right: clearRowButton.left
                                rightMargin: 8
                            }
                            width: 30
                            height: 16
                            textFontSize: 11
                            textColor: Config.iceBlue
                            textEnterColor: Config.subheadColor
                            backgroundRectangle{
                                border{
                                    width: 1
                                    color: Config.iceBlue
                                }
                                radius: 8
                            }
                            onPressed: row_header.setAllRowState(true);
                        }
                        ImageButton{
                            width: 20
                            height: 20
                            anchors{
                                verticalCenter: parent.verticalCenter
                                right: allRowButton.left
                                margins: 8
                            }
                            visible: index===0
                            imageWidth: 15
                            imageHeight: 15
                            imageSource: decodeJson["main"]["isLockRow"]?"resource/icon/Lock.png":"resource/icon/UnLock.png"
                            imageEnterSource: decodeJson["main"]["isLockRow"]?"resource/icon/LockEnter.png":"resource/icon/UnLockEnter.png"
                            backgroundMouseEnterColor: Config.mouseCheckColor
                            backgroundPressedColor: backgroundMouseEnterColor
                            onPressed: {
                                if(decodeJson["main"]["isLockRow"])
                                    decodeJson["main"]["isLockRow"]=false;
                                else
                                    decodeJson["main"]["isLockRow"]=true;
                                imageSource=decodeJson["main"]["isLockRow"]?"resource/icon/Lock.png":"resource/icon/UnLock.png";
                                imageEnterSource=decodeJson["main"]["isLockRow"]?"resource/icon/LockEnter.png":"resource/icon/UnLockEnter.png";
                                Signal.setDecodeConfig(decodeName, "isLockRow", decodeJson["main"]["isLockRow"]);
                                sSignal.resetDecodeJson(decodeJson, decodeJson["main"]["decodeID"]);
                            }
                        }
                    }
                    function setAllRowState(isShow){
                        for(var i=0;i<row_model.count;i++){
                            var item=row_model.get(i)
                            item.isShow=isShow;
                            decodeJson[name]["annotation_rows"][i]["isShow"]=isShow;
                        }
                        sSignal.resetDecodeJson(decodeJson, decodeJson["main"]["decodeID"]);
                    }
                }
                ListView {
                    id: row_listview
                    model: ListModel{
                        id: row_model
                    }
                    clip: true
                    width: parent.width
                    height: contentHeight
                    snapMode: ListView.NoSnap
                    flickableDirection: Flickable.AutoFlickDirection
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollIndicator.vertical: ScrollIndicator { }
                    delegate: Rectangle{
                        width: row_listview.width
                        height: rowHeight
                        color: rowItemMouseArea.containsMouse?Config.mouseCheckColor:"transparent"
                        MouseArea{
                            id: rowItemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onPressed: {
                                isShow=!isShow;
                                decodeJson[name]["annotation_rows"][index]["isShow"]=isShow;
                                sSignal.resetDecodeJson(decodeJson, decodeJson["main"]["decodeID"]);
                            }
                        }
                        Item{
                            id: rowCheckedItem
                            width: 24
                            height: parent.height
                            Image {
                                visible: isShow
                                width: 10
                                height: 8
                                fillMode: Image.PreserveAspectFit
                                source: "../../resource/icon/"+(rowItemMouseArea.containsMouse?"CheckedWhite.png":"Checked.png")
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        Text{
                            id: rowShowTextElement
                            text: desc
                            font.pixelSize: 12
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: rowCheckedItem.right
                            }
                            color: rowItemMouseArea.containsMouse?"white":Config.textColor
                            Component.onCompleted: {
                                var temp=rowShowTextElement.contentWidth;
                                if(temp>maxWidth&&temp<=300)
                                    maxWidth=temp;
                            }
                        }
                    }
                }
            }
        }
    }
    function refreshShow(){
        list_Model.clear();
        insertDecode(decodeJson["main"]["first"]);
        for(var i in decodeJson["main"]["second"])
            insertDecode(decodeJson["main"]["second"][i]);
    }

    function insertDecode(decodeName){
        list_Model.append({"name":decodeName,"annotation_rows":{"data":decodeJson[decodeName]["annotation_rows"]}})
    }
}
