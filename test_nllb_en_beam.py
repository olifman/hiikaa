from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "Good morning.",
    "I am learning Afaan Oromo.",
    "I want to help my community.",
    "How are you today?",
    "The teacher teaches Afaan Oromo to students.",
]

for sentence in tests:
    tokenizer.src_lang = "eng_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True, max_length=256)
    output = model.generate(
        **inputs,
        forced_bos_token_id=tokenizer.convert_tokens_to_ids("gaz_Latn"),
        max_new_tokens=128,
        num_beams=4
    )
    print(f"\nEnglish: {sentence}")
    print("Oromo:  ", tokenizer.decode(output[0], skip_special_tokens=True))
