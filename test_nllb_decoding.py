import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"

print("NLLB fe'aa jira...")
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(
    name, local_files_only=True
)
model.eval()

tests = [
    ("eng_Latn", "gaz_Latn", "Thank you."),
    ("eng_Latn", "gaz_Latn", "How are you?"),
    ("eng_Latn", "gaz_Latn", "I am learning English."),
    ("eng_Latn", "gaz_Latn", "I am learning Afaan Oromo."),
    ("eng_Latn", "gaz_Latn", "I will go to school tomorrow."),
    ("eng_Latn", "gaz_Latn", "I am going to school today."),
    ("eng_Latn", "gaz_Latn", "The teacher speaks Afaan Oromo."),
    ("gaz_Latn", "eng_Latn", "Ani Afaan Oromoo barachaa jira."),
    ("gaz_Latn", "eng_Latn", "Boru gara mana barumsaa nan deema."),
    ("gaz_Latn", "eng_Latn", "Har'a gara mana barumsaa nan deema."),
]

settings = [
    {"num_beams": 1, "do_sample": False},
    {"num_beams": 4, "do_sample": False},
    {"num_beams": 4, "do_sample": False, "length_penalty": 1.2},
]

results = []

for source, target, sentence in tests:
    tokenizer.src_lang = source
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    target_id = tokenizer.convert_tokens_to_ids(target)

    print(f"\nMadda: {sentence}")
    for setting in settings:
        try:
            with torch.no_grad():
                output = model.generate(
                    **inputs,
                    forced_bos_token_id=target_id,
                    max_new_tokens=100,
                    **setting,
                )
            translated = tokenizer.batch_decode(
                output, skip_special_tokens=True
            )[0]
        except Exception as e:
            translated = "ERROR: " + str(e)

        label = (
            f"beams={setting['num_beams']}, "
            f"length_penalty={setting.get('length_penalty', 1.0)}"
        )
        print(f"  {label}: {translated}")
        results.append((sentence, label, translated))

with open("nllb_decoding_test.txt", "w", encoding="utf-8") as f:
    f.write("NLLB DECODING COMPARISON\n\n")
    for sentence, label, translated in results:
        f.write(f"Original: {sentence}\n")
        f.write(f"Setting: {label}\n")
        f.write(f"Translation: {translated}\n\n")

print("\nQorannoon xumurame.")
print("Bu'aan: C:\\Projects\\hiikaa\\nllb_decoding_test.txt")
