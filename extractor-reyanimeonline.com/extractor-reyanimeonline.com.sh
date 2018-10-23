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
"

if [ -z "${1}" ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ] || [ "${1}" = "--version" ] || [ -z "${2}" ]; then
	echo "Usage: $(basename "${0}") <anime> <episodes>"
	echo "Example: ${0} black-clover-tv 45"
	exit 0
fi

anime=$(echo "${1}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")
echo -e "Extracting ${bold}${anime}:${normal} ( ${underlined}http://reyanimeonline.com/anime/${1}${normal} )\n"

echo "${anime}:" > ".${1}.txt"
echo "# ${anime}:" > ".${1}.min.txt"

for (( f=1; f <= $2; f++ )); do
	if [ "${f}" -lt 10 ]; then
		echo -en "0${f}... ( ${underlined}http://reyanimeonline.com/ver/${1}-${f}${normal} )"
	else
		echo -en "${f}... ( ${underlined}http://reyanimeonline.com/ver/${1}-${f}${normal} )"
	fi
	req=$(curl -s "http://reyanimeonline.com/ver/${1}-${f}")

	echo "${req}" | grep -o 'https://openload.co/embed/...........' &> /dev/null && openload=true
	echo "${req}" | grep -o 'https://streamango.com/embed/................' &> /dev/null && streamango=true
	echo "${req}" | grep -o 'ok.ru/videoembed/.............' &> /dev/null && ok_ru=true
	
	if [ -z "${openload}" ] && [ -z "${streamango}" ] && [ -z "${ok_ru}" ]; then
		if [ "${f}" -lt 10 ]; then
			echo "0${f}:" >> ".${1}.txt"
		else
			echo "${f}:" >> ".${1}.txt"
		fi
		echo "#" > ".${1}.min.txt"
		echo -e "\n\t${red}NOK!${normal}"
		continue
	fi

	if [ "${openload}" = true ] && [ "${streamango}" = true ] && [ "${ok_ru}" = true ]; then
		options="\n\t1. Openload\n\t2. Streamango\n\t3. OK.RU"
		links=$(echo "${req}" | grep -o 'https://openload.co/embed/...........')
		links="${links}\n$(echo "${req}" | grep -o 'https://streamango.com/embed/.................')"
		links="${links}\n$(echo "${req}" | grep -o 'ok.ru/videoembed/.............' | sed 's/^/https:\/\//g')"
	elif [ "${openload}" = true ] && [ "${streamango}" = true ]; then
		options="\n\t1. Openload\n\t2. Streamango"
		links=$(echo "${req}" | grep -o 'https://openload.co/embed/...........')
		links="${links}\n$(echo "${req}" | grep -o 'https://streamango.com/embed/.................')"
	elif [ "${openload}" = true ] && [ "${ok_ru}" = true ]; then
		options="\n\t1. Openload\n\t2. OK.RU"
		links=$(echo "${req}" | grep -o 'https://openload.co/embed/...........')
		links="${links}\n$(echo "${req}" | grep -o 'ok.ru/videoembed/.............' | sed 's/^/https:\/\//g')"
	elif [ "${streamango}" = true ] && [ "${ok_ru}" = true ]; then
		options="\n\t1. Streamango\n\t2. OK.RU"
		links=$(echo "${req}" | grep -o 'https://streamango.com/embed/.................')
		links="${links}\n$(echo "${req}" | grep -o 'ok.ru/videoembed/.............' | sed 's/^/https:\/\//g')"
	elif [ "${openload}" = true ]; then
		options="\n\t1. Openload"
		links=$(echo "${req}" | grep -o 'https://openload.co/embed/...........')
	elif [ "${streamango}" = true ]; then
		options="\n\t1. Streamango"
		links=$(echo "${req}" | grep -o 'https://streamango.com/embed/................')
	elif [ "${ok_ru}" = true ]; then
		options="\n\t1. OK.RU"
		links=$(echo "${req}" | grep -o 'ok.ru/videoembed/.............' | sed 's/^/https:\/\//g')
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
