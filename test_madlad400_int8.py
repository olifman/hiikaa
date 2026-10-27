import ctranslate2
from sentencepiece import SentencePieceProcessor

MODEL_PATH = r"C:\Projects\hiikaa\models\madlad400-ct2-test"
sp = SentencePieceProcessor()
sp.load(MODEL_PATH + r"\sentencepiece.model")

translator = ctranslate2.Translator(
    MODEL_PATH,
    device="cpu",
    compute_type="int8",
    inter_threads=1,
    intra_threads=2
)

tests = [
    ("en", "om", "Thank you"),
    ("en", "om", "How are you?"),
    ("en", "om", "I need water"),
    ("om", "en", "Ani bishaan nan barbaada"),
    ("om", "en", "Galatoomi"),
]

for source, target, sentence in tests:
    tokens = sp.encode(f"<2{target}> {sentence}", out_type=str)
    result = translator.translate_batch(
        [tokens],
        beam_size=1,
        max_batch_size=1
    )
    translated = sp.decode(result[0].hypotheses[0])
    print(f"\n{source} -> {target}")
    print("Original:", sentence)
    print("Translation:", translated)
