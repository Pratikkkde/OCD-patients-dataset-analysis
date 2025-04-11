create database OCD_Data;
use OCD_Data; 
CREATE TABLE ocd_patients (
    patient_id INT,
    age INT,
    gender VARCHAR(10),
    ethnicity VARCHAR(50),
    marital_status VARCHAR(20),
    education_level VARCHAR(50),
    ocd_diagnosis_date DATE,
    duration_of_symptoms VARCHAR(20),
    previous_diagnosis VARCHAR(100),
    family_history_of_ocd VARCHAR(5),
    obsession_type VARCHAR(100),
    compulsion_type VARCHAR(100),
    y_bocs_score_obsession INT,
    y_bocs_score_compulsions INT,
    depression_diagnosis VARCHAR(5),
    anxiety_diagnosis VARCHAR(5),
    medication VARCHAR(100)
);
-- Checking the number of rows to ensure proper import of the data
select count(*) from ocd_patients;

-- Check for NULL or empty strings in medication
SELECT COUNT(*) AS blanks_in_medications
FROM ocd_patients
WHERE medication IS NULL OR TRIM(medication) = '';

-- Check for NULL or empty strings in previous_diagnosis
SELECT COUNT(*) AS blanks_in_previous_diagnosis
FROM ocd_patients
WHERE previous_diagnosis IS NULL OR TRIM(previous_diagnosis) = '';

-- Disable safe update mode temporarily 
SET SQL_SAFE_UPDATES = 0;

-- Filling up the blanks in medication
UPDATE ocd_patients
SET medication = 'None'
WHERE medication IS NULL OR TRIM(medication) = '';

-- Filling up the blanks in previous_diagnosis
UPDATE ocd_patients
SET previous_diagnosis = 'None'
WHERE previous_diagnosis IS NULL OR TRIM(previous_diagnosis) = '';

-- Gender distribution analysis
SELECT gender, COUNT(*) AS count
FROM ocd_patients
GROUP BY gender;

-- Distribution of age through the data
SELECT 
  MIN(age) AS min_age,
  MAX(age) AS max_age,
  AVG(age) AS avg_age
FROM ocd_patients;

-- Ethnicity breakdown of the data
SELECT ethnicity, COUNT(*) AS count
FROM ocd_patients
GROUP BY ethnicity;

--
SELECT education_level, COUNT(*) AS count
FROM ocd_patients
GROUP BY education_level;

-- The preliminary demographic analysis indicates that the dataset is well-balanced
-- across key variables such as age, gender, ethnicity, and education level, ensuring a robust foundation
-- for further statistical evaluation and meaningful insights into OCD-related patterns.

-- variance in the duration of the symptoms
SELECT 
  ROUND(AVG(duration_of_symptoms), 2) AS avg_duration,
  MAX(duration_of_symptoms) AS max_duration,
  MIN(duration_of_symptoms) AS min_duration
FROM ocd_patients;

-- Y-BOCS score analysis
SELECT 
  AVG(y_bocs_score_obsession) AS avg_obsession_score,
  AVG(y_bocs_score_compulsions) AS avg_compulsion_score
FROM ocd_patients;

-- Frequency of co-occurance of depression and anxiety
SELECT 
  depression_diagnosis,
  anxiety_diagnosis,
  COUNT(*) AS count
FROM ocd_patients
GROUP BY depression_diagnosis, anxiety_diagnosis;

-- Most commonly observed previous diagnosis
SELECT previous_diagnosis, COUNT(*) AS count
FROM ocd_patients
GROUP BY previous_diagnosis
ORDER BY count DESC limit 1;

-- Variation in medication usage based on level of education
SELECT education_level, medication, COUNT(*) AS count
FROM ocd_patients
GROUP BY education_level, medication
ORDER BY education_level;

-- Top medications per educational level
SELECT education_level, medication, COUNT(*) AS count
FROM ocd_patients
GROUP BY education_level, medication
HAVING COUNT(*) = (
  SELECT MAX(c) FROM (
    SELECT COUNT(*) AS c
    FROM ocd_patients AS sub
    WHERE sub.education_level = ocd_patients.education_level
    GROUP BY sub.medication
  ) AS counts
)
ORDER BY education_level; -- Here None could mean either the data is meissing or no medication is used by the individual.

-- Use of specific medications based on selected education level 
SELECT education_level, medication, COUNT(*) AS count
FROM ocd_patients
WHERE education_level IN ('Graduate degree', 'College degree')
GROUP BY education_level, medication
ORDER BY education_level, count DESC;

-- Maximum duration for the symptoms based on gender
SELECT 
  gender,
  MAX(duration_of_symptoms) AS max_duration
FROM ocd_patients
GROUP BY gender;

-- Ethnicity wise medication distribution
SELECT ethnicity, medication,
COUNT(*) AS count
FROM ocd_patients
GROUP BY ethnicity, medication
ORDER BY ethnicity, count DESC;

-- Distribution of OCD between various age gropus based on the gender
SELECT 
  gender,
  CASE 
    WHEN age BETWEEN 0 AND 18 THEN '0-18'
    WHEN age BETWEEN 19 AND 30 THEN '19-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS count
