import pandas as pd

def compare_excel_references(ref_file_1, ref_file_2):
    """
    Compare references from two Excel files and print
    the total number of missing entries in each.
    """

    # Read the references from the first Excel file
    df1 = pd.read_excel(ref_file_1, header=None).dropna(how="all")
    set1 = set(df1[0].astype(str))

    # Read the references from the second Excel file
    df2 = pd.read_excel(ref_file_2, header=None).dropna(how="all")
    set2 = set(df2[0].astype(str))

    # Find which references are missing in the second file
    missing_in_second = set1 - set2
    # Find which references are missing in the first file
    missing_in_first = set2 - set1

    print(f"Total references in {ref_file_1}: {len(set1)}")
    print(f"Total references in {ref_file_2}: {len(set2)}\n")

    print(f"Entries in {ref_file_1} but missing in {ref_file_2}: {len(missing_in_second)}")
    for entry in missing_in_second:
        print("  -", entry)

    print("\n--------------------------------\n")

    print(f"Entries in {ref_file_2} but missing in {ref_file_1}: {len(missing_in_first)}")
    for entry in missing_in_first:
        print("  -", entry)

# Example usage:
if __name__ == "__main__":
    # Replace these with the paths or filenames for your Excel files
    ref_file_1 = "References_2.xlsx"
    ref_file_2 = "database_references_2.xlsx"

    compare_excel_references(ref_file_1, ref_file_2)
