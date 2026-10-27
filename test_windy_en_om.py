from transformers import MarianMTModel, MarianTokenizer

name = "WindyWord/translate-en-om"
variant = "herm0"

print("Modelii haaraa fe'aa jira. Mee eegi...")
tokenizer = MarianTokenizer.from_pretrained(name, subfolder=variant)
model = MarianMTModel.from_pretrained(name, subfolder=variant)

tests = [
    "How are you?",
    "Thank you.",
    "I am learning Afaan Oromo.",
    "I will go to school tomorrow.",
    "The teacher teaches Afaan Oromo to students.",
    "We are learning Afaan Oromo.",
    "I want to help my community.",
    "Please help me.",
]

for sentence in tests:
    inputs = tokenizer(sentence, return_tensors="pt", truncation=True)
    output = model.generate(**inputs, max_new_tokens=100, num_beams=4)
    print("\nEnglish:", sentence)
    print("Oromo:  ", tokenizer.decode(output[0], skip_special_tokens=True))
