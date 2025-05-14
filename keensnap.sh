#!/bin/sh
# 加载配置文件
source /opt/root/KeenSnap/config.sh

# 定义颜色
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# 用户信息
USERNAME="spatiumstas"
REPO="keensnap"
SCRIPT="keensnap.sh"
TMP_DIR="/tmp"
OPT_DIR="/opt"

KEENSNAP_DIR="/opt/root/KeenSnap"
SNAPD="keensnap-init"
CONFIG_FILE="/opt/root/KeenSnap/config.sh"
PATH_SCHEDULE="/opt/etc/ndm/schedule.d/99-keensnap.sh"
CONFIG_TEMPLATE="config.template"
SCRIPT_VERSION=$(grep -oP 'SCRIPT_VERSION="\K[^"]+' $KEENSNAP_DIR/$SNAPD)

# 打印主菜单
print_menu() {
  printf "\033c"
  printf "${CYAN}"
  cat <<'EOF'
  _  __               ____
 | |/ /___  ___ _ __ / ___| _ __   __ _ _ __
 | ' // _ \/ _ \ '_ \\___ \| '_ \ / _\` | '_ \
 | . \  __/  __/ | | |___) | | | | (_| | |_) |
 |_|\_\___|\___|_| |_|____/|_| |_|\__,_| .__/
                                       |_|
EOF
  if [ ! -f $KEENSNAP_DIR/$SNAPD ]; then
    printf "${RED}配置尚未完成${NC}\n\n"
  else
    printf "${RED}脚本版本: ${NC}%s\n\n" "$SCRIPT_VERSION by ${USERNAME}"
  fi
  echo "1. 配置设置"
  echo "2. 备份参数"
  echo "3. 连接 Telegram"
  echo "4. 手动备份"
  echo ""
  echo "77. 删除文件"
  echo "99. 更新脚本"
  echo "00. 退出"
  echo ""
}

# 主菜单逻辑
main_menu() {
  print_menu
  read -p "请选择操作: " choice branch
  echo ""
  choice=$(echo "$choice" | tr -d '\032' | tr -d '[A-Z]')
  if [ -z "$choice" ]; then
    main_menu
  else
    case "$choice" in
    1) setup_config ;;
    2) select_backup_options ;;
    3) connect_telegram ;;
    4) manual_backup ;;
    77) remove_script ;;
    99) script_update "main" ;;
    999) script_update "dev" ;;
    00) exit ;;
    *) echo "无效选择，请重试。" ; sleep 1 ; main_menu ;;
    esac
  fi
}
