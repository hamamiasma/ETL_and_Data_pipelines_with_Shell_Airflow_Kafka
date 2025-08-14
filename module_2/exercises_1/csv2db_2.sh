#!/bin/bash

# csv2db.sh - Verbessertes ETL Script
# Dieses Skript:
# 1. Extrahiert Daten aus /etc/passwd (username, userid, homedirectory)
# 2. Transformiert die Daten ins CSV-Format
# 3. Lädt die Daten in PostgreSQL
# 4. Validiert die erfolgreiche Datenübertragung

# Farbcodes für Output
RED='\033[0;31m'   # أحمر للأخطاء
GREEN='\033[0;32m' # أخضر للنجاح
YELLOW='\033[1;33m'# أصفر للتحذيرات
BLUE='\033[0;34m'  # أزرق للمعلومات
NC='\033[0m'       # إعادة اللون للوضع الافتراضي


# Konfiguration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-template1}" 
DB_USER="${DB_USER:-asmaahamami}"
DB_PASSWORD="${DB_PASSWORD:-Raghad97}"
TABLE_NAME="users"
EXTRACTED_FILE="extracted-data.txt"
CSV_FILE="transformed-data.csv"

# Logging Funktion
#تستقبل مستوى الرسالة (INFO, WARN, ERROR, SUCCESS) ونصّ الرسالة.
# تضيف طابعًا زمنيًّا وتلوّن السطر وفق المستوى
log() {
    local level=$1 # أول وسيط (argument) هو مستوى الرسالة (مثل INFO أو ERROR).
    shift   # حذف أول وسيط من قائمة الوسائط، بحيث يصبح الباقي هو نص الرسالة.
    local message="$@"  # خزن باقي الوسائط (الرسالة) في متغير message.
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')     # يحصل على التاريخ والوقت الحاليين بصيغة سنة-شهر-يوم ساعة:دقيقة:ثانية.
    
    case $level in   # كواد ألوان
        "INFO")
            echo -e "${BLUE}[INFO]${NC} ${timestamp} - $message"  # ${NC}: "No Color" لإعادة اللون الطبيعي بعد الطباعة.
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} ${timestamp} - $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${timestamp} - $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} ${timestamp} - $message"
            ;;
    esac
}

# Fehlerbehandlung
# سجّل الخطأ، تستدعي ‎cleanup‎، ثم تخرج من السكربت مع كود ‏1‏.
error_exit() {
    log "ERROR" "$1"
    cleanup
    exit 1
}

# Cleanup Funktion
# تُنفَّذ عند انتهاء السكربت أو عند وقوع خطأ.
# مهيّأة لحذف الملفات المؤقتة (السطر مع ‎rm‎ معلَّق حاليًا).
cleanup() {
    log "INFO" "Cleanup wird durchgeführt..."
    # Temporäre Dateien löschen wenn gewünscht
    # rm -f "$EXTRACTED_FILE" "$CSV_FILE"
}

# PostgreSQL Verbindung testen
# إذا فشل الاتصال عبر ‎TCP‎، يحاول مجددًا عبر المقبس المحلي (من دون ‎-h‎).
# يعيد ‎0‎ عند النجاح وإلا يُرجِع خطأ.
test_db_connection() {
    log "INFO" "Teste Datenbankverbindung..."
    
    export PGPASSWORD="$DB_PASSWORD"
    
    if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "\q" >/dev/null 2>&1; then
        log "SUCCESS" "Datenbankverbindung erfolgreich"
        return 0
    else
        log "ERROR" "Datenbankverbindung fehlgeschlagen"
        log "INFO" "Versuche alternative Verbindung..."
        
        # Versuche ohne spezifischen Host (lokaler Socket)
        if psql -U "$DB_USER" -d "$DB_NAME" -c "\q" >/dev/null 2>&1; then
            log "SUCCESS" "Lokale Datenbankverbindung erfolgreich"
            DB_HOST=""  # Leerer Host für lokale Verbindung
            return 0
        else
            return 1
        fi
    fi
}

# Tabelle erstellen falls sie nicht existiert
create_table_if_not_exists() {
    log "INFO" "Überprüfe ob Tabelle '$TABLE_NAME' existiert..."
    
    local create_table_sql="
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        username VARCHAR(50),
        userid INTEGER,
        homedirectory VARCHAR(100)
    );"
    
    if [ -z "$DB_HOST" ]; then
        # Lokale Verbindung
        echo "$create_table_sql" | psql -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1
    else
        # Remote Verbindung
        echo "$create_table_sql" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        log "SUCCESS" "Tabelle '$TABLE_NAME' ist verfügbar"
    else
        error_exit "Fehler beim Erstellen der Tabelle '$TABLE_NAME'"
    fi
}

