from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "We are learning Afaan Oromo.",
    "She is teaching the students.",
    "I will go to school tomorrow.",
    "He is drinking water.",
    "My mother is cooking food.",
    "I studied yesterday.",
    "They are going to the market.",
    "I want to improve my English.",
    "The students are studying together.",
    "I am going to help my family.",
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
    print("\nEnglish:", sentence)
    print("Oromo:  ", tokenizer.decode(output[0], skip_special_tokens=True))
