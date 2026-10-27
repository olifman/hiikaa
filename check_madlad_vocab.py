import ctranslate2
import os

path = r"C:\Projects\hiikaa\models\madlad400-ct2-test"

translator = ctranslate2.Translator(
    path,
    device="cpu",
    inter_threads=1,
    intra_threads=2
)

vocab_path = os.path.join(path, "shared_vocabulary.json")

print("Modelii fe'ameera.")
print("Vocabulary file jira:", os.path.exists(vocab_path))

if os.path.exists(vocab_path):
    import json
    with open(vocab_path, "r", encoding="utf-8") as f:
        vocab = json.load(f)

    print("Vocabulary type:", type(vocab).__name__)

    for tag in ["<2en>", "<2om>"]:
        if isinstance(vocab, dict):
            print(tag, "vocabulary keessatti jira:", tag in vocab)
        elif isinstance(vocab, list):
            print(tag, "vocabulary keessatti jira:", tag in vocab)
        else:
            print("Vocabulary format adda ta'e qaba.")
