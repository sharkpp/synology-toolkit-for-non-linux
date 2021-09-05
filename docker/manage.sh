#!/bin/bash

if [ "" == "$1" ]; then
  echo "usage: $0 SCRIPT_NAME [...PARAMS]"
  exit
fi

IMAGE_NAME=synorogy-toolkit
VOLUME_NAME=${IMAGE_NAME}-volume

function print_usage() {
  echo "usage: ./manage.sh CMD PARAMS"
  echo "  CMD:"
  echo "    ./manage.sh build "
  echo "    ./manage.sh run COMMAND PARAMS"
}

function exec_build() {
  docker build -t $IMAGE_NAME .
  docker volume create --name $VOLUME_NAME
}

function exec_rebuild() {
  docker volume rm $VOLUME_NAME
  exec_build
}

function exec_run() {
  shift
  mkdir -p ${CUR_DIR}/result_spk
  docker run \
    --rm \
    -v $VOLUME_NAME:/toolkit \
    -v ${CUR_DIR}:/toolkit_host \
    --privileged \
    --cap-drop=ALL \
    -it $IMAGE_NAME \
    bootstrap.sh $*
}

CUR_DIR=$(pwd)
pushd $(dirname $0) >/dev/null

if type exec_$1 >/dev/null 2>&1 ; then
  exec_$1 $*
else
  echo "Error undefined CMD '$1'"
  print_usage
fi
