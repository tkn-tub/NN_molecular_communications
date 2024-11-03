import pandas as pd
import numpy as np

# Load the CSV file
csv_df = pd.read_excel('NN_parameters_GPT_in.xlsx')

# Grouping the data by 'MC Geometry', 'Application', and counting the occurrences of 'NN arch.'
nn_arch_counts = csv_df.groupby(['MC Geometry', 'Application', 'NN arch.']).size().reset_index(name='Count')

# Display the result
print(nn_arch_counts)

# Calculate the maximum value in the 'Count' column
max_count = nn_arch_counts['Count'].max()

# Adding a new column that evaluates sqrt(Count * max_count)*100
nn_arch_counts['Radius'] = np.sqrt(nn_arch_counts['Count'] / max_count * 0.6**2)*100

# Round the 'Radius' to two decimal places
nn_arch_counts['Radius'] = nn_arch_counts['Radius'].round()/100

# Save the result to an Excel file
nn_arch_counts.to_excel('NN_architecture_GPT_out.xlsx', index=False)

print("The data has been successfully processed and saved to 'output_nn_architecture_counts.xlsx'.")
