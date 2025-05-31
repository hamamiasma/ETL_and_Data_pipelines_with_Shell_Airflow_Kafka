#!/bin/bash

# Dieses Skript:
# 1. Extrahiert Daten aus /etc/passwd
# 2. Wandelt die Daten ins CSV-Format um
# 3. Lädt die Daten in PostgreSQL

# Extrahieren der Daten
echo "Daten werden extrahiert..."
cut -d":" -f1,3,6 /etc/passwd | grep -v "^#" | grep -v "^$" > extracted-data.txt
echo "Daten wurden in extracted-data.txt gespeichert."

# Daten transformieren
echo "Daten werden transformiert..."
tr ":" "," < extracted-data.txt > transformed-data.csv
echo "Daten wurden in transformed-data.csv umgewandelt."

# Überprüfen, ob die CSV-Datei gültige Daten enthält
if [ ! -s transformed-data.csv ]; then
    echo "Fehler: transformed-data.csv enthält keine gültigen Daten."
    exit 1
fi

# Daten in PostgreSQL laden
echo "Daten werden in PostgreSQL geladen..."
export PGPASSWORD='dein_passwort'
echo "\c template1; \\COPY users FROM '$(pwd)/transformed-data.csv' DELIMITERS ',' CSV;" | psql --username=asmaahamami
echo "Daten erfolgreich in die Datenbank geladen." 