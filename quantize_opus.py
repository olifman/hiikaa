from onnxruntime.quantization import quantize_dynamic, QuantType
import os
d = "models/opus-en-om-onnx/"
for n in ["encoder_model", "decoder_model"]:
    quantize_dynamic(d + n + ".onnx", d + n + "_int8.onnx", weight_type=QuantType.QInt8)
    print(n, round(os.path.getsize(d + n + "_int8.onnx") / 1e6, 1), "MB")
