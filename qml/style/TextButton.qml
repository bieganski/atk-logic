﻿import QtQuick 2.15
import QtQuick.Controls 2.5
import "../config"

Button {
    property color textColor: Config.textColor
    property color textEnterColor: Config.subheadColor
    property color textDisableColor: Config.textDisabledColor
    property int textFontSize: 12
    property bool textUnderline: false
    property bool isElide: false
    property bool isChecked: false
    property bool isCheckedEnable: false
    property color backgroundColor: "transparent"
    property color backgroundEnterColor: "transparent"
    property color backgroundPressedColor: "transparent"
    property color backgroundDisableColor: "transparent"
    property alias backgroundRectangle: backRect
    property alias textHorizontalAlignment: rootText.horizontalAlignment

    id: root
    focusPolicy: Qt.NoFocus

    Component.onCompleted: onEnabledChanged()

    contentItem: Text {
        id: rootText
        text: root.text
        color: enabled?textColor:Config.textDisabledColor
        font{
            pixelSize: textFontSize
            underline: textUnderline
        }
        elide: isElide?Text.ElideRight:Text.ElideNone
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: backRect
        color: root.down ? checkable ? backgroundColor : backgroundPressedColor : backgroundColor
        radius: 4
        Behavior on color{
            ColorAnimation {
                duration: 100
            }
        }
    }

    onEnabledChanged: {
        if(!enabled){
            //if(backRect.color!=backgroundColor)
            backRect.color = backgroundDisableColor
            rootText.color = textDisableColor
        }else
            mouseEnter(false)
    }

    onIsCheckedChanged: {
        if(enabled && checkable && isCheckedEnable){
            backRect.color = isChecked ? backgroundPressedColor : backgroundColor
            rootText.color = isChecked ? textEnterColor : textColor
        }
    }

    onCheckedChanged: {
        if(enabled && checkable && !isCheckedEnable){
            backRect.color = checked ? backgroundPressedColor : backgroundColor
            rootText.color = checked ? textEnterColor : textColor
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: parent.enabled
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
        onEntered: mouseEnter(true)
        onExited:  mouseEnter(false)
    }

    onTextColorChanged: mouseEnter(mouseArea.containsMouse);

    onTextEnterColorChanged: mouseEnter(mouseArea.containsMouse);

    onTextDisableColorChanged: onEnabledChanged();

    onBackgroundColorChanged: mouseEnter(mouseArea.containsMouse);

    onBackgroundEnterColorChanged: mouseEnter(mouseArea.containsMouse);

    onBackgroundPressedColorChanged: mouseEnter(mouseArea.containsMouse);

    onBackgroundDisableColorChanged: onEnabledChanged();

    function mouseEnter(flag){ //处理鼠标进入或者移出变色
        if(enabled){
            if(!checkable)
            {
                rootText.color = flag ? textEnterColor : textColor
                backRect.color = flag ? backgroundEnterColor : backgroundColor
            }else{
                if(isCheckedEnable)
                    isCheckedChanged();
                else
                    checkedChanged();
            }
        }
    }
}
