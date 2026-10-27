from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "I am studying Afaan Oromo.",
    "My teacher speaks Afaan Oromo.",
    "We want to learn Afaan Oromo together.",
    "She can speak Afaan Oromo very well.",
    "Afaan Oromo is important to me.",
]

target_id = tokenizer.convert_tokens_to_ids("gaz_Latn")

for sentence in tests:
    tokenizer.src_lang = "eng_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    output = model.generate(
        **inputs,
        forced_bos_token_id=target_id,
        max_new_tokens=100,
        num_beams=4
    )
    translation = tokenizer.decode(output[0], skip_special_tokens=True)

    print("\nEnglish:", sentence)
    print("Oromo:  ", translation)
