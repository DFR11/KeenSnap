# Backup KeeneticOS configuration
<img src="https://github.com/user-attachments/assets/789cf6e7-848f-44dc-804c-38f84e65c5d5" alt="" width="700">

## Service operation
- The selection of backup objects consists of: `Startup-Config`, `Entware`, `Firmware` and `WireGuard Private-Keys`
- The resulting archive with a copy of the device can be saved/sent to Telegram and/or a mounted partition (external drive/WebDav).
- При срабатывании расписания запускается хук `/opt/etc/ndm/schedule.d/99-keensnap.sh`
- Просмотр логов: `cat /opt/var/log/keensnap.log` или журнале KeeneticOS. Они также сохраняются в каждом созданном архиве.

## Installation:

1. In `SSH` enter the command
```shell
opkg update && opkg install curl && curl -L -s "https://gh-proxy.org/https://github.com/DFR11/KeenSnap/blob/main/install.sh" > /tmp/install.sh && sh /tmp/install.sh
```

2. Select a setting in the script

- Ручной запуска скрипта через `keensnap` или `/opt/root/KeenSnap/keensnap.sh`

# Setup
1. Иметь настроенное расписание, созданное через веб-интерфейс [KeeneticOS](https://support.keenetic.ru/giga/kn-1010/ru/22348-disabling-all-leds-on-schedule.html). Вешать его на что-либо необязательно.
2. After running the script, select 'Configure configuration'. In the list provided, select the desired schedule for the backup frequency. When you launch it for the first time, a configuration file will be created, and subsequently all settings will be recorded in it. The script will also ask where to save the archive with a copy of the device.
3. Go to `Backup Options` and select the desired options.
4. In the `Connect Telegram` section you can specify the data required to send the archive.

## Telegram connection

1. Получить и скопировать `ID` своего аккаунта или чата через [UserInfoBot](https://t.me/userinfobot)
2. Создать своего бота через [BotFather](https://t.me/BotFather) и скопировать его `token`

<img src="https://github.com/user-attachments/assets/ca5c31af-b29c-4d5a-b2d9-75ff64ba2c34" alt="" width="700">

3. Paste into script

   <img src="https://github.com/user-attachments/assets/632f2c6c-0b53-4502-8c6e-0e4c44cfe65b" alt="" width="700">
