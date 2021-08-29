#!/bin/bash

BASE_DIR=/toolkit

cd $BASE_DIR

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

PKGDIR=pkgscripts-DSM${version%%.*}
TARGET_ENV=ds.${platform}-${version}
BUILD_ENV_DIR=$BASE_DIR/build_env/$TARGET_ENV
SOURCE_DIR=$BASE_DIR/source
RESULT_SPK_DIR=$BASE_DIR/result_spk
if [ ! -d "$PKGDIR" ]; then
  PKGDIR=pkgscripts-DSM6
fi

PKGSCRIPT_DIR=pkgscripts
if [ "7" == "${version%%.*}" ]; then
  PKGSCRIPT_DIR=pkgscripts-ng
  CMD=${CMD/pkgscripts\//pkgscripts-ng\/}
fi

rm -rf $PKGSCRIPT_DIR
cp -prf $PKGDIR $PKGSCRIPT_DIR

# deploy build_env from tar files
if [ "EnvDeploy" != "$(basename $CMD)" ]; then
  args=
  if [ "" != "$platform" ]; then args="$args -p $platform" ; fi
  if [ "" != "$version"  ]; then args="$args -v $version"  ; fi
  $(dirname $CMD)/EnvDeploy $args -t $BASE_DIR/toolkit_tarballs

  cp -pr ${SOURCE_DIR}_origin $SOURCE_DIR

  # build gpg key from key.conf
  if [ -d "${SOURCE_DIR}_origin/.gnupg" ]; then
    cp -pr ${SOURCE_DIR}_origin/.gnupg $BUILD_ENV_DIR/root/.gnupg
  else
    echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
    gpg2 --gen-key --batch ${SOURCE_DIR}_origin/key.conf
    cp -pr ~/.gnupg $BUILD_ENV_DIR/root/.gnupg
    cp -pr ~/.gnupg ${SOURCE_DIR}_origin/.gnupg
  fi
fi

# execute command
$CMD $*

# copy log and build destination
if [ "EnvDeploy" != "$(basename $CMD)" ]; then

  mkdir -p ${RESULT_SPK_DIR}_origin/${TARGET_ENV}
  cp -pr $BUILD_ENV_DIR/logs.build ${RESULT_SPK_DIR}/* *.log \
         ${RESULT_SPK_DIR}_origin/${TARGET_ENV}

  #ls -l $BASE_DIR $BASE_DIR/build_env
fi
