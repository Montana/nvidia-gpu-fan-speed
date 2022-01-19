#!/bin/bash

setFanSpeed() {
	eval "nvidia-settings -a GPUFanControlState=1 -a [fan:0]/GPUCurrentFanSpeed=$1 > /dev/null"
}

cleanup() {
	eval "nvidia-settings -a GPUFanControlState=0"
	exit
}

declare -i gpuTemp

trap cleanup 1 2 3 15 20

while : 
do

	gpuTemp=$(nvidia-settings -q gpucoretemp | grep '^  Attribute' | \
		head -n 1 | perl -pe 's/^.*?(\d+)\.\s*$/\1/;')
	echo -en "Current GPU temperature: $gpuTemp \r"

	if   [ $gpuTemp -ge 70 ]; then
		setFanSpeed 100
	elif [ $gpuTemp -ge 65 ]; then
		setFanSpeed 90
	elif [ $gpuTemp -ge 60 ]; then
		setFanSpeed 75
	elif [ $gpuTemp -ge 55 ]; then
		setFanSpeed 60
	elif [ $gpuTemp -ge 50 ]; then
		setFanSpeed 50
	else
		setFanSpeed 40
	fi

sleep 5
done
