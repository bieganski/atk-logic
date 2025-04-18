QT += core gui quick network gui-private widgets

CONFIG += c++11
CONFIG += precompile_header
CONFIG += thread exceptions rtti stl
CONFIG += debug_and_release

TARGET = ATK-Logic

PRECOMPILED_HEADER = $$PWD/stdafx.h

VERSION = 1.0.6.6
DEFINES += APP_VERSION_NUM=1066
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += FPGA_MIN_VERSION_NUM=115


# unix:LIBS += -lX11.so.6 -lusb-1.0 -lQt5X11Extras -L/home/mateusz/github/atk_libsigrokdecode/.libs/ -l:libsigrokdecode.a -l:libglib-2.0.so.0 -l:libpython3.12.so


unix:LIBS += -lX11 -lusb-1.0 -lQt5X11Extras -L. -l:libsigrokdecode.a -lglib-2.0 -lpython3.12
# QMAKE_LFLAGS += -l:libX11.so.6 -lusb-1.0 -Wl,-O1 -lQt5X11Extras -L/home/mateusz/github/atk_libsigrokdecode/.libs/ -l:libsigrokdecode.a -l:libglib-2.0.so.0 -l:libpython3.12.so
QMAKE_LFLAGS += -Wl,-O1


QMAKE_TARGET_COMPANY ="ALIENTEK"
QMAKE_TARGET_DESCRIPTION = "ATK-LogicView"
QMAKE_TARGET_COPYRIGHT = "Copyright (C) 2022. ALIENTEK All Rights Reserved."
QMAKE_TARGET_PRODUCT = "ATK-LogicView"
RC_ICONS = app.ico
RC_LANG = 0x0004

Debug: DST_DIR_DLL = $$OUT_PWD\\debug
Release: DST_DIR_DLL = $$OUT_PWD\\Release
DST_DIR_DLL = $$replace(DST_DIR_DLL, /, \\)

SRC_DIR_DLL = $$PWD\\runtime
SRC_DIR_DLL = $$replace(SRC_DIR_DLL, /, \\)

SOURCES += \
        main.cpp \
        pv/controller/session_error.cpp \
        pv/controller/setting.cpp \
        pv/data/analysis.cpp \
        pv/data/decode_controller.cpp \
        pv/draw/double_buffering.cpp \
        pv/draw/draw_background.cpp \
        pv/draw/draw_background_floor.cpp \
        pv/model/decode_list_model.cpp \
        pv/model/decode_table_model.cpp \
        pv/model/measure_tree_view_model.cpp \
        pv/model/search_table_model.cpp \
        pv/model/test_file_table_model.cpp \
        pv/model/vernier_list_model.cpp \
        pv/static/clipboard.cpp \
        pv/static/decode_service.cpp \
        pv/static/fpsitem.cpp \
        pv/static/log_help.cpp \
        pv/static/menustyle.cpp \
        pv/static/shared_memory_helper.cpp \
        pv/static/shortcut_listener.cpp \
        pv/static/util.cpp \
        pv/static/data_service.cpp \
        pv/controller/session_controller.cpp \
        pv/data/session.cpp \
        pv/data/session_config.cpp \
        pv/data/session_show_config.cpp \
        pv/data/segment.cpp \
        pv/draw/frameless_window.cpp \
        pv/draw/draw_channel.cpp \
        pv/draw/draw_channel_header.cpp \
        pv/static/window_error.cpp \
        pv/static/zip_helper.cpp \
        pv/thread/connect.cpp \
        pv/thread/sharedthread.cpp \
        pv/thread/thread_download.cpp \
        pv/thread/thread_read.cpp \
        pv/thread/thread_work.cpp \
        pv/usb/usb_base.cpp \
        pv/usb/usb_control.cpp \
        pv/usb/usb_hotplug.cpp \
        pv/usb/usb_server.cpp \
        pv/utils/qtlockedfile/qtlockedfile.cpp \
        pv/utils/qtlockedfile/qtlockedfile_unix.cpp

HEADERS += \
        lib/include/atk_decoder.h \
        pv/controller/session_error.h \
        pv/controller/setting.h \
        pv/data/analysis.h \
        pv/data/decode_controller.h \
        pv/draw/double_buffering.h \
        pv/draw/draw_background.h \
        pv/draw/draw_background_floor.h \
        pv/model/decode_list_model.h \
        pv/model/decode_table_model.h \
        pv/model/measure_tree_view_model.h \
        pv/model/search_table_model.h \
        pv/model/test_file_table_model.h \
        pv/model/vernier_list_model.h \
        pv/static/clipboard.h \
        pv/static/decode_service.h \
        pv/static/fpsitem.h \
        pv/static/log_help.h \
        pv/static/menustyle.h \
        pv/static/shared_memory_helper.h \
        pv/static/shortcut_listener.h \
        pv/static/util.h \
        pv/static/data_service.h \
        pv/controller/session_controller.h \
        pv/data/session.h \
        pv/data/session_config.h \
        pv/data/session_show_config.h \
        pv/data/segment.h \
        pv/draw/frameless_window.h \
        pv/draw/draw_channel.h \
        pv/draw/draw_channel_header.h \
        pv/static/window_error.h \
        pv/static/zip_helper.h \
        pv/thread/connect.h \
        pv/thread/sharedthread.h \
        pv/thread/thread_download.h \
        pv/thread/thread_read.h \
        pv/thread/thread_work.h \
        pv/usb/usb_base.h \
        pv/usb/usb_control.h \
        pv/usb/usb_hotplug.h \
        pv/usb/usb_server.h \
        pv/utils/qtlockedfile/qtlockedfile.h

win32 {
        QMAKE_CXXFLAGS += /utf-8
        QMAKE_POST_LINK += xcopy /s /y \"$$SRC_DIR_DLL\" \"$$DST_DIR_DLL\"
    }

RESOURCES += qml.qrc \
    resource.qrc

TRANSLATIONS += \
    translations/zh_CN.ts \
    translations/en_US.ts


CONFIG += resources_big
# CONFIG += lrelease
CONFIG += embed_translations
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
