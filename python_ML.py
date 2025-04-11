# Step 0: Import necessary libraries
import pandas as pd

# Step 1: Loading the dataset
df = pd.read_csv("OCD Patient Dataset_ Demographics & Clinical Data.csv")

# Step 2: Standardized column names
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
df.replace(['None', 'none', 'N/A', 'n/a', '', ' '], pd.NA, inplace=True)

# Step 5: Standardize binary categorical columns
# - This ensures values like 'yes', 'Yes', 'YES' all become 'Yes'
binary_cols = ['family_history_of_ocd', 'depression_diagnosis', 'anxiety_diagnosis']
for col in binary_cols:
    df[col] = df[col].str.capitalize()

# Step 6: Checking for and droping duplicate entries 
df.drop_duplicates(inplace=True)

# Step 7: viewing cleaned data
print(df.head())

# Step 8: Cleaned dataset being saved to the new file
df.to_csv("Cleaned_OCD_Patient_Data.csv", index=False)

# Load the cleaned file again (just to double-check formatting)
df = pd.read_csv("Cleaned_OCD_Patient_Data.csv")

# Ensure the date column is in correct ISO format
df['ocd_diagnosis_date'] = pd.to_datetime(df['ocd_diagnosis_date'], errors='coerce')
df['ocd_diagnosis_date'] = df['ocd_diagnosis_date'].dt.strftime('%Y-%m-%d')

# Export it again (now super-clean for MySQL)
df.to_csv("Cleaned_OCD_Patient_Data_for_MySQL.csv", index=False)

# Machine learning Steps

# Step 1: Import Libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
import seaborn as sns

# Step 2: Load Data
df = pd.read_csv("OCD Dataset MySQL.csv")

# Step 3: Encode Categorical Variables
categorical_cols = df.select_dtypes(include=['object']).columns
label_encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    label_encoders[col] = le  # store encoder for decoding later

# Step 4: Define Features and Target
X = df.drop("medications", axis=1)
y = df["medications"]

# Optional: Encode target if not already numeric
le_med = LabelEncoder()
y = le_med.fit_transform(y)

# Step 5: Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Step 6: Create and Train the Model
model = RandomForestClassifier(random_state=42)
model.fit(X_train, y_train)

# Step 7: Make Predictions
y_pred = model.predict(X_test)

# Step 8: Evaluate Model
print("Classification Report:\n", classification_report(y_test, y_pred))
print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))

# Step 9: (Optional) View predicted medication labels
print("Predicted Medications (original labels):")
print(le_med.inverse_transform(y_pred[:10]))