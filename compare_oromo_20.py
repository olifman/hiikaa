import torch
from llama_cpp import Llama
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

print("Modeloota fe'aa jira...")

psy = Llama(
    model_path=r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf",
    n_ctx=2048,
    n_threads=4,
    verbose=False,
)

name = "facebook/nllb-200-distilled-600M"
tokenizer = AutoTokenizer.from_pretrained(name, local_files_only=True)
nllb = AutoModelForSeq2SeqLM.from_pretrained(
    name, local_files_only=True
)
nllb.eval()

# Himoota Afaan Oromoo irraa gara Afaan Ingiliziitti
sentences = [
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

def translate_psy(sentence):
    result = psy.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": (
                    "Translate Afaan Oromo into English. "
                    "Preserve the exact meaning, names of languages, "
                    "people, and time expressions. Output only the translation."
                ),
            },
            {"role": "user", "content": sentence},
        ],
        max_tokens=100,
        temperature=0.0,
    )
    answer = result["choices"][0]["message"]["content"].strip()
    return answer.replace("</think>", "").strip()

def translate_nllb(sentence):
    tokenizer.src_lang = "gaz_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    with torch.no_grad():
        output = nllb.generate(
            **inputs,
            forced_bos_token_id=tokenizer.convert_tokens_to_ids("eng_Latn"),
            max_new_tokens=100,
            num_beams=4,
        )
    return tokenizer.batch_decode(output, skip_special_tokens=True)[0]

results = []
print("\nQorannoo Afaan Oromoo -> English\n")

for i, sentence in enumerate(sentences, 1):
    try:
        p = translate_psy(sentence)
    except Exception as e:
        p = "ERROR: " + str(e)

    try:
        n = translate_nllb(sentence)
    except Exception as e:
        n = "ERROR: " + str(e)

    results.append((i, sentence, p, n))
    print(f"{i:02}. Afaan Oromoo: {sentence}")
    print(f"    TranslatePsy: {p}")
    print(f"    NLLB:         {n}\n")

with open("oromo_20_comparison.txt", "w", encoding="utf-8") as f:
    f.write("AFAN OROMOO -> ENGLISH MODEL COMPARISON\n\n")
    for i, original, p, n in results:
        f.write(f"{i:02}. Afaan Oromoo: {original}\n")
        f.write(f"TranslatePsy: {p}\n")
        f.write(f"NLLB: {n}\n\n")

print("Qorannoon xumurame.")
print("Bu'aan: C:\\Projects\\hiikaa\\oromo_20_comparison.txt")
