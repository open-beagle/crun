# crun

为 ansible-podman 项目准备可跨平台的 crun 二进制文件。

## build

[crun](https://github.com/containers/crun)

```bash
# amd64
docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/crun \
-v $PWD/.tmp/nix:/nix \
-w /go/src/github.com/open-beagle/crun \
-e BUILD_ARCH=amd64 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh src/debug.sh

# arm64
docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/crun \
-v $PWD/.tmp/nix:/nix \
-w /go/src/github.com/open-beagle/crun \
-e BUILD_ARCH=arm64 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh src/debug.sh
```

## nix

```bash
docker pull nixos/nix:2.3.16 && \
docker tag nixos/nix:2.3.16 registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16

docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/crun \
-w /go/src/github.com/open-beagle/crun \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh -c '
  mkdir -p $PWD/.tmp/nix && \
  cp -rfT /nix $PWD/.tmp/nix
'
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="crun" \
  -e PLUGIN_MOUNT="./.git,./.tmp/nix,./.tmp/crun-v1.14.4" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="crun" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
