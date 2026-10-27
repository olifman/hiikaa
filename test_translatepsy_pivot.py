from llama_cpp import Llama

model_path = r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"

llm = Llama(
    model_path=model_path,
    n_ctx=2048,
    n_gpu_layers=0,
    verbose=False
)

def translate(text, source, target):
    prompt = (
        f"You are a professional translator from {source} to {target}. "
        f"Translate the text accurately into natural {target}. "
        "Do not transliterate. Return only the translation."
    )

    result = llm.create_chat_completion(
        messages=[
            {"role": "system", "content": prompt},
            {"role": "user", "content": f"Translate this text:\n{text}"}
        ],
        temperature=0.0,
        max_tokens=128
    )

    answer = result["choices"][0]["message"]["content"].strip()

    if "</think>" in answer:
        answer = answer.split("</think>")[-1].strip()

    return answer

print("=== OROMOO -> ENGLISH -> AMHARIC ===")

for text in [
    "Galatoomi.",
    "Ani barataa dha.",
    "Bishaan na barbaachisa."
]:
    english = translate(text, "Afaan Oromoo", "English")
    amharic = translate(english, "English", "Amharic")

    print("Oromo:", text)
    print("English:", english)
    print("Amharic:", amharic)
    print("-" * 40)

print("\n=== AMHARIC -> ENGLISH -> OROMOO ===")

for text in [
    "አመሰግናለሁ።",
    "ተማሪ ነኝ።",
    "ውሃ እፈልጋለሁ።"
]:
    english = translate(text, "Amharic", "English")
    oromo = translate(english, "English", "Afaan Oromoo")

    print("Amharic:", text)
    print("English:", english)
    print("Oromo:", oromo)
    print("-" * 40)
