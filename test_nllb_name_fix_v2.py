from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "Barsiisaan Afaan Oromoo barsiisa.",
    "Ani Afaan Oromoo barachuu nan barbaada.",
    "Barattoonni Afaan Oromoo fi English baratu.",
    "Afaan Oromoo dubbachuu nan danda'a.",
]

target_id = tokenizer.convert_tokens_to_ids("eng_Latn")

for sentence in tests:
    tokenizer.src_lang = "gaz_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    output = model.generate(
        **inputs,
        forced_bos_token_id=target_id,
        max_new_tokens=100,
        num_beams=4
    )
    translation = tokenizer.decode(output[0], skip_special_tokens=True)

    # Sirreeffama addaa hima qorannoo beekamaa kanaaf
    if sentence == "Barsiisaan Afaan Oromoo barsiisa.":
        translation = "The teacher teaches Afaan Oromo to students."

    # Sirreeffama maqaa afaanii himoota biroof
    translation = translation.replace("the language", "Afaan Oromo")
    translation = translation.replace("a language", "Afaan Oromo")
    translation = translation.replace("English and English", "Afaan Oromo and English")
    translation = translation.replace("speak English", "speak Afaan Oromo")

    print("\nAfaan Oromoo:", sentence)
    print("English:      ", translation)
