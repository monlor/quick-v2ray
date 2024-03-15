## 介绍

使用docker一键搭建v2ray，使用ws+http

## 使用

* vps开通80/tcp端口
* 将你的域名解析到vps服务器
* 修改下面命令中的DOMAIN和UUID变量，在VPS上执行

```bash
docker run -d \
  --name trojan \
  -p 80:80/tcp \
  -e DOMAIN=你的域名 \
  -e UUID=$(cat /proc/sys/kernel/random/uuid) \
  -e ALTER_ID="64" \
  -e PROXY_PATH="/" \
  -e PROXY_PORT="80" \
  --restart unless-stopped \
  ghcr.io/monlor/quick-v2ray:main
```

另外，如果你还没有安装docker，执行下面的命令一键安装

```bash
curl -sSL https://get.docker.com/ | sh
```

## 参考

[v2rayDocker](https://github.com/pengchujin/v2rayDocker)