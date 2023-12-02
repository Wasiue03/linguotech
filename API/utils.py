# utils.py

import unicodedata
import re
import torch
from model import input_lang, EOS_token  # Make sure input_lang is defined in your model.py

SOS_token = 0
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)

MAX_LENGTH = 100
def unicodeToAscii(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn')

def normalizeString(s):
    s = unicodeToAscii(s.lower().strip())
    s = re.sub(r"([.!?])", r" \1", s)
    return s

def tensorFromSentence(lang, sentence):
    indexes = [lang.word2index[word] for word in sentence.split(' ')]
    indexes.append(EOS_token)  # Assuming you have EOS_token defined
    return torch.tensor(indexes, dtype=torch.long).view(-1, 1)


# Define the translateSentence function
def translateSentence(encoder, decoder, sentence):
  with torch.no_grad():
    input_tensor = tensorFromSentence(input_lang, sentence)
    input_length = input_tensor.size()[0]
    encoder_hidden = encoder.initHidden()

    encoder_outputs = torch.zeros(MAX_LENGTH, encoder.hidden_size, device=device)

    for ei in range(input_length):
      encoder_output, encoder_hidden = encoder(input_tensor[ei], encoder_hidden)
      encoder_outputs[ei] = encoder_output[0, 0]

    decoder_input = torch.tensor([[SOS_token]], device=device)  # SOS
    decoder_hidden = encoder_hidden

    translated_words = []
    for _ in range(MAX_LENGTH):
        decoder_output, decoder_hidden, _ = decoder(decoder_input, decoder_hidden, encoder_outputs)
        topv, topi = decoder_output.data.topk(1)
        if topi.item() == EOS_token:
            translated_words.append('<EOS>')
            break
        else:
            translated_words.append(output_lang.index2word[topi.item()])
        decoder_input = topi.squeeze().detach()

    translated_sentence = ' '.join(translated_words)
    return translated_sentence
#