FROM ocd_patients
GROUP BY gender, age_group
ORDER BY gender, count DESC; -- The data is not very diverse but the preliminary analysis shows that males may encounter OCD at younger age whicle females may deal with OCD for longer period of time.
 
 -- Ethnicity wise avg OCD score
 SELECT 
  ethnicity,
  COUNT(*) AS total_patients,
  ROUND(AVG(y_bocs_score_obsession + y_bocs_score_compulsions), 2) AS avg_ocd_score
FROM ocd_patients
GROUP BY ethnicity
ORDER BY total_patients DESC; -- OCD score is calculated using Y_bocs_scores for obsession and compulsion (Higher score means severe OCD)
-- The OCD score was found to be least in African and max in Hispanic population

-- Avg duration of symptoms based on the gender and marital_status of the patient
SELECT gender, marital_status,
ROUND(AVG(duration_of_symptoms), 2) AS avg_duration,
MAX(duration_of_symptoms) AS max_duration,
MIN(duration_of_symptoms) AS min_duration,
COUNT(*) AS patient_count
FROM ocd_patients
GROUP BY gender, marital_status
ORDER BY gender, marital_status; -- Here the OCd was found to be least prevalent in married people whereas its maximum duration is observed in divorced individuals.

-- Contribution of family histroy into development of OCD
SELECT 
  family_history_of_ocd,
  ROUND(AVG(y_bocs_score_obsession + y_bocs_score_compulsions), 2) AS avg_ocd_score,
  COUNT(*) AS patient_count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ocd_patients), 2) AS percentage
FROM ocd_patients
GROUP BY family_history_of_ocd; 
/* The analysis indicates that having a family history of OCD does not significantly influence the likelihood or severity of OCD in our dataset.
 Both groups — those with and without a family history — show a fairly similar distribution,
 suggesting that other factors may play a more prominent role in the development and intensity
 of OCD symptoms */
 
-- Distribution of patients based on obsession type and gender
SELECT 
  gender,
  obsession_type,
  COUNT(*) AS count
FROM ocd_patients
GROUP BY gender, obsession_type
ORDER BY gender, count DESC;
-- Most prevalent obsession type in males and females
SELECT gender, obsession_type, count FROM (
  SELECT 
    gender,
    obsession_type,
    COUNT(*) AS count,
    RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
  FROM ocd_patients
  GROUP BY gender, obsession_type
) ranked_obsession
WHERE rnk = 1; -- Little tweaks here and there to find out Compulsion type just replace "obsession_type" with "compulsion_type"

-- Difference in prefered medication based on depression and anxiety diagnosis
SELECT depression_diagnosis, anxiety_diagnosis, medication, patient_count
FROM (
  SELECT 
    depression_diagnosis,
    anxiety_diagnosis,
    medication,
    COUNT(*) AS patient_count,
    RANK() OVER (
      PARTITION BY depression_diagnosis, anxiety_diagnosis 
      ORDER BY COUNT(*) DESC
    ) AS rnk
  FROM ocd_patients
  GROUP BY depression_diagnosis, anxiety_diagnosis, medication
) Ranked
WHERE rnk = 1;

-- Effect of depression and anxiety on OCD Score
SELECT 
  depression_diagnosis,
  anxiety_diagnosis,
  COUNT(*) AS patient_count,
  ROUND(AVG(y_bocs_score_obsession + y_bocs_score_compulsions), 2) AS avg_ocd_score
FROM ocd_patients
GROUP BY depression_diagnosis, anxiety_diagnosis
ORDER BY avg_ocd_score DESC; -- The data doesnt show much variation as usual as the data is well distributed, 
-- still the highest OCD score was obtained when the petient's diagnosis for both depression and anxiety was negative.

-- Marital status and related obsession/compulsion type (Replace obsession_type with compulsion_type)
SELECT marital_status, obsession_type,
COUNT(*) AS count
FROM ocd_patients
GROUP BY marital_status, obsession_type
ORDER BY marital_status, count DESC;

SELECT marital_status, obsession_type, count FROM (
  SELECT 
    marital_status,
    obsession_type,
    COUNT(*) AS count,
    RANK() OVER (PARTITION BY marital_status ORDER BY COUNT(*) DESC) AS rnk
  FROM ocd_patients
  GROUP BY marital_status, obsession_type
) ranked_obsession
WHERE rnk = 1;

-- Most prevalent disorders before OCD based on ethnicity
SELECT ethnicity, previous_diagnosis, diagnosis_count
FROM (
  SELECT 
    ethnicity,
    previous_diagnosis,
    COUNT(*) AS diagnosis_count,
    RANK() OVER (
      PARTITION BY ethnicity 
      ORDER BY COUNT(*) DESC
    ) AS rnk
  FROM ocd_patients
  WHERE previous_diagnosis IS NOT NULL AND previous_diagnosis <> ''
  GROUP BY ethnicity, previous_diagnosis
) ranked_diagnoses
WHERE rnk = 1; -- This analysis may help us in finding a relationship between OCD and the disorders that are already prevalent in the population.

