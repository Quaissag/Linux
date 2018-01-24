# Linux-MP3-Tagger 
# Starten mit:
# find /mp3-folder/ -type f -name "*.mp3" -exec sh /path_to_script/mp3taggeritunesv2.sh '{}' \;

# benötigt: mp3info, curl, jq, mid3v2


#!/bin/bash
datei=$1 

artistName=""
trackName=""
collectionName=""
releaseDate=""
songgenre=""
inhalt=""


artist=""
titel=""
suche=""

artist=$(mp3info -p '%a' "$datei" | sed 's/ /+/g')
titel=$(mp3info -p '%t'  "$datei" | sed 's/ /+/g')  


suche=$artist"+"$titel


inhalt=$(curl -s "https://itunes.apple.com/search?limit=1&country=de&term=$suche" | jq ".results[0] | {artistName, trackName,collectionName ,releaseDate, primaryGenreName}")

artistName=$(echo $inhalt | jq -r ".artistName")
trackName=$(echo $inhalt | jq -r ".trackName")
collectionName=$(echo $inhalt | jq -r ".collectionName")
releaseDate=$(echo $inhalt | jq -r ".releaseDate" | cut -d 'T' -f1)
songgenre=$(echo $inhalt | jq -r ".primaryGenreName")

inhalt=""

echo "======================"
echo "Suche nach "$suche"..."

echo -n "\nFolgende Daten gefunden:\n\n"
echo $datei
echo $artistName
echo $trackName
echo $collectionName
echo $songgenre
echo $releaseDate

echo -n "\n\n===============\n\n"


if [ "$songgenre" != "null" ]; then 
	echo "Schreibe Songgenre..."
	mid3v2 -g "$songgenre" "$datei"
fi


if [ "$releaseDate" != "null" ]; then 
	echo "Schreibe VÖ..."
	mid3v2 --date "$rDate" "$datei"
fi




###

#if [ -n $trackName ]; then 
#	mid3v2 -t "$tName" "$datei"
#fi
