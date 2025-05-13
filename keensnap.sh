#!/bin/sh
source /opt/root/KeenSnap/config.sh
RED='\033[1;31m'          # 红色
GREEN='\033[1;32m'        # 绿色
CYAN='\033[0;36m'         # 青色
NC='\033[0m'              # 重置颜色
USERNAME="spatiumstas"    # 用户名
REPO="keensnap"           # 仓库名
SCRIPT="keensnap.sh"      # 脚本名
TMP_DIR="/tmp"            # 临时目录
OPT_DIR="/opt"            # 安装目录

KEENSNAP_DIR="/opt/root/KeenSnap"  # KeenSnap主目录
SNAPD="keensnap-init"              # 初始化脚本名
CONFIG_FILE="/opt/root/KeenSnap/config.sh"  # 配置文件路径
PATH_SCHEDULE="/opt/etc/ndm/schedule.d/99-keensnap.sh"  # 计划任务路径
CONFIG_TEMPLATE="config.template"  # 配置模板文件
SCRIPT_VERSION=$(grep -oP 'SCRIPT_VERSION="\K[^"]+' $KEENSNAP_DIR/$SNAPD)  # 获取脚本版本

print_menu() {
  printf "\033c"  # 清屏
  printf "${CYAN}"
  cat <<'EOF'
  _  __               ____  
 | |/ /___  ___ _ __ / ___| _ __   __ _ _ __
 | ' // _ \/ _ \ '_ \\___ \| '_ \ / _` | '_ \
 | . \  __/  __/ | | |___) | | | | (_| | |_) |
 |_|\_\___|\___|_| |_|____/|_| |_|\__,_| .__/
                                       |_|
EOF
  if [ ! -f $KEENSNAP_DIR/$SNAPD ]; then
    printf "${RED}配置未初始化${NC}\n\n"
  else
    printf "${RED}脚本版本: ${NC}%s\n\n" "$SCRIPT_VERSION by ${USERNAME}"
  fi
  echo "1. 配置参数"
  echo "2. 备份选项设置"
  echo "3. 连接Telegram"
  echo "4. 手动备份"
  echo ""
  echo "77. 删除文件"
  echo "99. 更新脚本"
  echo "00. 退出"
  echo ""
}

main_menu() {
  print_menu
  read -p "请选择操作: " choice branch
  echo ""
  choice=$(echo "$choice" | tr -d '\032' | tr -d '[A-Z]')  # 清理输入

  if [ -z "$choice" ]; then
    main_menu
  else
    case "$choice" in
    1) setup_config ;;                # 配置参数
    2) select_backup_options ;;       # 备份选项
    3) connect_telegram ;;            # Telegram集成
    4) manual_backup ;;               # 手动备份
    77) remove_script ;;              # 删除文件
    99) script_update "main" ;;       # 更新主版本
    999) script_update "dev" ;;       # 更新开发版
    00) exit ;;                       # 退出
    *)
      echo "无效选择，请重试。"
      sleep 1
      main_menu
      ;;
    esac
  fi
}

print_message() {
  message="$1"
  color="${2:-$NC}"  # 默认使用NC颜色
  border=$(printf '%0.s-' $(seq 1 $((${#message} + 2))))  # 生成边框
  printf "${color}\n+${border}+\n| ${message} |\n+${border}+\n${NC}\n"
}

exit_function() {
  echo ""
  read -n
