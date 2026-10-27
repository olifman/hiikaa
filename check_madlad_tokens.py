from sentencepiece import SentencePieceProcessor

path = r"C:\Projects\hiikaa\models\madlad400-ct2-test\sentencepiece.model"
sp = SentencePieceProcessor()
sp.load(path)

for code in ["en", "om"]:
    tag = f"<2{code}>"
    tokens = sp.encode(tag + " Hello", out_type=str)
    print(f"\nAfaan: {code}")
    print("Token barbaadame:", tag)
    print("Tokenization:", tokens)
    print("Token jalqabaa sirrii dha:", tokens[0] == tag)
