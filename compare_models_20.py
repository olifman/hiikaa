import torch
from llama_cpp import Llama
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

print("Modeloota fe'aa jira...")

gguf_path = (
    r"C:\Projects\hiikaa\models\translatepsy-afrislm"
    r"\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"
)

psy = Llama(
    model_path=gguf_path,
    n_ctx=2048,
    n_threads=4,
    verbose=False
)

name = "facebook/nllb-200-distilled-600M"
tok = AutoTokenizer.from_pretrained(name, local_files_only=True)
nllb = AutoModelForSeq2SeqLM.from_pretrained(
    name, local_files_only=True
)
nllb.eval()

tests = [
    ("EN>OM", "Thank you."),
    ("EN>OM", "How are you?"),
    ("EN>OM", "How are you today?"),
    ("EN>OM", "I need water."),
    ("EN>OM", "I want to learn Afaan Oromo."),
    ("EN>OM", "I am learning English."),
    ("EN>OM", "I am learning Afaan Oromo."),
    ("EN>OM", "I will go to school tomorrow."),
    ("EN>OM", "I am going to school today."),
    ("EN>OM", "The teacher speaks Afaan Oromo."),
    ("OM>EN", "Galatoomi."),
    ("OM>EN", "Akkam jirtu?"),
    ("OM>EN", "Ani bishaan nan barbaada."),
    ("OM>EN", "Ani Afaan Oromoo barachaa jira."),
    ("OM>EN", "Ani Afaan Ingilizii barachaa jira."),
    ("OM>EN", "Boru gara mana barumsaa nan deema."),
    ("OM>EN", "Har'a gara mana barumsaa nan deema."),
    ("OM>EN", "Barsiisaan koo Afaan Oromoo dubbata."),
    ("OM>EN", "Nuti Afaan Oromoo baranna."),
    ("OM>EN", "Isheen mana barumsaa deemti."),
]

def translate_psy(direction, sentence):
    instruction = (
        "Translate to Afaan Oromo"
        if direction == "EN>OM"
        else "Translate to English"
    )
    result = psy.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a careful translation engine. "
                    "Translate the sentence accurately. "
                    "Output only the translation."
                ),
            },
            {
                "role": "user",
                "content": f"{instruction}: {sentence}",
            },
        ],
        max_tokens=100,
        temperature=0.0,
    )
    answer = result["choices"][0]["message"]["content"].strip()
    return answer.replace("</think>", "").strip()

def translate_nllb(direction, sentence):
    source, target = (
        ("eng_Latn", "gaz_Latn")
        if direction == "EN>OM"
        else ("gaz_Latn", "eng_Latn")
    )
    tok.src_lang = source
    inputs = tok(sentence, return_tensors="pt", truncation=True)
    with torch.no_grad():
        output = nllb.generate(
            **inputs,
            forced_bos_token_id=tok.convert_tokens_to_ids(target),
            max_new_tokens=100,
            num_beams=4,
        )
    return tok.batch_decode(output, skip_special_tokens=True)[0]

results = []
print("\nQorannoo jalqabame. Kun yeroo muraasa fudhachuu danda'a.\n")

for index, (direction, sentence) in enumerate(tests, start=1):
    try:
        p = translate_psy(direction, sentence)
    except Exception as e:
        p = "ERROR: " + str(e)

    try:
        n = translate_nllb(direction, sentence)
    except Exception as e:
        n = "ERROR: " + str(e)

    results.append({
        "No": index,
        "Direction": direction,
        "Original": sentence,
        "TranslatePsy": p,
        "NLLB": n,
    })

    print(f"{index:02}. [{direction}] {sentence}")
    print("    TranslatePsy:", p)
    print("    NLLB:        ", n)
    print()

output_file = "model_comparison_20.txt"
with open(output_file, "w", encoding="utf-8") as f:
    f.write("TRANSLATEPSY vs NLLB: 20 SENTENCE TEST\n\n")
    for r in results:
        f.write(f"{r['No']:02}. [{r['Direction']}] {r['Original']}\n")
        f.write(f"TranslatePsy: {r['TranslatePsy']}\n")
        f.write(f"NLLB: {r['NLLB']}\n\n")

print("Qorannoon xumurame.")
print("Bu'aan kuufame:", output_file)
