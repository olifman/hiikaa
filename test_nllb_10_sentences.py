from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "Ani barataa dha.",
    "Isheen barsiistuu dha.",
    "Nuti Afaan Oromoo baranna.",
    "Isaan gara gabaa deeman.",
    "Ani buna dhuguu nan jaalladha.",
    "Har'a roobni rooba.",
    "Maal nyaachuu barbaadda?",
    "Ani mana keessa jira.",
    "Inni kubbaa miilaa taphachaa jira.",
    "Boru hojii koo nan xumura.",
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
    print("\nAfaan Oromoo:", sentence)
    print("English:      ", tokenizer.decode(output[0], skip_special_tokens=True))
