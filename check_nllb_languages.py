from transformers import AutoTokenizer

model_path = r"C:\Users\olifm\.cache\huggingface\hub\models--facebook--nllb-200-distilled-600M\snapshots\f8d333a098d19b4fd9a8b18f94170487ad3f821d"

tokenizer = AutoTokenizer.from_pretrained(
    model_path,
    local_files_only=True
)

for code in ["eng_Latn", "orm_Latn", "amh_Ethi", "gaz_Latn"]:
    print(code, "=>", tokenizer.convert_tokens_to_ids(code))

print("\nAfaanota Oromoo fi Amaaraa waliin walqabatan:")
for lang in tokenizer.additional_special_tokens:
    if any(word in lang.lower() for word in ["orm", "gaz", "amh"]):
        print(lang)
