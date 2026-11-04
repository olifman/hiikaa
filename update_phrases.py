import pandas as pd
import os

csv_path = 'hiikaa_200_phrases.csv'
if not os.path.exists(csv_path):
    print("Kurmaaniin CSV hin argamne!")
    exit()

df = pd.read_csv(csv_path)
dart_file_path = 'lib/phrases.dart'

new_entries = []
for _, row in df.iterrows():
    cat = str(row['Category']).replace("'", "\\'")
    en = str(row['English']).replace("'", "\\'")
    om = str(row['Afaan Oromoo']).replace("'", "\\'")
    am = str(row['Amharic']).replace("'", "\\'")
    new_entries.append(f"  ['{cat}', '{en}', '{om}', '{am}'],")

dart_code = "const seedPhrases = <List<String>>[\n  ['Category', 'English', 'Afaan Oromoo', 'Amharic'],\n" + "\n".join(new_entries) + "\n];\n"

with open(dart_file_path, 'w', encoding='utf-8') as f:
    f.write(dart_code)

print(f"Milkaa'inaan galmeewwan {len(df)} dabalaman!")