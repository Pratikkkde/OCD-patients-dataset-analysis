# OCD-patients-dataset-analysis

This repository contains a clean dataset comprising 1,500 anonymized patient records related to Obsessive-Compulsive Disorder (OCD). The dataset is structured to support data analysis, machine learning, or medical research focused on mental health, particularly OCD, its diagnosis patterns, comorbidities, and treatment.

# About the Dataset:

Each row in the dataset represents a patient diagnosed with OCD, along with a variety of demographic, clinical, and psychological attributes. This cleaned version ensures consistency in formatting and minimal missing values, making it ready for analysis.

# Key Features:

patient_id – A unique anonymized identifier for each patient
age – Age of the patient in years
gender – Gender identity (e.g., Male, Female)
ethnicity – Ethnic background (e.g., African, Hispanic, Caucasian)
marital_status – Current marital status (e.g., Single, Married, Divorced)
education_level – Highest level of education attained by the patient
ocd_diagnosis_date – Date when the OCD diagnosis was made (dd-mm-yyyy format)
duration_of_symptoms_months – Duration of OCD symptoms before diagnosis (in months)
previous_diagnoses – Any previous mental health diagnoses (e.g., MDD, PTSD); may be missing for some records
family_history_of_ocd – Indicates whether OCD is present in the family history (Yes/No)
obsession_type – Type of obsessive thoughts experienced (e.g., Harm-related, Contamination, Hoarding)
compulsion_type – Type of compulsive behavior displayed (e.g., Checking, Washing, Ordering)
y-bocs_score_obsessions – Severity score for obsessions based on the Y-BOCS scale
y-bocs_score_compulsions – Severity score for compulsions based on the Y-BOCS scale
depression_diagnosis – Indicates whether the patient also has depression (Yes/No)
anxiety_diagnosis – Indicates whether the patient also has anxiety (Yes/No)
medications – Medication(s) prescribed to the patient (e.g., SSRI, SNRI, Benzodiazepine); may be missing if none

Y-BOCS (Yale-Brown Obsessive Compulsive Scale) is a common scale used by clinicians to assess the severity of OCD symptoms.

# Data Notes

Missing Data: Some records have missing entries for previous_diagnoses and medications, likely due to patient history not being documented or therapy not being initiated.

Formatting: Dates are stored in dd-mm-yyyy format.
Balanced Information: The dataset includes both clinical and socio-demographic features, enabling a holistic analysis.

# Potential Use Cases

Mental health research and comorbidity analysis
Predictive modeling for OCD diagnosis or treatment response
Public health insights on OCD demographics and patterns
Visualization and storytelling in mental health data science projects
