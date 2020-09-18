import pandas as pd

df = pd.DataFrame()

# renaming all the columns
df.columns = ['id', 'species', 'generation_id', 'height', 'weight', 'base_experience',
              'type_1', 'type_2', 'hp', 'attack', 'defense', 'speed',
              'special-attack', 'special-defense']

# column list to exclude
column_list = ['type_1', 'type_2']

# new dataframe with excluded columns
columns_not_in_list = df.columns.difference(column_list)

# print new column names
print(columns_not_in_list.columns)
