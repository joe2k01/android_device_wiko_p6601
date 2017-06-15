#!/bin/bash
COMMAND=$(basename $0)
TREE=$(realpath ./../../../)
DEVICE=$(realpath ./)
PATCHES=$DEVICE/patches
PROJECTS=(
	frameworks/av
	system/core
	bionic
)

BOLD=$(tput bold)
NORM=$(tput sgr0)
WARN=$(tput setaf 1)
SUCC=$(tput setaf 2)

reverse=0
failed=0
case $1 in
	"-h" | "--help")
		echo "Usage: $COMMAND [--reverse]"
		echo "Applies the patches necessary to build LineageOS for R1 HD."
		echo "When you are done, use --reverse to unapply the patches to keep your tree clean."
		exit 0;
		;;
	"-R" | "--reverse")
		echo "Reversing patches..."
		reverse=1
		;;
	*)
		echo "Applying patches..."
		;;
esac

for project in "${PROJECTS[@]}"
do
	echo "${BOLD}Entering $project${NORM}"
	pushd $TREE/$project > /dev/null

	patchdir=`echo $project | sed -e 's/\//_/g'`
	for patch in $PATCHES/$patchdir/*.patch
	do
		patchname=`basename "$patch"`
		echo -n "$patchname: "

		if [ "$reverse" = 1 ]
		then
			# Is this patch NOT applied?
			patch -p1 -N --dry-run < $patch > /dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo "${SUCC}Not applied${NORM}"
				continue
			else
				# Can this patch be cleanly reversed?
				patch -p1 -NR --dry-run --silent < $patch 2> /dev/null
				if [ $? -eq 0 ]
				then
					patch -p1 -NR < $patch
					echo "${SUCC}Reversed${NORM}"
				else
					echo "${WARN}Impossible to reverse patch cleanly. Skipping...${NORM}"
					failed=1
				fi
			fi
		else
			# Has this patch already been applied?
			patch -p1 -NR --dry-run < $patch > /dev/null 2>&1
			if [ $? -eq 0 ]
			then
				echo "${SUCC}Already applied${NORM}"
				continue
			else
				# Can this patch be cleanly applied?
				patch -p1 -N --dry-run --silent < $patch 2>/dev/null
				if [ $? -eq 0 ]
				then
					patch -p1 -N < $patch
					echo "${SUCC}Applied${NORM}"
				else
					echo "${WARN}Impossible to apply patch cleanly. Skipping...${NORM}"
					failed=1
				fi
			fi
		fi
	done

	echo "${BOLD}Leaving $project${NORM}"
	echo
	popd > /dev/null
done

if [ $failed = 1 ]
then
	echo "${WARN}One or more patches failed.${NORM}"
	exit 1
else
	echo "${SUCC}All good.${NORM}"
fi
