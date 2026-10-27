from llama_cpp import Llama

model_path = (
    r"C:\Projects\hiikaa\models\translatepsy-afrislm"
    r"\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"
)

llm = Llama(
    model_path=model_path,
    n_ctx=2048,
    n_threads=4,
    verbose=False
)

tests = [
    ("Oromo to English", "Ani Afaan Oromoo barachaa jira."),
    ("Oromo to English", "Ani Afaan Ingilizii barachaa jira."),
    ("Oromo to English", "Boru gara mana barumsaa nan deema."),
    ("Oromo to English", "Har'a gara mana barumsaa nan deema."),
    ("English to Oromo", "I am learning Afaan Oromo."),
    ("English to Oromo", "I am learning English."),
    ("English to Oromo", "I will go to school tomorrow."),
    ("English to Oromo", "I am going to school today."),
]

for direction, sentence in tests:
    if direction == "Oromo to English":
        instruction = "Translate to English"
    else:
        instruction = "Translate to Afaan Oromo"

    result = llm.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a careful translation engine. "
                    "Translate accurately. Output only the translation."
                )
            },
            {
                "role": "user",
                "content": f"{instruction}: {sentence}"
            }
        ],
        max_tokens=100,
        temperature=0.0
    )

    answer = result["choices"][0]["message"]["content"].strip()

    print(f"\n[{direction}]")
    print("Original:   ", sentence)
    print("Translation:", answer)
