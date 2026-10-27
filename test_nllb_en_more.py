from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tokenizer.src_lang = "eng_Latn"
target_id = tokenizer.convert_tokens_to_ids("gaz_Latn")

tests = [
    "Good morning.",
    "What is your name?",
    "I am learning Afaan Oromo.",
    "I want to help my community.",
    "Where are you going?",
    "I am going to school today.",
]

for sentence in tests:
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    output = model.generate(
        **inputs,
        forced_bos_token_id=target_id,
        max_new_tokens=100
    )
    print(f"\nEnglish: {sentence}")
    print("Oromo:  ", tokenizer.decode(output[0], skip_special_tokens=True))
