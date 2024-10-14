#!/bin/bash
if [ -z "$1" ]; then
	echo "No input directory supplied!"
	exit 1
fi

if [[ "$1" != *"bin"* ]]; then
	echo "No bin folder found in directory!"
	exit 1
fi

if [ -z "$2" ]; then
	echo "No triplet provided!"
	exit 1
fi

if ! [ -x "$(command -v "$2-strip")" ]; then
	echo "Executable $2-strip not found! LLVM may not be installed yet. Exiting gracefully."
	exit 0
fi

for i in $1/*.dll $1/*.exe; do
	if [ ! -f "$1/stripped-executables/${i#*bin/}" ]; then
		$2-strip "$i" -o "$1/stripped-executables/${i#*bin/}"
		return_code=$?
		echo "$2-strip \"$i\" -o \"$1/stripped-executables/${i#*bin/}\" ran with exit code $return_code"
	fi
done
