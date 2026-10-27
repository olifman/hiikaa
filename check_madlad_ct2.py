import ctranslate2
import json

path = r"C:\Projects\hiikaa\models\madlad400-ct2-test"

translator = ctranslate2.Translator(
    path,
    device="cpu",
    inter_threads=1,
    intra_threads=2
)

print("CTranslate2 version:", ctranslate2.__version__)
print("\n===== MODEL CONFIG =====")

try:
    config = translator.get_model_config()
    print(json.dumps(config, indent=2, ensure_ascii=False, default=str))
except Exception as error:
    print("Model config dubbisuu hin dandeenye:", error)

print("\n===== MODEL INFO =====")
try:
    print("Supported compute types:", translator.get_supported_compute_types("cpu"))
except Exception as error:
    print(error)
