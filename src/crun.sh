#!/bin/bash
set -ex

name=crun
version=1.15

if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy 'socks5://www.ali.wodcloud.com:1283'
  git clone -b ${version} https://github.com/containers/crun ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}

nix build --file nix/default-${BUILD_ARCH}.nix

cp -r result/bin ${BUILD_ROOT}/.dist/${BUILD_ARCH}
