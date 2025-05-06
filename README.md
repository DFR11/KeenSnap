# KeeneticOS 配置备份

## 服务工作原理
- 可选择的备份对象包括：`Startup-Config`（启动配置）、`Entware`、`Firmware`（固件）和 `WireGuard Private-Keys`（WireGuard 私钥）
- 生成的设备备份压缩包可以保存到本地，发送到 Telegram，或者保存到已挂载的分区（如外部存储设备或 WebDav）
- 定时任务触发时，会依次调用 `/opt/etc/ndm/schedule.d/99-keensnap.sh` -> `/opt/etc/init.d/S99keensnap`
- 查看日志可使用命令：`cat /opt/root/KeenSnap/log.txt`，日志也会保存至每个生成的压缩包中

## 安装方法

1. 在 `SSH` 中输入以下命令：

    ```shell
    opkg update && opkg install curl && curl -L -s "https://raw.githubusercontent.com/DFR11/keensnap/main/install.sh" > /tmp/install.sh && sh /tmp/install.sh
    ```

2. 在脚本中选择所需配置项：

    - 手动运行脚本可以使用 `keensnap` 或 `./KeenSnap/keensnap.sh`

## 设置说明
1. 需要在 [KeeneticOS](https://docs.keenetic.com/eaeu/giga/kn-1010/ru/22348-disabling-all-leds-on-schedule.html) 的网页界面中设置一个定时任务，但该定时任务并不需要绑定到实际操作
2. 脚本首次运行后，选择 `配置设置`，从列表中选择用于定期备份的定时任务。第一次运行时将会生成配置文件，后续所有设置都保存在该文件中。脚本还会询问备份文件的保存位置
3. 进入 `备份参数` 设置所需的备份内容
4. 在 `连接 Telegram` 一节中填写用于发送备份文件的相关信息

## 连接 Telegram

1. 通过 [UserInfoBot](https://t.me/userinfobot) 获取并复制你的账号或群组的 `ID`
2. 通过 [BotFather](https://t.me/BotFather) 创建属于自己的 bot，并复制其 `token`
3. 将这些信息填写到脚本中
