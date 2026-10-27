import torch
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

model_name = "Helsinki-NLP/opus-mt-om-en"

print("Modelii Afaan Oromoo -> English buusaa jira...")
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSeq2SeqLM.from_pretrained(model_name)
model.eval()

tests = [
    "Akkam jirtu?",
    "Galatoomi.",
    "Ani bishaan nan barbaada.",
]

for text in tests:
    inputs = tokenizer(text, return_tensors="pt", truncation=True)
    with torch.no_grad():
        output = model.generate(**inputs, max_new_tokens=100)
    translation = tokenizer.decode(output[0], skip_special_tokens=True)
    print(f"\nAfaan Oromoo: {text}")
    print(f"English:      {translation}")

print("\nQorannoon xumurame.")
