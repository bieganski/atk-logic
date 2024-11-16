FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get install -y \
    git \
    make \
    gcc \
    g++

RUN apt-get install -y \
    qtchooser \
    qt5-qmake \
    qtbase5-dev \
    qtdeclarative5-dev \
    qt5-qmake-bin \
    qtbase5-dev-tools \
    qtbase5-private-dev \
    libusb-1.0-0-dev \
    libusb-dev \
    libqt5x11extras5-dev \
    qml-module-qt-labs-platform \
    python3-dev

RUN git clone https://github.com/bieganski/atk-logic

WORKDIR atk-logic

COPY libsigrokdecode.a .

RUN qmake
RUN make -j6
RUN size ATK-Logic

