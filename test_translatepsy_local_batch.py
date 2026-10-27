from pathlib import Path
from llama_cpp import Llama

model_path = Path(
    r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"
)

llm = Llama(
    model_path=str(model_path),
    n_ctx=2048,
    n_threads=4,
    verbose=False
)

tests = [
    ("English to Oromo", "Translate to Afaan Oromo: Thank you."),
    ("English to Oromo", "Translate to Afaan Oromo: How are you today?"),
    ("English to Oromo", "Translate to Afaan Oromo: I need water."),
    ("Oromo to English", "Translate to English: Galatoomi."),
    ("Oromo to English", "Translate to English: Ani bishaan nan barbaada."),
]

for label, prompt in tests:
    result = llm.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": "You are a translation engine. Translate the sentence accurately. Output only the translation, with no explanation or thinking."
            },
            {"role": "user", "content": prompt}
        ],
        max_tokens=100,
        temperature=0.0
    )

    answer = result["choices"][0]["message"]["content"].strip()
    print(f"\n[{label}]")
    print("Input: ", prompt)
    print("Output:", answer)
