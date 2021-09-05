#!/bin/bash

TOOLKIT_DIR=/toolkit
HOST_DIR=${TOOLKIT_DIR}_host
BASE_DIR=${TOOLKIT_DIR}_base

cd $TOOLKIT_DIR

# parse arguments for version and platform option
version=
platform=
function parse() {
  local opt optarg
  shift
  while getopts :v:p: opt
  do
    optarg="$OPTARG"
    if [[ "$opt" = - ]]; then
      opt="-${OPTARG%%=*}"
      optarg="${OPTARG/${OPTARG%%=*}/}"
      optarg="${optarg#=}"
      if [[ -z "$optarg" ]] && [[ ! "${!OPTIND}" = -* ]]; then
        optarg="${!OPTIND}" ; hift
      fi
    fi
    case "-$opt" in
      -v|--version)  version="$optarg" ;;
      -p|--platform) platform="$optarg" ;;
    esac
  done
  shift $((OPTIND - 1))
#echo $0 $1
}
parse $*

CMD=$1
shift

TARGET_ENV=ds.${platform}-${version}
BUILD_ENV_DIR=$TOOLKIT_DIR/build_env/$TARGET_ENV
SOURCE_DIR=$TOOLKIT_DIR/source
RESULT_SPK_DIR=$TOOLKIT_DIR/result_spk
HOST_SOURCE_DIR=${TOOLKIT_DIR}_host/source
HOST_RESULT_SPK_DIR=${TOOLKIT_DIR}_host/result_spk

PKGDIR=$BASE_DIR/pkgscripts-DSM${version%%.*}
if [ ! -d "$PKGDIR" ]; then
  PKGDIR=$BASE_DIR/pkgscripts-DSM6
fi

PKGSCRIPT_DIR=pkgscripts
if [ "7" == "${version%%.*}" ]; then
  PKGSCRIPT_DIR=pkgscripts-ng
  CMD=${CMD/pkgscripts\//pkgscripts-ng\/}
fi

ln -sf $BASE_DIR/result_spk       $RESULT_SPK_DIR
ln -sf $BASE_DIR/toolkit_tarballs $TOOLKIT_DIR/toolkit_tarballs

rm -rf $PKGSCRIPT_DIR
cp -prf $PKGDIR $PKGSCRIPT_DIR

rm -rf $SOURCE_DIR
cp -r $HOST_SOURCE_DIR $SOURCE_DIR

# deploy build_env from tar files
#if [ "EnvDeploy" != "$(basename $CMD)" -a "bash" != "$(basename $CMD)" ]; then
#  set -x
#
#  if [ ! -d "$BUILD_ENV_DIR" ]; then
#    args=
#    if [ "" != "$platform" ]; then args="$args -p $platform" ; fi
#    if [ "" != "$version"  ]; then args="$args -v $version"  ; fi
#    $(dirname $CMD)/EnvDeploy $args -t $TOOLKIT_DIR/toolkit_tarballs
#    
#    # build gpg key from key.conf
#    if [ -d "${SOURCE_DIR}_origin/.gnupg" ]; then
#      cp -r ${SOURCE_DIR}_origin/.gnupg $BUILD_ENV_DIR/root/.gnupg
#      chmod -R 600 $BUILD_ENV_DIR/root/.gnupg
#    else
#      echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
#      gpg2 --gen-key --batch ${SOURCE_DIR}_origin/key.conf
#      cp -r ~/.gnupg $BUILD_ENV_DIR/root/.gnupg
#      cp -r ~/.gnupg ${SOURCE_DIR}_origin/.gnupg --no-preserve=mode
#    fi
#  fi
#
#  cp -r ${SOURCE_DIR}_origin/* $SOURCE_DIR
#fi

# execute command
$CMD $*

# copy log and build destination
if [ $? -eq 0 -a "EnvDeploy" != "$(basename $CMD)" -a "bash" != "$(basename $CMD)" ]; then

  mkdir -p $HOST_RESULT_SPK_DIR/$TARGET_ENV
  cp -pr $BUILD_ENV_DIR/logs.build ${RESULT_SPK_DIR}/* *.log \
         $HOST_RESULT_SPK_DIR/$TARGET_ENV

  #ls -l $TOOLKIT_DIR $TOOLKIT_DIR/build_env
fi
