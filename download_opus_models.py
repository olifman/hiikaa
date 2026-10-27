from pathlib import Path
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

models = {
    "en-om": "Helsinki-NLP/opus-mt-en-om",
    "om-en": "Helsinki-NLP/opus-mt-om-en",
}

root = Path(r"C:\Projects\hiikaa\models\opus_mt")

for direction, model_name in models.items():
    destination = root / direction

    print("\n" + "=" * 55)
    print("Modelii:", model_name)
    print("Bakka kuusaa:", destination)
    print("Buufachuu ykn kuusaa guutuu mirkaneessuu jalqabe...")

    destination.mkdir(parents=True, exist_ok=True)

    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

    tokenizer.save_pretrained(destination)
    model.save_pretrained(destination, safe_serialization=True)

    print("Milkaa'e:", direction)

print("\nModeloonni lamaan kuufamaniiru.")
print("Bakka:", root)
