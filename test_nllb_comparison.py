from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import torch

model_name = "facebook/nllb-200-distilled-600M"

print("NLLB model loading...")
tokenizer = AutoTokenizer.from_pretrained(
    model_name,
    local_files_only=True
)
model = AutoModelForSeq2SeqLM.from_pretrained(
    model_name,
    local_files_only=True
)
model.eval()
print("NLLB loaded successfully!")

tests = [
    ("English to Oromo", "Thank you.", "eng_Latn", "gaz_Latn"),
    ("English to Oromo", "How are you today?", "eng_Latn", "gaz_Latn"),
    ("English to Oromo", "I need water.", "eng_Latn", "gaz_Latn"),
    ("Oromo to English", "Galatoomi.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Ani bishaan nan barbaada.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Ani Afaan Oromoo barachaa jira.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Boru gara mana barumsaa nan deema.", "gaz_Latn", "eng_Latn"),
]

for label, sentence, source, target in tests:
    tokenizer.src_lang = source
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)

    with torch.no_grad():
        output = model.generate(
            **inputs,
            forced_bos_token_id=tokenizer.convert_tokens_to_ids(target),
            max_new_tokens=100,
            num_beams=4
        )

    translation = tokenizer.batch_decode(
        output,
        skip_special_tokens=True
    )[0]

    print(f"\n[{label}]")
    print("Original:   ", sentence)
    print("Translation:", translation)
