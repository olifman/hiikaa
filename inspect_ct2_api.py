import ctranslate2
import inspect

print("CTranslate2:", ctranslate2.__version__)
print("\nTranslator methods:")
for name in dir(ctranslate2.Translator):
    if not name.startswith("_"):
        print(name)

print("\nSupported compute types function:")
print(hasattr(ctranslate2, "get_supported_compute_types"))
