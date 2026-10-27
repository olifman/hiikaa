from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import torch

name = "facebook/nllb-200-distilled-600M"

tokenizer = AutoTokenizer.from_pretrained(
    name, local_files_only=True
)
model = AutoModelForSeq2SeqLM.from_pretrained(
    name, local_files_only=True
)
model.eval()

tests = [
    ("Oromo to English", "Ani Afaan Oromoo barachaa jira.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Ani Afaan Ingilizii barachaa jira.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Barsiisaan koo Afaan Oromoo dubbata.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Barsiisaan koo Afaan Ingilizii dubbata.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Boru gara mana barumsaa nan deema.", "gaz_Latn", "eng_Latn"),
    ("Oromo to English", "Har'a gara mana barumsaa nan deema.", "gaz_Latn", "eng_Latn"),
    ("English to Oromo", "I am learning Afaan Oromo.", "eng_Latn", "gaz_Latn"),
    ("English to Oromo", "I am learning English.", "eng_Latn", "gaz_Latn"),
    ("English to Oromo", "I will go to school tomorrow.", "eng_Latn", "gaz_Latn"),
    ("English to Oromo", "I am going to school today.", "eng_Latn", "gaz_Latn"),
]

for direction, sentence, source, target in tests:
    tokenizer.src_lang = source
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)

    with torch.no_grad():
        output = model.generate(
            **inputs,
            forced_bos_token_id=tokenizer.convert_tokens_to_ids(target),
            max_new_tokens=100,
            num_beams=4
        )

    translated = tokenizer.batch_decode(
        output, skip_special_tokens=True
    )[0]

    print(f"\n[{direction}]")
    print("Original:   ", sentence)
    print("Translation:", translated)
