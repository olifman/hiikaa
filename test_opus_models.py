import torch
from pathlib import Path
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

root = Path(r"C:\Projects\hiikaa\models\opus_mt")

def load_model(folder):
    path = root / folder
    tokenizer = AutoTokenizer.from_pretrained(
        str(path), local_files_only=True
    )
    model = AutoModelForSeq2SeqLM.from_pretrained(
        str(path), local_files_only=True
    )
    model.eval()
    return tokenizer, model

print("OPUS-MT modeloota fe'aa jira...")
en_om_tokenizer, en_om_model = load_model("en-om")
om_en_tokenizer, om_en_model = load_model("om-en")

english_tests = [
    "Thank you.",
    "How are you?",
    "How are you today?",
    "I need water.",
    "I want to learn Afaan Oromo.",
    "I am learning English.",
    "I am learning Afaan Oromo.",
    "I will go to school tomorrow.",
    "I am going to school today.",
    "The teacher speaks Afaan Oromo.",
    "The teacher speaks English.",
    "We are learning Afaan Oromo.",
    "She goes to school.",
    "He reads a book.",
    "I am a student.",
    "I am a teacher.",
    "I have work today.",
    "I will see you tomorrow.",
    "Please help me.",
    "I need food.",
]

oromo_tests = [
    "Galatoomi.",
    "Akkam jirta?",
    "Akkam jirtu?",
    "Ani bishaan nan barbaada.",
    "Ani Afaan Oromoo barachaa jira.",
    "Ani Afaan Ingilizii barachaa jira.",
    "Boru gara mana barumsaa nan deema.",
    "Har'a gara mana barumsaa nan deema.",
    "Kaleessa mana barumsaa deeme.",
    "Barsiisaan koo Afaan Oromoo dubbata.",
    "Barsiisaan koo Afaan Ingilizii dubbata.",
    "Nuti Afaan Oromoo baranna.",
    "Isheen mana barumsaa deemti.",
    "Inni kitaaba dubbisa.",
    "Ani barataa dha.",
    "Ani barsiisaa dha.",
    "Har'a hojii qaba.",
    "Boru si nan arga.",
    "Maaloo na gargaari.",
    "Ani nyaata nan barbaada.",
]

def translate(tokenizer, model, sentence, target_code=None):
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    kwargs = {"max_new_tokens": 100}

    if target_code:
        target_id = tokenizer.convert_tokens_to_ids(target_code)
        kwargs["forced_bos_token_id"] = target_id

    with torch.no_grad():
        output = model.generate(**inputs, **kwargs)

    return tokenizer.batch_decode(
        output, skip_special_tokens=True
    )[0].strip()

results = []

print("\n===== ENGLISH -> AFAAN OROMOO =====")
for i, sentence in enumerate(english_tests, 1):
    try:
        answer = translate(en_om_tokenizer, en_om_model, sentence)
    except Exception as e:
        answer = "ERROR: " + str(e)

    results.append(("EN>OM", i, sentence, answer))
    print(f"{i:02}. {sentence}")
    print(f"    OPUS-MT: {answer}\n")

print("\n===== AFAAN OROMOO -> ENGLISH =====")
for i, sentence in enumerate(oromo_tests, 1):
    try:
        answer = translate(om_en_tokenizer, om_en_model, sentence)
    except Exception as e:
        answer = "ERROR: " + str(e)

    results.append(("OM>EN", i, sentence, answer))
    print(f"{i:02}. {sentence}")
    print(f"    OPUS-MT: {answer}\n")

output = Path(r"C:\Projects\hiikaa\opus_mt_40_test.txt")
with output.open("w", encoding="utf-8") as f:
    for direction, i, original, answer in results:
        f.write(f"{direction} {i:02}. {original}\n")
        f.write(f"OPUS-MT: {answer}\n\n")

print("Qorannoon xumurame.")
print("Bu'aan kuufame:", output)