# Daten extrahieren
extract_data() {
    log "INFO" "Extrahiere Benutzerdaten aus /etc/passwd..."
    
    # Extrahiere Felder 1 (username), 3 (userid), 6 (homedirectory)
    # Filtere Kommentare und leere Zeilen heraus
    if cut -d":" -f1,3,6 /etc/passwd | grep -v "^#" | grep -v "^$" > "$EXTRACTED_FILE"; then
        local line_count=$(wc -l < "$EXTRACTED_FILE")
        log "SUCCESS" "Daten erfolgreich extrahiert: $line_count Zeilen in '$EXTRACTED_FILE'"
        
        # Zeige erste 5 Zeilen zur Verifikation
        log "INFO" "Erste 5 Zeilen der extrahierten Daten:"
        head -5 "$EXTRACTED_FILE" | while read line; do
            echo "  $line"
        done
    else
        error_exit "Fehler beim Extrahieren der Daten aus /etc/passwd"
    fi
}

# Daten transformieren
transform_data() {
    log "INFO" "Transformiere Daten ins CSV-Format..."
    
    # Konvertiere Doppelpunkte zu Kommas
    if tr ":" "," < "$EXTRACTED_FILE" > "$CSV_FILE"; then
        local line_count=$(wc -l < "$CSV_FILE")
        log "SUCCESS" "Daten erfolgreich transformiert: $line_count Zeilen in '$CSV_FILE'"
        
        # Validiere CSV-Format
        if [ ! -s "$CSV_FILE" ]; then
            error_exit "Transformierte CSV-Datei ist leer"
        fi
        
        # Zeige erste 5 Zeilen zur Verifikation
        log "INFO" "Erste 5 Zeilen der transformierten Daten:"
        head -5 "$CSV_FILE" | while read line; do
            echo "  $line"
        done
    else
        error_exit "Fehler beim Transformieren der Daten"
    fi
}

# Daten in PostgreSQL laden
load_data() {
    log "INFO" "Lade Daten in PostgreSQL-Tabelle '$TABLE_NAME'..."
    
    # Leere Tabelle zuerst
    local truncate_sql="TRUNCATE TABLE $TABLE_NAME;"
    
    if [ -z "$DB_HOST" ]; then
        echo "$truncate_sql" | psql -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1
    else
        echo "$truncate_sql" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1
    fi
    
    # Absolute Pfad für COPY Befehl
    local absolute_csv_path="$(pwd)/$CSV_FILE"
    local copy_sql="\\COPY $TABLE_NAME FROM '$absolute_csv_path' DELIMITER ',' CSV;"
    
    log "INFO" "Verwende CSV-Datei: $absolute_csv_path"
    
    if [ -z "$DB_HOST" ]; then
        # Lokale Verbindung
        echo "$copy_sql" | psql -U "$DB_USER" -d "$DB_NAME"
    else
        # Remote Verbindung
        echo "$copy_sql" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
    fi
    
    local load_result=$?
    
    if [ $load_result -eq 0 ]; then
        log "SUCCESS" "Daten erfolgreich in die Datenbank geladen"
    else
        error_exit "Fehler beim Laden der Daten in die Datenbank (Exit Code: $load_result)"
    fi
}

# Daten validieren
validate_data() {
    log "INFO" "Validiere geladene Daten..."
    
    local count_sql="SELECT COUNT(*) FROM $TABLE_NAME;"
    local count_result
    
    if [ -z "$DB_HOST" ]; then
        count_result=$(echo "$count_sql" | psql -U "$DB_USER" -d "$DB_NAME" -t -A 2>/dev/null)
    else
        count_result=$(echo "$count_sql" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -A 2>/dev/null)
    fi
    
    if [[ "$count_result" =~ ^[0-9]+$ ]] && [ "$count_result" -gt 0 ]; then
        log "SUCCESS" "Validierung erfolgreich: $count_result Datensätze in der Tabelle"
        
        # Zeige erste 10 Datensätze
        log "INFO" "Erste 10 Datensätze aus der Datenbank:"
        local select_sql="SELECT username, userid, homedirectory FROM $TABLE_NAME LIMIT 10;"
        
        if [ -z "$DB_HOST" ]; then
            echo "$select_sql" | psql -U "$DB_USER" -d "$DB_NAME"
        else
            echo "$select_sql" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
        fi
    else
        error_exit "Validierung fehlgeschlagen: Keine Daten in der Tabelle gefunden"
    fi
}

# Hauptfunktion
main() {
    log "INFO" "Starte ETL-Prozess für Benutzerdaten..."
    log "INFO" "Zieldatenbank: $DB_NAME@$DB_HOST:$DB_PORT"
    log "INFO" "Benutzer: $DB_USER"
    log "INFO" "Tabelle: $TABLE_NAME"
    
    # Setze Trap für Cleanup bei Exit
    trap cleanup EXIT
    
    # Führe ETL-Schritte aus
    test_db_connection || error_exit "Datenbankverbindung konnte nicht hergestellt werden"
    create_table_if_not_exists
    extract_data
    transform_data
    load_data
    validate_data
    
    log "SUCCESS" "ETL-Prozess erfolgreich abgeschlossen!"
}

# Script ausführen
export PGPASSWORD="$DB_PASSWORD"
main "$@"
