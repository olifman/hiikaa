import json
from pathlib import Path

folder = Path(r"C:\Projects\hiikaa\models\madlad400-ct2-test")

for filename in ["config.json", "tokenizer_config.json"]:
    path = folder / filename
    print(f"\n===== {filename} =====")

    if not path.exists():
        print("Faayiliin kun hin jiru.")
        continue

    try:
        data = json.loads(path.read_text(encoding="utf-8"))

        keys = [
            "model_type",
            "decoder_start_token",
            "decoder_start_token_id",
            "bos_token",
            "eos_token",
            "unk_token",
            "pad_token",
            "target_prefix",
            "vocab_size"
        ]

        for key in keys:
            if key in data:
                print(f"{key}: {data[key]}")

    except Exception as error:
        print("Dogoggora dubbisuu:", error)
