import json
from pathlib import Path

folder = Path(r"C:\Projects\hiikaa\models\madlad400-ct2-test")

for name in ["config.json", "model.bin", "shared_vocabulary.json"]:
    path = folder / name
    print(f"\n===== {name} =====")
    print("Jira:", path.exists())

    if name == "config.json" and path.exists():
        data = json.loads(path.read_text(encoding="utf-8"))
        print(json.dumps(data, indent=2, ensure_ascii=False))

    elif name == "shared_vocabulary.json" and path.exists():
        vocab = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(vocab, list):
            print("Baay'ina token:", len(vocab))
            for token in ["<pad>", "<unk>", "<s>", "</s>", "<2en>", "<2om>"]:
                print(f"{token}: index =", vocab.index(token) if token in vocab else "hin jiru")
