from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

MODEL_NAME = "facebook/nllb-200-distilled-600M"

print("NLLB modelii fe'aa jira...")
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME, local_files_only=True)

def translate(text, source_lang, target_lang):
    tokenizer.src_lang = source_lang
    inputs = tokenizer(text, return_tensors="pt", truncation=True, max_length=256)
    target_id = tokenizer.convert_tokens_to_ids(target_lang)

    outputs = model.generate(
        **inputs,
        forced_bos_token_id=target_id,
        max_new_tokens=128
    )
    return tokenizer.batch_decode(outputs, skip_special_tokens=True)[0]

tests = [
    ("English", "How are you?", "eng_Latn", "gaz_Latn"),
    ("English", "Thank you.", "eng_Latn", "gaz_Latn"),
    ("English", "I need water.", "eng_Latn", "gaz_Latn"),
    ("Afaan Oromoo", "Akkam jirtu?", "gaz_Latn", "eng_Latn"),
    ("Afaan Oromoo", "Galatoomi.", "gaz_Latn", "eng_Latn"),
    ("Afaan Oromoo", "Ani bishaan nan barbaada.", "gaz_Latn", "eng_Latn"),
    ("Afaan Oromoo", "Barattoonni guyyaa guyyaan dubbisuu fi shaakala gochuun beekumsa isaanii fooyyeffachuu danda'u.", "gaz_Latn", "eng_Latn"),
]

for language, text, source, target in tests:
    print(f"\n{language}: {text}")
    print("Hiika:", translate(text, source, target))

print("\nQorannoon NLLB xumurame.")
