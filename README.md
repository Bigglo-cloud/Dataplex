**Dataplex Bulk Glossary Management**

This repository provides a bash script to automate the bulk addition and updating of glossary terms and categories within the Google Cloud Dataplex Unified Catalog. It allows you to manage thousands of entries efficiently by reading from a structured CSV file and executing API calls from the Google Cloud Console.

The script supports two primary operations:

Adding new entries: Creates new glossary terms or categories.

Updating existing entries: Modifies existing entries using the PATCH method.

This tool is designed to be executed directly from the Google Cloud Shell, streamlining glossary management without complex application setups.

CSV File Schema
To use the script, you must provide a CSV file with the following columns. The header row is mandatory. CSV is comma separated.

| CATEGORY_ID | TERM_ID | TERM_DISPLAY_NAME | TERM_DESCRIPTION | CONTACT_NAME | CONTACT_EMAIL | OVERVIEW_CONTENT |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| cat_01 | term_101 | Nazwa Klienta | Pełna, oficjalna nazwa klienta biznesowego. | Jan Kowalski | j.kowalski@example.com | Podstawowy atrybut opisujący klienta. |
| cat_01 | term_102 | Identyfikator Klienta | Unikalny numer identyfikacyjny przypisany do klienta. | Anna Nowak | a.nowak@example.com | Kluczowy identyfikator używany we wszystkich systemach. |
| cat_02 | term_201 | Numer Zamówienia | Unikalny identyfikator dla każdej transakcji. | Jan Kowalski | j.kowalski@example.com | Używany do śledzenia i raportowania sprzedaży. |


Example CSV:



**1. Prerequisites**
Before you begin, ensure you have the following:

A Google Cloud Project with the Dataplex Universal Catalog API enabled.

A Dataplex Lake and Glossary already created.

The necessary IAM permissions to manage Dataplex resources (e.g., Dataplex Editor or a custom role with dataplex.glossaries.create, dataplex.terms.create, dataplex.terms.update, etc.).

Google Cloud SDK installed and authenticated, or access to the Google Cloud Shell.



**2. Prepare Your Input CSV File**
Create a CSV file named glossary_entries.csv (or any other name) and populate it according to the schema described above.

Upload this CSV file to your Cloud Shell instance or make sure it's accessible from where you'll run the script.


**3. Run the Script**
Execute the script from your Cloud Shell (just simply ctr+c and ctrl+v into the shell)
The script will iterate through each row of the CSV file and make the corresponding API calls to Dataplex. It will output progress and any errors to the console.

**4. Verify the Results**
Once the script finishes, navigate to the Dataplex section in the Google Cloud Console. Open your glossary and verify that the new terms and categories have been created or that existing ones have been updated as expected. Check the script's console output for any failed API calls to troubleshoot specific entries.
