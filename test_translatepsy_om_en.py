from llama_cpp import Llama

model_path = r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"

llm = Llama(
    model_path=model_path,
    n_ctx=2048,
    n_gpu_layers=0,
    verbose=False
)

tests = [
    "Galatoomi.",
    "Ani bishaan nan barbaada.",
    "Akkam jirtu?",
    "Ani barataa dha.",
    "Har'a ganama gaarii dha."
]

for sentence in tests:
    messages = [
        {
            "role": "system",
            "content": (
                "You are a professional Oromo to English translator. "
                "Translate accurately into natural English. "
                "Return only the English translation, without explanations."
            )
        },
        {
            "role": "user",
            "content": (
                f"Please translate the following Oromo text into English: "
                f"{sentence}\n\nTranslation:"
            )
        }
    ]

    result = llm.create_chat_completion(
        messages=messages,
        temperature=0.0,
        max_tokens=128
    )

    answer = result["choices"][0]["message"]["content"].strip()

    if "</think>" in answer:
        answer = answer.split("</think>")[-1].strip()

    print("OM:", sentence)
    print("EN:", answer)
    print("-" * 40)
