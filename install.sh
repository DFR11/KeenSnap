#!/bin/sh

REPO="keensnap"                   # 仓库名称
SCRIPT="keensnap.sh"             # 主脚本文件名
SNAPD="keensnap-init"            # 初始化脚本名
CONFIG="config.template"         # 配置模板文件名
TMP_DIR="/tmp"                   # 临时目录
OPT_DIR="/opt"                   # opt 目录
KEENSNAP_DIR="/opt/root/KeenSnap"  # KeenSnap 安装目录

# 如果 curl 未安装，则安装它
if ! opkg list-installed | grep -q "^curl"; then
  opkg update
  opkg install curl
fi

# 下载主脚本并移动到 KeenSnap 目录
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$SCRIPT" --output $TMP_DIR/$SCRIPT
mkdir -p "$KEENSNAP_DIR"
mv "$TMP_DIR/$SCRIPT" "$KEENSNAP_DIR/$SCRIPT"

# 在 /opt/bin 中创建软链接，方便命令调用
cd $OPT_DIR/bin
ln -sf $KEENSNAP_DIR/$SCRIPT $OPT_DIR/bin/$REPO

# 下载初始化脚本并移动到 KeenSnap 目录
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$SNAPD" --output $TMP_DIR/$SNAPD
mv "$TMP_DIR/$SNAPD" "$KEENSNAP_DIR/$SNAPD"

# 下载配置模板并移动为配置文件
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$CONFIG" --output $TMP_DIR/$CONFIG
mv "$TMP_DIR/$CONFIG" "$KEENSNAP_DIR/config.sh"

# 赋予 KeenSnap 目录中所有文件执行权限
chmod -R +x "$KEENSNAP_DIR"

# 向远程日志服务器发送安装记录（通过 Base64 解码 URL）
URL=$(echo "aHR0cHM6Ly9sb2cuc3BhdGl1bS5rZWVuZXRpYy5wcm8=" | base64 -d)
JSON_DATA="{\"script_update\": \"KeenSnap_install\"}"
curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$URL" -o /dev/null -s

# 执行安装完成后的主脚本
$KEENSNAP_DIR/$SCRIPT
