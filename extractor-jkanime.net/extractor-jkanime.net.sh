#!/bin/bash
# Script for Bash, for extracting links of anime from jkanime.net
# By @yonaikerlol


green="\e[32m"
normal="\e[0m"
bold="\e[1m"
underlined="\e[4m"
red="\e[31m"

clear
echo "
#######
#       #    # ##### #####    ##    ####  #####  ####  #####
#        #  #    #   #    #  #  #  #    #   #   #    # #    #
#####     ##     #   #    # #    # #        #   #    # #    #
#         ##     #   #####  ###### #        #   #    # #####
#        #  #    #   #   #  #    # #    #   #   #    # #   #
####### #    #   #   #    # #    #  ####    #    ####  #    #

      # #    #
      # #   #    ##   #    # # #    # ######
      # #  #    #  #  ##   # # ##  ## #
      # ###    #    # # #  # # # ## # #####
#     # #  #   ###### #  # # # #    # #
#     # #   #  #    # #   ## # #    # #
 #####  #    # #    # #    # # #    # ######

"

if [ -z "${1}" ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ] || [ "${1}" = "--version" ] || [ -z "${2}" ]; then
	echo "Usage: ${0} <anime> <episodes>"
	echo "Example: ${0} black-clover-tv 45"
	exit 0
fi

anime=$(echo "${1}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")
echo -e "Extracting ${bold}${anime}:${normal} ( ${underlined}http://jkanime.net/${1}${normal} )\n"

echo "${anime}:" > ".${1}.txt"
echo "# ${anime}:" > ".${1}.min.txt"

for (( f=1; f <= $2; f++ )); do
	if [ ${f} -lt 10 ]; then
		echo -en "0${f}... ( ${underlined}http://jkanime.net/${1}/${f}${normal} )"
	else
		echo -en "${f}... ( ${underlined}http://jkanime.net/${1}/${f}${normal} )"
	fi
	req=$(curl -Ls "http://jkanime.net/${1}/${f}")

	if echo "${req}" | grep -o 'https://jkanime.net/jkopen.php?u=...........' &> /dev/null; then
		link=$(echo "${req}" | grep -o 'https://jkanime.net/jkopen.php?u=...........' | sed 's/jkanime.net\/jkopen.php?u=/openload.co\/embed\//g')
	elif echo "${req}" | grep -o 'https://www.yourupload.com/embed/............' &> /dev/null; then
		link=$(echo "${req}" | grep -o 'https://yourupload.com/embed/............')
	elif echo "${req}" | grep -o 'http://www.dailymotion.com/embed/........' &> /dev/null; then
		link=$(echo "${req}" | grep -o 'http://www.dailymotion.com/embed/video/.......')
	elif echo "${req}" | grep -o 'https://www.rapidvideo.com/e/..........'; then
		link=$(echo "${req}" | grep -o 'https://www.rapidvideo.com/e/..........')
	else
		if [ "${f}" -lt 10 ]; then
			echo "0${f}:" >> ".${1}.txt"
		else
			echo "${f}:" >> ".${1}.txt"
		fi
		echo "#" > ".${1}.min.txt"
		echo -e "\t${red}NOK!${normal}"
		continue
	fi
	
	if [ "${f}" -lt 10 ]; then
		echo "0${f}: ${link}" >> ".${1}.txt"
	else
		echo "${f}: ${link}" >> ".${1}.txt"
	fi
	echo "${link}" >> ".${1}.min.txt"
	echo -e "\t${green}OK!${normal} ( ${bold}${link}${normal} )"
done

sed 's/$'"/`echo \\\r`/" ".${1}.txt" > "${1}.txt"
sed 's/$'"/`echo \\\r`/" ".${1}.min.txt" > "${1}.min.txt"

zip "${1}.zip" "${1}.txt" "${1}.min.txt" &> /dev/null

rm ".${1}.txt" &> /dev/null
rm ".${1}.min.txt" &> /dev/null
rm "${1}.txt" &> /dev/null
rm "${1}.min.txt" &> /dev/null
