#!/bin/env bash

set -e

status_bar &
picom &
feh --bg-scale ~/Pictures/Clearnight.jpg

exec dbus-launch --sh-syntax --exit-with-session dwm
