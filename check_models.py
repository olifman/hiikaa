from huggingface_hub import snapshot_download
from pathlib import Path

models = [
    "Helsinki-NLP/opus-mt-en-om",
    "Helsinki-NLP/opus-mt-om-en",
]

for model in models:
    print(f"\n===== {model} =====")
    try:
        folder = Path(snapshot_download(
            repo_id=model,
            local_files_only=True
        ))
        print("Bakka:", folder)

        for f in sorted(folder.iterdir()):
            if f.is_file():
                size_mb = f.stat().st_size / (1024 * 1024)
                print(f"{f.name}: {size_mb:.2f} MB")
    except Exception as e:
        print("Modelii guutuu hin argamne:", e)
