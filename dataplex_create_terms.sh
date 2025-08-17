#!/bin/bash

# =================================================================
# FINALNY SKRYPT DO TWORZENIA DEFINICJI (z poprawnym formatem Overview)
# =================================================================
PROJECT_ID="your-project-id"
LOCATION_ID="global"
GLOSSARY_ID="your-glossary-id"
INPUT_CSV_FILE="yourfile.csv"
# =================================================================

# Sprawdzenie, czy plik CSV istnieje
if [ ! -f "$INPUT_CSV_FILE" ]; then
    echo "BŁĄD: Plik '$INPUT_CSV_FILE' nie został znaleziony."
    exit 1
fi

# --- FUNKCJE API ---

create_term() {
    local category_id=$1; local term_id=$2; local display_name=$3; local description=$4
    local parent_path="projects/${PROJECT_ID}/locations/${LOCATION_ID}/glossaries/${GLOSSARY_ID}/categories/${category_id}"
    echo "  -> Tworzenie definicji '${display_name}'..."
    curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" -d "{\"displayName\": \"${display_name}\", \"description\": \"${description}\", \"parent\": \"${parent_path}\"}" "https://dataplex.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/glossaries/${GLOSSARY_ID}/terms?term_id=${term_id}"
}

# --- POPRAWIONA FUNKCJA PONIŻEJ ---
add_overview() {
    local term_id=$1; local overview_content=$2
    if [ -z "$overview_content" ]; then echo "  -> Pomijam Overview (brak danych)."; return; fi
    overview_content=$(echo "$overview_content" | sed 's/"/\\"/g')
    echo "  -> Dodawanie Overview..."
    curl -s -X PATCH -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
    -d "{
          \"aspects\": {
            \"dataplex-types.global.overview\": {
              \"aspect_type\": \"projects/dataplex-types/locations/global/aspectTypes/overview\",
              \"data\": {
                \"content\": \"${overview_content}\"
              }
            }
          }
        }" \
    "https://dataplex.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/entryGroups/@dataplex/entries/projects/${PROJECT_ID}/locations/${LOCATION_ID}/glossaries/${GLOSSARY_ID}/terms/${term_id}?update_mask=aspects"
}

add_owner() {
    local term_id=$1; local contact_name=$2; local contact_email=$3
    if [ -z "$contact_name" ] || [ -z "$contact_email" ]; then echo "  -> Pomijam właściciela (brak danych)."; return; fi
    echo "  -> Dodawanie właściciela: ${contact_name}..."
    curl -s -X PATCH -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
    -d "{\"aspects\": {\"dataplex-types.global.contacts\": {\"data\": {\"identities\": [{\"role\": \"steward\", \"name\": \"${contact_name}\", \"id\": \"${contact_email}\"}]}}}}" \
    "https://dataplex.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/entryGroups/@dataplex/entries/projects/${PROJECT_ID}/locations/${LOCATION_ID}/glossaries/${GLOSSARY_ID}/terms/${term_id}?update_mask=aspects"
}

# --- GŁÓWNA PĘTLA ---
tail -n +2 "$INPUT_CSV_FILE" | while IFS=';' read -r CATEGORY_ID TERM_ID TERM_DISPLAY_NAME TERM_DESCRIPTION CONTACT_NAME CONTACT_EMAIL OVERVIEW_CONTENT
do
    if [ -z "$TERM_ID" ]; then continue; fi
    echo "--------------------------------------------------------"
    echo "Przetwarzanie wpisu: ${TERM_DISPLAY_NAME}"
    create_term "$CATEGORY_ID" "$TERM_ID" "$TERM_DISPLAY_NAME" "$TERM_DESCRIPTION"
    
    echo "  -> Oczekiwanie 5 sekund..."
    sleep 2

    add_overview "$TERM_ID" "$OVERVIEW_CONTENT"
    add_owner "$TERM_ID" "$CONTACT_NAME" "$CONTACT_EMAIL"

    echo "Wpis '${TERM_DISPLAY_NAME}' został przetworzony."
done

echo "--------------------------------------------------------"
echo "Zakończono importowanie danych. ✅"
echo "--------------------------------------------------------"
