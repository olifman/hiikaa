from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
model = AutoModelForSeq2SeqLM.from_pretrained(name, local_files_only=True)

tests = [
    "Barattoonni guyyaa guyyaan dubbisuu fi shaakala gochuun beekumsa isaanii fooyyeffachuu danda'u.",
    "Barsiisaan barattootaaf Afaan Oromoo barsiisa.",
    "Ani yeroo koo sirnaan qindeessuu fi hojii koo yeroon xumuruun barbaada.",
    "Yoo guyyaa guyyaan baranne, beekumsa keenya fooyyeffachuu dandeenya.",
    "Barataan gaarii yeroo isaa sirnaan fayyadama, hojii manaatiis ni xumura.",
]

target_id = tokenizer.convert_tokens_to_ids("eng_Latn")

for sentence in tests:
    tokenizer.src_lang = "gaz_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    output = model.generate(
        **inputs,
        forced_bos_token_id=target_id,
        max_new_tokens=150,
        num_beams=4
    )
    print("\nAfaan Oromoo:", sentence)
    print("English:      ", tokenizer.decode(output[0], skip_special_tokens=True))
