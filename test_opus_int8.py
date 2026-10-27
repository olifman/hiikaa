import sys, json, time
import numpy as np
import onnxruntime as ort
from transformers import MarianTokenizer

sys.stdout.reconfigure(encoding="utf-8")
D = "models/opus-en-om-onnx/"
tok = MarianTokenizer.from_pretrained("models/opus_mt/en-om")
cfg = json.load(open(D + "config.json", encoding="utf-8"))
pad = cfg.get("pad_token_id", tok.pad_token_id)
start = cfg.get("decoder_start_token_id", pad)
eos = cfg.get("eos_token_id", tok.eos_token_id)

def load(suffix):
    p = ["CPUExecutionProvider"]
    return (ort.InferenceSession(D + "encoder_model" + suffix + ".onnx", providers=p),
            ort.InferenceSession(D + "decoder_model" + suffix + ".onnx", providers=p))

def translate(enc, dec, text, max_len=40):
    b = tok([text], return_tensors="np", padding=True)
    ids = b["input_ids"].astype(np.int64)
    mask = b["attention_mask"].astype(np.int64)
    efeed = {i.name: {"input_ids": ids, "attention_mask": mask}[i.name] for i in enc.get_inputs()}
    hs = enc.run(None, efeed)[0]
    out = [start]
    names = [i.name for i in dec.get_inputs()]
    for _ in range(max_len):
        feed = {}
        for n in names:
            if n == "input_ids":
                feed[n] = np.array([out], dtype=np.int64)
            elif n == "encoder_attention_mask":
                feed[n] = mask
            elif n == "encoder_hidden_states":
                feed[n] = hs
        logits = dec.run(None, feed)[0][0, -1].copy()
        logits[pad] = -1e9
        nxt = int(logits.argmax())
        if nxt == eos:
            break
        out.append(nxt)
    return tok.decode(out[1:], skip_special_tokens=True)

tests = [
    "Good morning", "Thank you very much", "How are you?",
    "What is your name?", "Where is the hospital?", "How much is this?",
    "I need help", "I am sick", "Where does it hurt?",
    "Please speak slowly", "I do not understand", "See you tomorrow",
]

lines = []
for label, suffix in [("FP32", ""), ("INT8", "_int8")]:
    enc, dec = load(suffix)
    print(label, "decoder inputs:", [i.name for i in dec.get_inputs()])
    lines.append("=== " + label + " ===")
    t0 = time.time()
    for t in tests:
        t1 = time.time()
        r = translate(enc, dec, t)
        lines.append("%s -> %s   (%.2fs)" % (t, r, time.time() - t1))
    lines.append("TOTAL %.1fs" % (time.time() - t0))
    lines.append("")

open("int8_test_results.txt", "w", encoding="utf-8").write("\n".join(lines))
print("\n".join(lines))
