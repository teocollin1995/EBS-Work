#!/bin/bash
#https://apple.stackexchange.com/questions/106149/how-do-i-permanently-disable-notification-center-in-mavericks

sudo defaults write /System/Library/LaunchAgents/com.apple.notificationcenterui KeepAlive -bool False
