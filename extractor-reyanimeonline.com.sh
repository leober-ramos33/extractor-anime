#!/bin/bash

###### Information #######
# Script for Bash, for extrancting links of anime from jkanime.net
# By @yonaikerlol



####### CONFIG #########

# Episodes
episodes=$2

# Name of anime (https://reyanimeonline.com/anime/{anime})
anime="${1}"


####### END CONFIG ##########


green="\e[32m"
normal="\e[0m"
underlined="\e[4m"
red="\e[31m"

clear
echo "
 _______  __   __  _______  ______    _______  _______  _______  _______  ______
|       ||  |_|  ||       ||    _ |  |   _   ||       ||       ||       ||    _ |
|    ___||       ||_     _||   | ||  |  |_|  ||       ||_     _||   _   ||   | ||
|   |___ |       |  |   |  |   |_||_ |       ||       |  |   |  |  | |  ||   |_||_
|    ___| |     |   |   |  |    __  ||       ||      _|  |   |  |  |_|  ||    __  |
|   |___ |   _   |  |   |  |   |  | ||   _   ||     |_   |   |  |       ||   |  | |
|_______||__| |__|  |___|  |___|  |_||__| |__||_______|  |___|  |_______||___|  |_|
"

if [ -z "${1}" ] || [ -z "${2}" ]; then
	echo -e "Usage: ${0} {anime} {episodes}\nExample: ${0} black-clover-tv 45\n(https://reyanimeonline.com/anime/{anime})"
	exit 0
fi

animeName=$(echo "${anime}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")
echo -e "\nExtrancting ${underlined}${animeName}:${normal} ( https://reyanimeonline.com/anime/${anime} )\n"

echo "${animeName}:" > .linux-$anime.txt
echo "# ${animeName}:" > .linux-$anime.min.txt

for (( f=1; f <= $episodes; f++ )); do
	echo -n "${f}... "
	html=$(curl -s "https://reyanimeonline.com/ver/${anime}-${f}")

	if echo "${html}" | grep -o "https://openload.co/embed/..........." &> /dev/null; then
		link=$(echo "${html}" | grep -o "https://openload.co/embed/...........")
	elif echo "${html}" | grep -o 'https://streamango.com/embed/.................' &> /dev/null; then
		link=$(echo "${html}" | grep -o "https://streamango.com/embed/................")
	elif echo "${html}" | grep -o 'ok.ru/videoembed/.............' &> /dev/null; then
		link=$(echo "${html}" | grep -o 'ok.ru/videoembed/.............' | sed 's/^/https:\/\//g')
	else
		echo "${f}: " > .linux-$anime.txt
		echo "#" > .linux-$anime.min.txt
		echo -e "${red}NOK!${normal}"
		continue
	fi
	
	echo "${f}: ${link}" >> .linux-$anime.txt
	echo "${link}" >> .linux-$anime.min.txt
	echo -e "${green}OK!${normal} ( ${link} )"
done

sed 's/$'"/`echo \\\r`/" .linux-$anime.txt > $anime.txt
sed 's/$'"/`echo \\\r`/" .linux-$anime.min.txt > $anime.min.txt

zip $anime.zip $anime.txt $anime.min.txt &> /dev/null

rm .linux-* &> /dev/null
rm $anime.txt &> /dev/null
rm $anime.min.txt &> /dev/null
