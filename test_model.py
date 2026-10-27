import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

model_name = "Helsinki-NLP/opus-mt-en-om"

print("Modelii buusaa jira. Yeroo fudhachuu danda'a...")
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSeq2SeqLM.from_pretrained(model_name)
model.eval()

tests = [
    "How are you?",
    "Thank you.",
    "I need water.",
]

for text in tests:
    inputs = tokenizer(text, return_tensors="pt", truncation=True)
    with torch.no_grad():
        output = model.generate(**inputs, max_new_tokens=100)
    translation = tokenizer.decode(output[0], skip_special_tokens=True)
    print(f"\nEnglish: {text}")
    print(f"Oromo:   {translation}")

print("\nQorannoon xumurame.")
