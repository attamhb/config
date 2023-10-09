#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
. /etc/X11/Xsession
#$HOME/.screenlayout/display.sh
#exec bspwm
dropbox start
#xmodmap .xmodmap
# Replacing Capslock with Backspace
setxkbmap -option caps:backspace
xmodmap -e "clear Lock"
