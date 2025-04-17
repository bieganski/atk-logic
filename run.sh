#!/bin/bash

set -eu

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

###############################
# application-specific
IMAGE_NAME=atk-logic
FILEPATH=/atk-logic/ATK-Logic
###############################
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


xhost +local:docker

docker run \
  --env DISPLAY=$DISPLAY \
  --env LANG=en_US.UTF-8 \
  -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v /sys:/sys \
  --privileged \
  --rm \
  -it \
  --entrypoint $FILEPATH $IMAGE_NAME