#!/bin/bash

###### Information #######
# Script for Bash, for extrancting links of anime from animeyt.tv
# By @yonaikerlol



####### CONFIG #########

# Episodes
episodes=$2

# Name of anime (https://animeyt.tv/{anime})
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

animeName=$(echo "${anime}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")

if [ -z "${1}" ] || [ -z "${2}" ]; then
	echo -e "Usage: ${0} {anime} {episodes}\nExample: ${0} black-clover 45\n(https://animeyt.tv/{anime})"
	exit 0
fi

echo -e "\nExtracting ${underlined}${animeName}:${normal} ( https://animeyt.tv/${anime} )\n"

echo "${animeName}:" > .linux-$anime.txt
echo "# ${animeName}:" > .linux-$anime.min.txt

for (( f=1; f <= $episodes; f++ )); do                     
        echo -n "${f}... "                               
        html=$(curl -Ls "https://animeyt.tv/ver/${anime}-${f}-sub-espanol")

	if echo "${html}" | grep 'dailymotion.com/embed/video/...................?autoPlay=1' &> /dev/null; then
		link=$(echo "${html}" | grep 'dailymotion.com/embed/video/...................?autoPlay=1' | sed 's/.*src="//g' | sed 's/".*//g' | sed 's/\?.*//g')
	elif echo "${html}" | grep mega.nz &> /dev/null; then
		link=$(echo "${html}" | grep mega.nz | sed 's/.*src="//g' | sed 's/".*//g')
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
