#!/bin/bash
#
res="1920 1080 60"
variable=$(cvt $res | grep Modeline | cut -d ' ' -f 2-)
monitor=$(xrandr | grep Virtual | grep primary | awk '{print $1}')
modename=$(cvt $res | grep Modeline | cut -d ' ' -f 2)
cstr=$(echo "xrandr --newmode $variable")
eval "$cstr"
cstr=$(echo "xrandr --addmode $monitor $modename")
eval "$cstr"
cstr=$(echo "xrandr --output $monitor --primary --mode $modename --pos 0x0 --rotate normal")
eval "$cstr"