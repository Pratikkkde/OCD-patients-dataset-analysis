# Step 0: Import necessary libraries
import pandas as pd

# Step 1: Load the dataset
df = pd.read_csv("OCD Patient Dataset_ Demographics & Clinical Data.csv")

# Step 2: Standardize column names
# - Convert to lowercase
# - Replace spaces with underscores
# - Remove parentheses
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(' ', '_')
    .str.replace('(', '', regex=False)
    .str.replace(')', '', regex=False)
)

# Step 3: Convert 'ocd_diagnosis_date' column to datetime format
# - Errors are coerced into NaT (Not a Time) for invalid entries
df['ocd_diagnosis_date'] = pd.to_datetime(df['ocd_diagnosis_date'], errors='coerce')

# Step 4: Replace placeholders for missing values with proper NaN
# - This includes common entries like 'None', 'N/A', empty strings, and blank spaces
df.replace(['None', 'none', 'N/A', 'n/a', '', ' '], pd.NA, inplace=True)

# Step 5: Standardize binary categorical columns
# - This ensures values like 'yes', 'Yes', 'YES' all become 'Yes'
binary_cols = ['family_history_of_ocd', 'depression_diagnosis', 'anxiety_diagnosis']
for col in binary_cols:
    df[col] = df[col].str.capitalize()

# Step 6: Optionally check for and drop duplicate entries (based on all columns)
df.drop_duplicates(inplace=True)

# Step 7: Preview cleaned data (optional)
print(df.head())

# Step 8: Save the cleaned dataset to a new file (optional)
df.to_csv("Cleaned_OCD_Patient_Data.csv", index=False)
# Load the cleaned file again (just to double-check formatting)
df = pd.read_csv("Cleaned_OCD_Patient_Data.csv")

# Ensure the date column is in correct ISO format
df['ocd_diagnosis_date'] = pd.to_datetime(df['ocd_diagnosis_date'], errors='coerce')
df['ocd_diagnosis_date'] = df['ocd_diagnosis_date'].dt.strftime('%Y-%m-%d')

# Export it again (now super-clean for MySQL)
df.to_csv("Cleaned_OCD_Patient_Data_for_MySQL.csv", index=False)
