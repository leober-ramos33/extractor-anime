#!/bin/bash
# Script for Bash, for extracting links of anime from animeyt.tv
# By @yonaikerlol


green="\e[32m"
normal="\e[0m"
underlined="\e[4m"
bold="\e[1m"
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

   #                           #     # #######
  # #   #    # # #    # ######  #   #     #
 #   #  ##   # # ##  ## #        # #      #
#     # # #  # # # ## # #####     #       #
####### #  # # # #    # #         #       #
#     # #   ## # #    # #         #       #
#     # #    # # #    # ######    #       #

"

if [ -z "${1}" ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ] || [ "${1}" = "--version" ] || [ -z "${2}" ]; then
	echo "Usage: $(basename "${0}") <id of anime> <episodes>"
	echo "Example: ${0} black-clover 45"
	exit 0
fi

anime=$(echo "${1}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")

echo -e "Extracting ${bold}${anime}:${normal} ( ${underlined}https://www.animeyt.tv/${1}${normal} )\n"

echo "${anime}:" > ".${1}.txt"
echo "# ${anime}:" > ".${1}.min.txt"

for (( f=1; f <= $2; f++ )); do
	if [ "${f}" -lt 10 ]; then
		echo -en "0${f}... ( ${underlined}https://www.animeyt.tv/ver/${1}-${f}-sub-espanol${normal} )"
	else
		echo -en "${f}... ( ${underlined}https://www.animeyt.tv/ver/${1}-${f}-sub-espanol${normal} )"
	fi

	req=$(curl -Ls "https://www.animeyt.tv/ver/${1}-${f}-sub-espanol")

	echo "${req}" | grep -o 'https:\/\/www\.dailymotion\.com\/embed\/video\/...................?autoPlay=1' &> /dev/null && dailymotion=true
	echo "${req}" | grep -o 'https:\/\/mega\.nz\/embed#\!........\!...........................................' &> /dev/null && mega=true

	if [ -z "${dailymotion}" ] && [ -z "${mega}" ]; then
		if [ "${f}" -lt 10 ]; then
			echo "0${f}:" >> ".${1}.txt"
		else
			echo "${f}:" >> ".${1}.txt"
		fi
		echo "#" >> ".${1}.min.txt"
		echo -e "\n\t${red}NOK!${normal}\n"
		continue
	fi

	if [ "${dailymotion}" = true ] && [ "${mega}" = true ]; then
		options="\n\t1. Dailymotion\n\t2. MEGA"
		links=$(echo "${req}" | grep -o 'https:\/\/www\.dailymotion\.com\/embed\/video\/...................?autoPlay=1')
		links="${links}\n$(echo "${req}" | grep -o 'https:\/\/mega\.nz\/embed#\!........\!...........................................')"
	elif [ "${dailymotion}" = true ]; then
		link=$(echo "${req}" | grep -o 'https:\/\/www\.dailymotion\.com\/embed\/video\/...................?autoPlay=1')
		if [ "${f}" -lt 10 ]; then
			echo "0${f}: ${link}" >> ".${1}.txt"
		else
			echo "${f}: ${link}" >> ".${1}.txt"
		fi
		echo "${link}" >> ".${1}.min.txt"
		echo -e "\n\t${green}OK!${normal} ( ${bold}${link}${normal} )\n"
		continue
	elif [ "${mega}" = true ]; then
		link=$(echo "${req}" | grep -o 'https:\/\/mega\.nz\/embed#\!........\!...........................................')
		if [ "${f}" -lt 10 ]; then
			echo "0${f}: ${link}" >> ".${1}.txt"
		else
			echo "${f}: ${link}" >> ".${1}.txt"
		fi
		echo "${link}" >> ".${1}.min.txt"
		echo -e "\n\t${green}OK!${normal} ( ${bold}${link}${normal} )\n"
		continue
	fi
	echo -e "\n\tOptions: ${options}"
	echo -e "\t${red}WARNING:${normal} You have 10 seconds to answer, if you do not answer, option 1 will be chosen by default."
	echo -en "\tSelect an option (a number): "

	if ! read -t 10 -r optionSelected; then
		optionSelected=1
		echo ""
	fi
	
	if [ "${optionSelected}" -eq 0 ] || ! [[ "${optionSelected}" =~ ^[0-9]+$ ]]; then
		if [ "${f}" -lt 10 ]; then
			echo "0${f}:" >> ".${1}.txt"
		else
			echo "${f}:" >> ".${1}.txt"
		fi
		echo "#" >> ".${1}.min.txt"
		echo -e "\t${red}NOK!${normal}"
		continue
	fi
	
	link=$(echo "${links}" | sed 's/\\n/\n/g' | sed -n -e "${optionSelected}p")
	
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
