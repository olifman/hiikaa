from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "Ani har'a gara mana barumsaa nan deema.",
    "Bishaan dhuguun fayyaa keenyaaf barbaachisaa dha.",
    "Barattoonni guyyaa guyyaan dubbisuu fi shaakala gochuun beekumsa isaanii fooyyeffachuu danda'u.",
    "Barsiisaan barattootaaf Afaan Oromoo barsiisa.",
    "Yeroo koo sirnaan qindeessuun barbaada.",
]

for sentence in tests:
    tokenizer.src_lang = "gaz_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True, max_length=256)
    output = model.generate(
        **inputs,
        forced_bos_token_id=tokenizer.convert_tokens_to_ids("eng_Latn"),
        max_new_tokens=128
    )
    print(f"\nAfaan Oromoo: {sentence}")
    print("English:      ", tokenizer.decode(output[0], skip_special_tokens=True))
