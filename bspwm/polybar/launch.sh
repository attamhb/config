#! /bin/sh
killall -q polybar


while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


# polybar acer & 2>&1 | tee -a /tmp/polybar.log & disown



polybar hp &

polybar acer &
polybar acer1 &

if [[ $(xrandr -q | grep 'HDMI-1 connected')]]; then
    polybar acer &
fi
