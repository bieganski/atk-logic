﻿import QtQuick 2.11
import QtQuick.Window 2.15
import "../config"
import "../style"

Window {
    signal dataSend(var dataJson)
    property var screen
    property var dataJson
    property var openChannels
    id: window
    visible: true
    modality: Qt.WindowModal
    flags: Qt.FramelessWindowHint
    color: "#00000000"
    width: dropShadow.width
    height: dropShadow.height

    Connections{
        target: Signal
        function onEscKeyPress()
        {
            window.close();
        }
    }

    Component.onCompleted: Config.isSetModel=true;

    //    //@----disable-check M16
    //    onClosing: function(closeevent){
    //        dataSend("123456");
    //    }

    Image {
        id: dropShadow
        width: 442
        height: 473
        source: "../../resource/image/GlitchRemovalSetWindowDropShadow.png"
    }

    Rectangle{
        width: 426
        height: 458
        color: Config.backgroundColor
        radius: 10
        anchors.centerIn: parent

        Item{
            id: titleItem
            property string periodText: qsTr("采样周期")
            width: parent.width
            height: 38
            Text {
                id: titleText
                text: qsTr("毛刺过滤设置")
                font.pixelSize: 18
                anchors{
                    left: parent.left
                    leftMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                color: Config.textColor
            }

            ImageButton{
                property bool isSelect: false
                z: 100
                width: 16
                height: 16
                imageSource: "resource/icon/GlitchRemovalSelectAll"+(isSelect?"Enter":"")+".png"
                imageEnterSource: imageSource
                imagePressedSource: imageSource
                anchors{
                    left: titleText.right
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                onPressed: {
                    isSelect=!isSelect
                    let i;
                    if(isSelect){
                        for(i in selectColumnLeft.children){
                            if(selectColumnLeft.children[i].children[0])
                                selectColumnLeft.children[i].children[0].isCheck=(openChannels.indexOf(selectColumnLeft.children[i].children[0].chIndex)!==-1);
                        }
                        for(i in selectColumnRight.children){
                            if(selectColumnRight.children[i].children[0])
                                selectColumnRight.children[i].children[0].isCheck=(openChannels.indexOf(selectColumnRight.children[i].children[0].chIndex)!==-1);
                        }
                    }else{
                        for(i in selectColumnLeft.children){
                            if(selectColumnLeft.children[i].children[0])
                                selectColumnLeft.children[i].children[0].isCheck=false;
                        }
                        for(i in selectColumnRight.children){
                            if(selectColumnRight.children[i].children[0])
                                selectColumnRight.children[i].children[0].isCheck=false;
                        }
                    }
                }
                QToolTip{
                    parent: parent
                    isShow: parent.containsMouse
                    direction: 3
                    showText: parent.isSelect?qsTr("取消全选"):qsTr("全选已启用通道")
                }
            }

            ImageButton{
                z: 100
                width: 10
                height: 10
                imageSource: "resource/icon/MessageClose.png"
                imageEnterSource: "resource/icon/MessageClose.png"
                anchors{
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                onPressed: window.close()
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton //只处理鼠标左键
                property point clickPos: "0,0"
                onPressed: clickPos=Qt.point(mouse.x,mouse.y)
                onPositionChanged: {
                    var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                    if(window.x+delta.x<Screen.virtualX)
                        window.setX(Screen.virtualX);
                    else if(window.x+window.width+delta.x>Screen.virtualX+screen.width)
                        window.setX(Screen.virtualX+screen.width-window.width);
                    else
                        window.setX(window.x+delta.x)

                    if(window.y+delta.y<Screen.virtualY)
                        window.setY(Screen.virtualY);
                    else if(window.y+window.height+delta.y>Screen.virtualY+screen.height)
                        window.setY(Screen.virtualY+screen.height-window.height);
                    else
                        window.setY(window.y+delta.y)
                }
            }
        }

        Rectangle{
            id: titleSplit
            height: 1
            width: parent.width
            anchors.top: titleItem.bottom
            color: Config.lineColor
        }

        Row{
            id: contentColumn
            width: parent.width-40
            spacing: 30
            anchors{
                top: titleSplit.bottom
                topMargin: 10
                bottom: contentSplit.top
                bottomMargin: 10
                left: parent.left
                leftMargin: 20
            }
            Column{
                id: selectColumnLeft
                spacing: 10
                Repeater{
                    model: 8
                    Row{
                        spacing: 5
                        QCheckBox{
                            property int chIndex: index
                            id: checkLeftBox
                            width: 52
                            buttonText: "Ch"+index
                            fontPixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            textVerticalCenterOffset: -2
                            isCheck: dataJson[index]["enable"]
                            onIsCheckChanged: dataJson[index]["enable"]=isCheck;
                        }
                        Text {
                            text: "≤"
                            color: checkLeftBox.isCheck?Config.textColor:Config.textDisabledColor
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                        }
                        QSpinBox{
                            width: 45
                            height: 30
                            from: 1
                            to: 999
                            disable: !checkLeftBox.isCheck
                            value: dataJson[index]["num"]
                            onValueChanged: dataJson[index]["num"]=parseInt(value);
                        }
                        Text {
                            text: titleItem.periodText
                            color: checkLeftBox.isCheck?Config.textColor:Config.textDisabledColor
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                        }
                    }
                }
            }
            Column{
                id: selectColumnRight
                spacing: 10
                Repeater{
                    model: 8
                    Row{
                        spacing: 5
                        QCheckBox{
                            property int chIndex: index+8
                            id: checkRightBox
                            width: 52
                            buttonText: "Ch"+(index+8)
                            fontPixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            textVerticalCenterOffset: -2
                            isCheck: dataJson[index+8]["enable"]
                            onIsCheckChanged: dataJson[index+8]["enable"]=isCheck;
                        }
                        Text {
                            text: "≤"
                            color: checkRightBox.isCheck?Config.textColor:Config.textDisabledColor
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                        }
                        QSpinBox{
                            width: 45
                            height: 30
                            from: 1
                            to: 999
                            disable: !checkRightBox.isCheck
                            value: dataJson[index+8]["num"]
                            onValueChanged: dataJson[index+8]["num"]=parseInt(value);
                        }
                        Text {
                            text: titleItem.periodText
                            color: checkRightBox.isCheck?Config.textColor:Config.textDisabledColor
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }

        Row{
            spacing: 0
            anchors{
                left: contentColumn.left
                bottom: contentSplit.top
                bottomMargin: 15
            }
            Text {
                text: "*"
                color: Config.textColor
                font.pixelSize: 13
                anchors{
                    top: parent.top
                    topMargin: -2
                }
            }
            Text {
                text: qsTr("勾选某一通道后，小于设定宽度的脉冲将被滤除")
                color: Config.textColor
                font.pixelSize: 13
            }
        }

        Rectangle{
            id: contentSplit
            height: 1
            width: parent.width
            anchors{
                bottom: buttonItem.top
                bottomMargin: 5
            }
            color: Config.lineColor
        }

        Item{
            id: buttonItem
            width: parent.width
            height: 40
            anchors{
                bottom: parent.bottom
                bottomMargin: 5
            }
            Row{
                spacing: 10
                anchors{
                    right: parent.right
                    rightMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                TextButton{
                    text: qsTr("取消")
                    width: 46
                    height: 30
                    onClicked: window.close();
                }

                TextButton{
                    text: qsTr("确定")
                    width: 46
                    height: 30
                    backgroundColor: Config.mouseCheckColor
                    backgroundEnterColor: backgroundColor
                    backgroundPressedColor: backgroundColor
                    textColor: "white"
                    textEnterColor: textColor
                    onPressed: {
                        sendDecodeData();
                        window.close();
                    }
                }
            }
        }
    }

    function sendDecodeData(){
        dataSend(dataJson)
    }
}
