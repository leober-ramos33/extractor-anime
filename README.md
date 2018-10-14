# extractor-anime

Extractor-Anime is a set of scripts written in Bash to extract anime download links from pirated websites.

Just for the record, I did not create this tool to tolerate piracy, but it is inevitable and I know someone will use it for such purposes.
Regardless, the way you use this tool is entirely your responsibility.
Respect and support the creators of the animes, along with their cast.

### Requirements:
* cURL (`sudo apt install curl`)

### Usage:
```
./extractor-<page>.sh <id of anime> <episodes>
```

### Examples:
```
./extractor-animeyt.tv.sh black-clover 52
./extractor-jkanime.net.sh goblin-slayer 2
./extractor-reyanimeonline.com.sh release-the-spyce 2
```

### Supported pages:
| Title | URL | Servers |
|---|---|---|
| JKanime | http://jkanime.net | Openload.co, YourUpload, Dailymotion, Rapidvideo |
| reyanimeonline | https://reyanimeonline.com | Openload.co, Streamango, ok.ru |
| AnimeYT | http://animeyt.tv | Dailymotion, Mega |
