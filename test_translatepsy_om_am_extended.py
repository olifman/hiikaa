from llama_cpp import Llama

model_path = r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"

llm = Llama(
    model_path=model_path,
    n_ctx=2048,
    n_gpu_layers=0,
    verbose=False
)

tests = [
    ("OM", "Akkam jirtu?"),
    ("OM", "Galatoomi."),
    ("OM", "Bishaan na barbaachisa."),
    ("OM", "Ani barataa dha."),
    ("OM", "Maqaan koo Lamesa."),
    ("AM", "ሰላም፣ እንዴት ነህ?"),
    ("AM", "አመሰግናለሁ።"),
    ("AM", "ውሃ እፈልጋለሁ።"),
    ("AM", "ተማሪ ነኝ።"),
    ("AM", "ስሜ ለማሳ ነው።")
]

for source, sentence in tests:
    if source == "OM":
        target_language = "Amharic"
        target_script = "Ethiopic script"
        direction = "Oromo to Amharic"
    else:
        target_language = "Afaan Oromoo"
        target_script = "Latin script"
        direction = "Amharic to Oromo"

    messages = [
        {
            "role": "system",
            "content": (
                f"You are a professional {direction} translator. "
                f"Translate the source text accurately into natural "
                f"{target_language}, using {target_script}. "
                "Do not transliterate the source words. "
                "Return only the translation, without explanations."
            )
        },
        {
            "role": "user",
            "content": (
                f"Translate this text into {target_language}:\n"
                f"{sentence}"
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

    print(f"SOURCE ({source}): {sentence}")
    print(f"TRANSLATION ({target_language}): {answer}")
    print("-" * 50)
