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
	if ! [ -z "$3" ]; then
		if [[ "$3" = "-v" ]]; then
			echo "Executable $2-strip not found! LLVM may not be installed yet. Exiting gracefully."
		fi
	fi

	exit 0
fi

echo 'Stripping all DLLs and executables not previously stripped.'
if find "$1" -maxdepth 1 -mindepth 1 -type f -name "*.dll" | grep -q .;
then
	for i in $1/*.dll; do
		if [ ! -f "$1/stripped-executables/${i#*bin/}" ]; then
			$2-strip "$i" -o "$1/stripped-executables/${i#*bin/}"
			return_code=$?
			echo "$2-strip \"$i\" -o \"$1/stripped-executables/${i#*bin/}\" ran with exit code $return_code"
		fi
	done
fi

if find "$1" -maxdepth 1 -mindepth 1 -type f -name "*.exe" | grep -q .;
then
	for i in $1/*.exe; do
		if [ ! -f "$1/stripped-executables/${i#*bin/}" ]; then
			$2-strip "$i" -o "$1/stripped-executables/${i#*bin/}"
			return_code=$?
			echo "$2-strip \"$i\" -o \"$1/stripped-executables/${i#*bin/}\" ran with exit code $return_code"
		fi
	done
fi