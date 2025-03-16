#!/bin/bash -ue

osascript ./scripts/screenshot.scpt
magick $(date "+%y-%m-%d-task.png") -quality 10 $(date "+%y-%m-%d-task.jpg")
rm $(date "+%y-%m-%d-task.png")
magick $(date "+%y-%m-%d-task.jpg") -crop 2050x700+400+600 $(date "+%y-%m-%d-task.jpg")
magick $(date "+%y-%m-%d-task.jpg") -crop 1025x700+1025 $(date "+%y-%m-%d-task.jpg")
