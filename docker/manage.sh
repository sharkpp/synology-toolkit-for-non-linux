#!/bin/bash

if [ "" == "$1" ]; then
  echo "usage: $0 SCRIPT_NAME [...PARAMS]"
  exit
fi

IMAGE_NAME=synorogy-toolkit

function print_usage() {
  echo "usage: ./manage.sh CMD PARAMS"
  echo "  CMD:"
  echo "    ./manage.sh build "
  echo "    ./manage.sh run COMMAND PARAMS"
}

function exec_build() {
  docker build -t $IMAGE_NAME .
}

function exec_run() {
  shift
  mkdir -p ${CUR_DIR}/toolkit_tarballs
  mkdir -p ${CUR_DIR}/result_spk
  docker run \
    --rm \
    -v ${CUR_DIR}/source:/toolkit/source_origin \
    -v ${CUR_DIR}/toolkit_tarballs:/toolkit/toolkit_tarballs \
    -v ${CUR_DIR}/result_spk:/toolkit/result_spk_origin \
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
