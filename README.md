# extractor-anime

Extractor-Anime es un script escrito en Bash para extraer los enlaces de anime de paginas web, como: `http://jkanime.net`.

Requisitos:
* cURL
* zip

Uso: `./extractor-jkanime.net.sh {serie} {episodios}`
Ejemplo: `./extractor-jkanime.net.sh black-clover-tv 45`
El nombre de la serie lo extraen del enlace, `http://jkanime.net/black-clover-tv`, extraen lo ultimo y quedaria como black-clover-tv

Uso: `./extractor-animeyt.tv.sh {serie} {episodios}`
Ejemplo: `./extractor-anime.yt.sh black-clover 45`
El nombre de la serie lo extraen del enlace, `https://animeyt.tv/black-clover`, extraen lo ultimo y quedaria como black-clover

Paginas soportadas:
* http://jkanime.net
* http://animeyt.tv
