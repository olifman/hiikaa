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

sentences = [
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

def translate_psy(sentence):
    result = psy.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": (
                    "Translate English into Afaan Oromo. "
                    "Preserve the exact meaning, language names, "
                    "people, and time expressions. "
                    "Output only the Afaan Oromo translation."
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
    tokenizer.src_lang = "eng_Latn"
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    with torch.no_grad():
        output = nllb.generate(
            **inputs,
            forced_bos_token_id=tokenizer.convert_tokens_to_ids("gaz_Latn"),
            max_new_tokens=100,
            num_beams=4,
        )
    return tokenizer.batch_decode(output, skip_special_tokens=True)[0]

results = []
print("\nQorannoo English -> Afaan Oromoo\n")

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
    print(f"{i:02}. English:      {sentence}")
    print(f"    TranslatePsy: {p}")
    print(f"    NLLB:         {n}\n")

with open("english_to_oromo_20_comparison.txt", "w", encoding="utf-8") as f:
    f.write("ENGLISH -> AFAAN OROMOO MODEL COMPARISON\n\n")
    for i, original, p, n in results:
        f.write(f"{i:02}. English: {original}\n")
        f.write(f"TranslatePsy: {p}\n")
        f.write(f"NLLB: {n}\n\n")

print("Qorannoon xumurame.")
print("Bu'aan: C:\\Projects\\hiikaa\\english_to_oromo_20_comparison.txt")
