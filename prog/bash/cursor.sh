#!/bin/bash
# Description: automatically moves the mouse's cursor in order to fake activity
# Author: zM

get_mouse_pos() {
    eval $(xdotool getmouselocation --shell)
    echo $X $Y
}

require() {
    msg="Required dependency is missing"
    ! command -v xdotool >/dev/null && echo "$msg : xdotool" >&2 && usage
    ! command -v xrandr >/dev/null && echo "$msg : xrandr" >&2 && usage
}

usage() {
    {
        echo "$0 [-h] [-v] [DELAY [OFFSET]]"
        echo "  DELAY         Sleep time between moves in minutes"
        echo "  OFFSET        Amplitude of moves in pixels"
        echo "  -h|--help     This help"
        echo "  -v            Verbose"
    } >&2
    exit
}

require

DEFAULT_OFFSET=1
DEFAULT_DELAY=5
resolution="$(xrandr --current | grep '*' | uniq | awk '{print $1}')"
width="$(echo $resolution | cut -d 'x' -f1)"
height="$(echo $resolution | cut -d 'x' -f2 | cut -d' ' -f2)"

([[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]) && usage
[[ "$1" == "-v" ]] && verbose=true && shift
(($1+0 > 0)) && delay="$1" && shift || delay=$DEFAULT_DELAY
(($1+0 > 0)) && offset="$1" && shift || offset=$DEFAULT_OFFSET

[[ -z "$verbose" ]] || (
    echo "Delay     : $delay" && \
    echo "Offset    : $offset"
)

while true; do
    echo -en "\rLast move : $(date +'%T')"
    pos=$(get_mouse_pos)
    pos_x=$(echo $pos | cut -d ' ' -f1)
    pos_y=$(echo $pos | cut -d ' ' -f2)
    offset=$((($RANDOM > 16000)) && echo $offset || echo -$offset)
    xdotool mousemove $(( ($pos_x+$offset) % $width )) $(( ($pos_y+$offset) % $height ))
    sleep $((60*$delay))
done
