#!/usr/bin/env playonlinux-bash

# Date : (2016-09-13 21-27)
# Last revision : (2016-09-12 22-17)
# Wine version used : 1.6.2
# Distribution used to test : Ubuntu 16.04 LTS
# Author : Tiago Arnold <contato at radaction.com.br>
 
# CHANGELOG
# 
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="Winbox"
WORKING_WINE_VERSION="1.6.2"
EDITOR="contato@radaction.com.br"
EDITOR_URL="http://www.radaction.com.br"
PREFIX="Winbox"
 
POL_SetupWindow_Init
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$EDITOR_URL" "RADACTION ROUTING FREEDOM" "$PREFIX"
 
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"

POL_Call POL_Install_corefonts

mkdir -p "$WINEPREFIX/drive_c/Program Files/Winbox" 
cd "$WINEPREFIX/drive_c/Program Files/Winbox"
POL_Download "http://download2.mikrotik.com/routeros/winbox/3.5/winbox.exe" "3ea43a0b21c271870301e4801bcb1d97"

 
POL_Shortcut "winbox.exe"  "$TITLE"
 
POL_SetupWindow_Close
exit 0