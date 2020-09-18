import pandas as pd

df = pd.DataFrame()

# renaming all the columns
df.columns = ['patient_id', 'appointment_id', 'gender', 'appt_scheduled_date',
              'appt_date', 'age', 'neighbourhood', 'scholarship', 'hypertension',
              'diabetes', 'alcoholism', 'handicap', 'sms_remider_recieved', 'no_show']

# using a function to renane all columns
# changes all column_names to lower case, and spaces in between words to alphabets

df.rename(columns=lambda x: x.strip().lower().replace(" ", "_"), inplace=True)

# renaming only the chosen columns

df.rename(columns={'pop': 'population', 'lifeExp': 'life_exp', 'gdpPercap': 'gdp_per_cap'}, inplace=True)

# print new column names
print(df.columns)
