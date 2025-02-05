import pandas as pd

# Load the Excel file
file_path = 'D:/code/NN_molecular_communications/Tables/NNs_per_application/2_NN_per_app.xlsx'
xls = pd.ExcelFile(file_path)

# Load the first sheet into a DataFrame
df = pd.read_excel(xls, sheet_name=xls.sheet_names[0])

# Group the data by 'Application' and 'Year' and count the number of rows in each group
count_per_app_year = df.groupby(['Application', 'Year']).size().reset_index(name='Count')

# Save the result to an Excel file
count_per_app_year.to_excel('D:/code/NN_molecular_communications/Tables/NNs_per_application/3_count_per_application_and_year.xlsx', index=False)

print("The data has been successfully processed and saved to 'count_per_application_and_year.xlsx'.")

