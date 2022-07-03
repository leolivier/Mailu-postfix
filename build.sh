#!/bin/bash

function usage() {
  echo $0 '[-h] [-p platform(s)] [-n] [-l]'
  echo "-p comma separated list of platforms. default=linux/amd64,linux/arm64,linux/arm/v7"
  echo "-n no cache"
  echo "-u push to docker registry"
  echo "-h prints this help and exits"
  exit 1
}

PLATFORMS=""
NOCACHE=""
PUSH=""

while getopts ":hp:i:nu" flag
do
  case "${flag}" in
    h) usage;;
    p) PLATFORMS='--set *.platform='"${OPTARG}";;
    n) NOCACHE="--no-cache";;
    u) PUSH="--push";;
    *) usage;;
  esac
done

PUSH=""
cd $(dirname $0)
#docker run --privileged --rm tonistiigi/binfmt:latest --install arm64,arm
docker run --privileged --rm linuxkit/binfmt:v0.8
set -x
docker buildx bake --progress plain $NOCACHE $PUSH $PLATFORMS
