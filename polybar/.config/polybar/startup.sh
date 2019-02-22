#!/bin/bash

pkill polybar

MONITOR=VGA-1 polybar -q main &>/dev/null & 
MONITOR=VGA-2 polybar -q main &>/dev/null &
