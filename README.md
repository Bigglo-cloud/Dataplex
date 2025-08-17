Dataplex Bulk Glossary Management
This repository provides a bash script to automate the bulk addition and updating of glossary terms and categories within the Google Cloud Dataplex Unified Catalog. It allows you to manage thousands of entries efficiently by reading from a structured CSV file and executing API calls from the Google Cloud Console.

The script supports two primary operations:

Adding new entries: Creates new glossary terms or categories.

Updating existing entries: Modifies existing entries using the PATCH method.

This tool is designed to be executed directly from the Google Cloud Shell, streamlining glossary management without complex application setups.

CSV File Schema
To use the script, you must provide a CSV file with the following columns. The header row is mandatory.

column_name	description	required	example
project_id	The ID of your Google Cloud project.	Yes	my-gcp-project
location	The GCP region of your Dataplex instance.	Yes	us-central1
glossary_id	The ID of the target glossary.	Yes	finance_glossary
category_id	The ID of the category. Use - if adding a term directly to a glossary.	Yes	customer_data or -
term_id	The ID of the glossary term. Use - if adding a category.	Yes	customer_id or -
display_name	The user-friendly name for the term or category.	Yes	Customer Identifier
description	A brief description of the term or category.	No	Unique identifier for each customer.
method	The operation to perform. Must be CREATE or PATCH.	Yes	CREATE

Export to Sheets
Example CSV:

Code snippet

project_id,location,glossary_id,category_id,term_id,display_name,description,method
my-gcp-project,us-central1,finance_glossary,customer_data,-,"Customer Data Category","Holds all customer-related terms.",CREATE
my-ggcp-project,us-central1,finance_glossary,customer_data,customer_id,"Customer Identifier","Unique identifier for each customer.",CREATE
my-gcp-project,us-central1,finance_glossary,customer_data,customer_id,"Customer ID","Updated unique identifier for each customer.",PATCH
Step-by-Step Setup and Usage Guide
Follow these instructions to set up and run the glossary automation script.

1. Prerequisites
Before you begin, ensure you have the following:

A Google Cloud Project with the Dataplex API enabled.

A Dataplex Lake and Glossary already created.

The necessary IAM permissions to manage Dataplex resources (e.g., Dataplex Editor or a custom role with dataplex.glossaries.create, dataplex.terms.create, dataplex.terms.update, etc.).

Google Cloud SDK installed and authenticated, or access to the Google Cloud Shell.

2. Clone the Repository
Open your Google Cloud Shell or a local terminal where gcloud is configured. Clone the repository containing the script.

Bash

git clone <your-repository-url>
cd <your-repository-directory>
3. Prepare Your Input CSV File
Create a CSV file named glossary_entries.csv (or any other name) and populate it according to the schema described above.

To create a new category, provide a category_id but set the term_id to -.

To create a new term, provide both category_id (or - for the root) and term_id.

To update an existing term or category, ensure the method is set to PATCH.

Upload this CSV file to your Cloud Shell instance or make sure it's accessible from where you'll run the script.

4. Make the Script Executable
Grant execution permissions to the bash script.

Bash

chmod +x dataplex_glossary_loader.sh
5. Run the Script
Execute the script from your Cloud Shell, providing the path to your CSV file as an argument.

Bash

./dataplex_glossary_loader.sh glossary_entries.csv
The script will iterate through each row of the CSV file and make the corresponding API calls to Dataplex. It will output progress and any errors to the console.

6. Verify the Results
Once the script finishes, navigate to the Dataplex section in the Google Cloud Console. Open your glossary and verify that the new terms and categories have been created or that existing ones have been updated as expected. Check the script's console output for any failed API calls to troubleshoot specific entries.
