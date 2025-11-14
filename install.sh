# !/bin/sh

REPO="keensnap"                   # 仓库名称
SCRIPT="keensnap.sh"             # 主脚本文件名
SNAPD="keensnap-init"            # 初始化脚本名
CONFIG="config.template"         # 配置模板文件名
TMP_DIR="/tmp"                   # 临时目录
OPT_DIR="/opt"                   # opt 目录
KEENSNAP_DIR="/opt/root/KeenSnap"  # KeenSnap 安装目录

# Install curl if it is not installed
if ! opkg list-installed | grep -q "^curl"; then
  opkg update
  opkg install curl
fi

# Download the main script and move to the KeenSnap directory
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$SCRIPT" --output $TMP_DIR/$SCRIPT
mkdir -p "$KEENSNAP_DIR"
mv "$TMP_DIR/$SCRIPT" "$KEENSNAP_DIR/$SCRIPT"

# Create a soft link in /opt/bin to facilitate command invocation
cd $OPT_DIR/bin
ln -sf $KEENSNAP_DIR/$SCRIPT $OPT_DIR/bin/$REPO

# Download the init script and move to the KeenSnap directory
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$SNAPD" --output $TMP_DIR/$SNAPD
mv "$TMP_DIR/$SNAPD" "$KEENSNAP_DIR/$SNAPD"

# Download the configuration template and move it as a configuration file
curl -L -s "https://raw.githubusercontent.com/DFR11/$REPO/main/$CONFIG" --output $TMP_DIR/$CONFIG
mv "$TMP_DIR/$CONFIG" "$KEENSNAP_DIR/config.sh"

# Give execution permission to all files in the KeenSnap directory
chmod -R +x "$KEENSNAP_DIR"

# Send installation records to remote log server (via Base64 decoded URL)
URL=$(echo "aHR0cHM6Ly9sb2cuc3BhdGl1bS5rZWVuZXRpYy5wcm8=" | base64 -d)
JSON_DATA="{\"script_update\": \"KeenSnap_install\"}"
curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$URL" -o /dev/null -s

# Execute the main script after the installation is complete
$KEENSNAP_DIR/$SCRIPT
