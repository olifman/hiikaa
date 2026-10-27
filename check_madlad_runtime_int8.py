import ctranslate2

path = r"C:\Projects\hiikaa\models\madlad400-ct2-test"

print("CTranslate2:", ctranslate2.__version__)
print("CPU compute types:", ctranslate2.get_supported_compute_types("cpu"))

translator = ctranslate2.Translator(
    path,
    device="cpu",
    compute_type="int8",
    inter_threads=1,
    intra_threads=2
)

print("Model loaded:", translator.model_is_loaded)
print("Device:", translator.device)
print("Compute type:", translator.compute_type)
