import os
import ctranslate2
from sentencepiece import SentencePieceProcessor

MODEL_PATH = r"C:\Projects\hiikaa\models\madlad400-ct2-test"

print("Modelii fe'aa jira... yeroo muraasa eegi.")

tokenizer = SentencePieceProcessor()
tokenizer.load(os.path.join(MODEL_PATH, "sentencepiece.model"))

translator = ctranslate2.Translator(
    MODEL_PATH,
    device="cpu",
    inter_threads=1,
    intra_threads=4
)

tests = [
    ("EN -> OM", "om", "Thank you."),
    ("EN -> OM", "om", "How are you?"),
    ("EN -> OM", "om", "I need water."),
    ("EN -> OM", "om", "I want to learn Afaan Oromo."),
    ("EN -> OM", "om", "I am learning English."),
    ("EN -> OM", "om", "I will go to school tomorrow."),
    ("EN -> OM", "om", "I am going to school today."),
    ("EN -> OM", "om", "The teacher speaks Afaan Oromo."),
    ("EN -> OM", "om", "Please help me."),
    ("EN -> OM", "om", "I need food."),

    ("OM -> EN", "en", "Galatoomi."),
    ("OM -> EN", "en", "Akkam jirtu?"),
    ("OM -> EN", "en", "Ani bishaan nan barbaada."),
    ("OM -> EN", "en", "Ani Afaan Oromoo barachaa jira."),
    ("OM -> EN", "en", "Ani Afaan Ingilizii barachaa jira."),
    ("OM -> EN", "en", "Boru gara mana barumsaa nan deema."),
    ("OM -> EN", "en", "Har'a gara mana barumsaa nan deema."),
    ("OM -> EN", "en", "Barsiisaan koo Afaan Oromoo dubbata."),
    ("OM -> EN", "en", "Maaloo na gargaari."),
    ("OM -> EN", "en", "Ani nyaata nan barbaada."),
]

with open("madlad400_bidir_results.txt", "w", encoding="utf-8") as out:
    for direction, target, sentence in tests:
        tokens = tokenizer.encode(
            f"<2{target}> {sentence}",
            out_type=str
        )

        result = translator.translate_batch(
            [tokens],
            beam_size=1,
            max_batch_size=1,
            no_repeat_ngram_size=1,
            repetition_penalty=2.0
        )

        translated = tokenizer.decode(result[0].hypotheses[0])
        line = f"[{direction}] {sentence}\n  -> {translated}\n"
        print(line)
        out.write(line + "\n")

print("\nQorannoon xumurame.")
print("Bu'aan: C:\\Projects\\hiikaa\\madlad400_bidir_results.txt")
