from flask_cors import CORS
from flask import Flask, request, jsonify
import torch
from model import EncoderRNN, AttnDecoderRNN, hidden_size, output_lang, input_lang, translateSentence

app = Flask(__name__)

CORS(app, supports_credentials=True)

# @app.route('/')

# def hello_world():
#     return "Hello, World!"

CORS(app, supports_credentials=True, allow_headers=['Content-Type'])


device = torch.device("cpu")  

encoder1 = EncoderRNN(input_lang.n_words, hidden_size).to(device)
encoder1.load_state_dict(torch.load('D:\Project\API\encoder_model.pth', map_location=device))
encoder1.eval()

attn_decoder1 = AttnDecoderRNN(hidden_size, output_lang.n_words, dropout_p=0.1).to(device)
attn_decoder1.load_state_dict(torch.load('D:\Project\API\decoder_model.pth', map_location=device))
attn_decoder1.eval()

def translate_urdu_to_english(urdu_sentence):
    return translateSentence(encoder1, attn_decoder1, urdu_sentence)

@app.route("/translate", methods=["POST"])  # Specify the allowed HTTP methods
def translate():
    print(request.method)
    print(request.headers)
    print(request.get_data(as_text=True))
    if request.is_json:
        data = request.get_json()
        urdu_sentence = data.get('urdu_sentence', '')
        print(f"Received Urdu Sentence: {urdu_sentence}")
        translation_result = translate_urdu_to_english(urdu_sentence)
        return jsonify({'translation': translation_result})
    else:
        return jsonify({'error': 'Unsupported Media Type'}), 415
    

if __name__ == '__main__':
    app.run(debug=True)

