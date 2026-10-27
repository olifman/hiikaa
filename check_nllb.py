from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

model_path = r"C:\Users\olifm\.cache\huggingface\hub\models--facebook--nllb-200-distilled-600M\snapshots\f8d333a098d19b4fd9a8b18f94170487ad3f821d"

print("Tokenizer fe'amaa jira...")
tokenizer = AutoTokenizer.from_pretrained(
    model_path,
    local_files_only=True
)

print("Modelii fe'amaa jira...")
model = AutoModelForSeq2SeqLM.from_pretrained(
    model_path,
    local_files_only=True
)

print("MILKAA'E! NLLB modelichi sirriitti fe'ameera.")
