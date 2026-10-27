from llama_cpp import Llama

model_path = r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"

llm = Llama(
    model_path=model_path,
    n_ctx=2048,
    n_gpu_layers=0,
    verbose=False
)

tests = [
    "ሰላም",
    "አመሰግናለሁ",
    "ውሃ እፈልጋለሁ",
    "ተማሪ ነኝ",
    "መልካም ጠዋት"
]

for sentence in tests:
    messages = [
        {
            "role": "system",
            "content": (
                "You are a professional Amharic to English translator. "
                "Translate accurately into natural English. "
                "Return only the English translation, without explanations."
            )
        },
        {
            "role": "user",
            "content": (
                f"Translate this Amharic text into English: "
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

    print("AM:", sentence)
    print("EN:", answer)
    print("-" * 40)
