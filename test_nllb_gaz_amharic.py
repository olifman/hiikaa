import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

path = r"C:\Users\olifm\.cache\huggingface\hub\models--facebook--nllb-200-distilled-600M\snapshots\f8d333a098d19b4fd9a8b18f94170487ad3f821d"

tokenizer = AutoTokenizer.from_pretrained(path, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(path, local_files_only=True)
model.eval()

def translate(text, source, target):
    tokenizer.src_lang = source
    inputs = tokenizer(text, return_tensors="pt", truncation=True)
    target_id = tokenizer.convert_tokens_to_ids(target)

    with torch.no_grad():
        output = model.generate(
            **inputs,
            forced_bos_token_id=target_id,
            max_new_tokens=80,
            num_beams=4
        )

    return tokenizer.batch_decode(output, skip_special_tokens=True)[0]

tests = [
    ("Oromo -> Amharic", "Galatoomi.", "gaz_Latn", "amh_Ethi"),
    ("Oromo -> Amharic", "Ani barataa dha.", "gaz_Latn", "amh_Ethi"),
    ("Oromo -> Amharic", "Bishaan na barbaachisa.", "gaz_Latn", "amh_Ethi"),
    ("Amharic -> Oromo", "አመሰግናለሁ።", "amh_Ethi", "gaz_Latn"),
    ("Amharic -> Oromo", "ተማሪ ነኝ።", "amh_Ethi", "gaz_Latn"),
    ("Amharic -> Oromo", "ውሃ እፈልጋለሁ።", "amh_Ethi", "gaz_Latn"),
]

for label, text, source, target in tests:
    print(f"\n{label}")
    print("Galtee:", text)
    print("Bu'aa:", translate(text, source, target))
