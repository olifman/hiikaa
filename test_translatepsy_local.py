from pathlib import Path
from llama_cpp import Llama

model_path = Path(
    r"C:\Projects\hiikaa\models\translatepsy-afrislm\TranslatePsy-AfriSLM-0.8B-Q4_K_M-imat.gguf"
)

print("Model exists:", model_path.exists())
print("Loading model...")

llm = Llama(
    model_path=str(model_path),
    n_ctx=2048,
    n_threads=4,
    verbose=False
)

print("Model loaded successfully!")

result = llm.create_chat_completion(
    messages=[
        {
            "role": "system",
            "content": "You are a careful English to Afaan Oromo translator. Translate only the given sentence."
        },
        {
            "role": "user",
            "content": "Translate to Afaan Oromo: Thank you."
        }
    ],
    max_tokens=100,
    temperature=0.1
)

print("Translation:")
print(result["choices"][0]["message"]["content"])
