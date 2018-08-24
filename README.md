# extractor-anime

Extractor-Anime es un script escrito en Bash para extraer los enlaces de anime de paginas web, como: `http://jkanime.net`.

Requisitos:
* cURL
* zip

Uso: `./extractor-{pagina}.sh {serie} {episodios}`
Ejemplo: `./extractor-jkanime.net.sh black-clover-tv 45`
El nombre de la serie lo extraen del enlace, `http://jkanime.net/black-clover-tv` - `https://animeyt.tv/black-clover` - `http://reyanimeonline.com/anime/black-clover-tv`, extraen lo ultimo y quedaria como black-clover-tv.

Paginas soportadas:
* http://jkanime.net - Openload.co, YourUpload
* https://animeyt.tv - Mega.nz, Dailymotion
* http://reyanimeonline.com - Openload.co, Streamango, ok.ru
