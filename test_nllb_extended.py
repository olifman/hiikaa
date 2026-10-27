import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

path = r"C:\Users\olifm\.cache\huggingface\hub\models--facebook--nllb-200-distilled-600M\snapshots\f8d333a098d19b4fd9a8b18f94170487ad3f821d"

tokenizer = AutoTokenizer.from_pretrained(path, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(path, local_files_only=True)
model.eval()

def translate(text, source, target):
    tokenizer.src_lang = source
    inputs = tokenizer(text, return_tensors="pt", truncation=True, max_length=256)

    with torch.no_grad():
        output = model.generate(
            **inputs,
            forced_bos_token_id=tokenizer.convert_tokens_to_ids(target),
            max_new_tokens=100,
            num_beams=4
        )

    return tokenizer.batch_decode(output, skip_special_tokens=True)[0]

tests = [
    ("English -> Oromo", "What is your name?", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "My name is Lamesa.", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "Where are you going?", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "I am learning English.", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "I am hungry.", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "Please help me.", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "I am a teacher.", "eng_Latn", "gaz_Latn"),
    ("English -> Oromo", "I want to go home.", "eng_Latn", "gaz_Latn"),

    ("Oromo -> English", "Maqaan koo Lamesa.", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Eessa deemta?", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Ani Afaan Ingilizii barachaa jira.", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Beela'eera.", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Maaloo na gargaari.", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Ani barsiisaa dha.", "gaz_Latn", "eng_Latn"),
    ("Oromo -> English", "Mana deemuu barbaada.", "gaz_Latn", "eng_Latn"),

    ("Oromo -> Amharic", "Maqaan koo Lamesa.", "gaz_Latn", "amh_Ethi"),
    ("Oromo -> Amharic", "Ani barsiisaa dha.", "gaz_Latn", "amh_Ethi"),
    ("Oromo -> Amharic", "Maaloo na gargaari.", "gaz_Latn", "amh_Ethi"),
    ("Amharic -> Oromo", "ስሜ ለማሳ ነው።", "amh_Ethi", "gaz_Latn"),
    ("Amharic -> Oromo", "እባክህ እርዳኝ።", "amh_Ethi", "gaz_Latn"),
    ("Amharic -> Oromo", "ወደ ቤት መሄድ እፈልጋለሁ።", "amh_Ethi", "gaz_Latn"),
]

for i, (label, text, source, target) in enumerate(tests, 1):
    try:
        print(f"\n[{i}/{len(tests)}] {label}")
        print("Input: ", text)
        print("Output:", translate(text, source, target))
    except Exception as e:
        print(f"ERROR: {type(e).__name__}: {e}")

print("\nQORANNOON XUMURAME.")
