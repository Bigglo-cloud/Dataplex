#!/bin/bash

# =================================================================
# FINALNY SKRYPT DO AKTUALIZACJI (z obsługą Overview)
# =================================================================
PROJECT_ID="your-project-id"
LOCATION_ID="global"
GLOSSARY_ID="your-glossary-id"
INPUT_CSV_FILE="your-file-name.csv"
# =================================================================

# Sprawdzenie, czy plik CSV istnieje
if [ ! -f "$INPUT_CSV_FILE" ]; then
    echo "BŁĄD: Plik '$INPUT_CSV_FILE' nie został znaleziony."
    exit 1
fi

# Funkcja do aktualizacji definicji (nazwa, opis, overview)
update_term_with_overview() {
    local term_id=$1; local display_name=$2; local description=$3; local overview_content=$4
    echo "  -> Aktualizowanie definicji '${term_id}'..."

    # Prosta ucieczka dla cudzysłowów w treści Overview
    overview_content_escaped=$(echo "$overview_content" | sed 's/"/\\"/g')

    # Przygotowanie fragmentu JSON dla aspektu Overview
    # Zostanie on dodany tylko jeśli overview_content nie jest puste
    local overview_aspect_json=""
    if [ -n "$overview_content" ]; then
        overview_aspect_json=",\"aspects\": {\"projects/dataplex-types/locations/global/aspectTypes/overview\": {\"data\": {\"content\": \"${overview_content_escaped}\"}}}"
    fi

    # Wywołanie API w celu aktualizacji
    # Maska 'update_mask' informuje API, które pola mają być nadpisane.
    curl -s -X PATCH \
        -H "Authorization: Bearer $(gcloud auth print-access-token)" \
        -H "Content-Type: application/json" \
        -d "{
              \"displayName\": \"${display_name}\",
              \"description\": \"${description}\"
              ${overview_aspect_json}
            }" \
        "https://dataplex.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/glossaries/${GLOSSARY_ID}/terms/${term_id}?update_mask=displayName,description,aspects"
    
    if [ $? -eq 0 ]; then
        echo "  -> Definicja '${term_id}' zaktualizowana pomyślnie."
    else
        echo "  -> BŁĄD podczas aktualizacji '${term_id}'. Sprawdź, czy na pewno istnieje."
    fi
}

# Główna pętla przetwarzająca plik CSV
tail -n +2 "$INPUT_CSV_FILE" | while IFS=',' read -r CATEGORY_ID TERM_ID TERM_DISPLAY_NAME TERM_DESCRIPTION CONTACT_NAME CONTACT_EMAIL OVERVIEW_CONTENT
do
    if [ -z "$TERM_ID" ]; then continue; fi
    echo "--------------------------------------------------------"
    echo "Przetwarzanie wpisu do aktualizacji: ${TERM_ID}"
    update_term_with_overview "$TERM_ID" "$TERM_DISPLAY_NAME" "$TERM_DESCRIPTION" "$OVERVIEW_CONTENT"
done

echo "--------------------------------------------------------"
echo "Zakończono aktualizowanie danych. ✅"
echo "--------------------------------------------------------"
