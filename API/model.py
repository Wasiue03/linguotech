
import unicodedata
import string
import re
import random
import time
import math

import torch
import torch.nn as nn
from torch.autograd import Variable
from torch import optim
import torch.nn.functional as F



import unicodedata
import re
import random
import nltk

import pandas as pd


device = torch.device("cpu")  

# nltk.download('punkt')

import unicodedata
import re
import random

SOS_token = 0
EOS_token = 1
UNK_token = 2

class Lang:
    def __init__(self, name):
        self.name = name
        self.word2index = {}
        self.word2count = {}
        self.index2word = {0: "SOS", 1: "EOS", 2: "UNK"}  # Include UNK_token
        self.n_words = 3  # Count SOS, EOS, and UNK

    def addSentence(self, sentence):
        for word in sentence.split(' '):
            self.addWord(word)

    def addWord(self, word):
        if word not in self.word2index:
            self.word2index[word] = self.n_words
            self.word2count[word] = 1
            self.index2word[self.n_words] = word
            self.n_words += 1
        else:
            self.word2count[word] += 1





def unicodeToAscii(s):
    return ''.join(
        c for c in unicodedata.normalize('NFD', s)
        if unicodedata.category(c) != 'Mn'
    )

def normalizeString(s):
    s = unicodeToAscii(s.lower().strip())
    s = re.sub(r"([.!?])", r" \1", s)
    return s



def readLangs(file_path, reverse=False):
    print("Reading lines...")
    # Read the Excel file
    df = pd.read_excel('D:\Project\API\parallel-corpus.xlsx')

    # Trim leading and trailing whitespaces from column names
    df.columns = df.columns.str.strip()

    # Extract 'SENTENCES' and 'MEANING' columns from the dataframe
    lines_lang1 = df['SENTENCES'].astype(str).tolist()
    lines_lang2 = df['MEANING'].astype(str).tolist()

    # Combine lines from both columns into pairs
    pairs = [[normalizeString(lang1), normalizeString(lang2)] for lang1, lang2 in zip(lines_lang1, lines_lang2)]
    print(pairs)

    # Reverse pairs, make Lang instances
    if reverse:
        pairs = [list(reversed(p)) for p in pairs]
        input_lang = Lang("Urdu")  # Replace "Urdu" with the appropriate language name
        output_lang = Lang("English")  # Replace "English" with the appropriate language name
    else:
        input_lang = Lang("English")  # Replace "English" with the appropriate language name
        output_lang = Lang("Urdu")  # Replace "Urdu" with the appropriate language name

    return input_lang, output_lang, pairs




# Download NLTK resources (if not already downloaded)
# nltk.download('punkt')

# Tokenize English sentences into words
def tokenize_english(sentence):
    return nltk.word_tokenize(sentence)

# Tokenize Urdu sentences into words
def tokenize_urdu(sentence):
    return nltk.word_tokenize(sentence)

# Read the Excel file
df = pd.read_excel('D:\Project\API\parallel-corpus.xlsx')

# Trim leading and trailing whitespaces from column names
df.columns = df.columns.str.strip()

# Extract 'SENTENCES' and 'MEANING' columns from the dataframe
lines_lang1 = df['SENTENCES'].astype(str).tolist()
lines_lang2 = df['MEANING'].astype(str).tolist()

# Tokenize English sentences
tokenized_english = [tokenize_english(sentence) for sentence in lines_lang1]

# Tokenize Urdu sentences
tokenized_urdu = [tokenize_urdu(sentence) for sentence in lines_lang2]

# # Display the tokenized sentences
# print("Tokenized English Sentences:", tokenized_english)
# print("Tokenized Urdu Sentences:", tokenized_urdu)



# # Display the tokenized sentences
# print("Tokenized English Sentences:")
# for sentence in tokenized_english:
#     print(sentence)

# print("\nTokenized Urdu Sentences:")
# for sentence in tokenized_urdu:
#     print(sentence)


# # Download NLTK resources (if not already downloaded)
# nltk.download('punkt')
# nltk.download('stopwords')

# # Function to read stop words from a file
# def read_stopwords(file_path):
#     with open(file_path, 'r', encoding='utf-8') as file:
#         stopwords = set(word.strip() for word in file)
#     return stopwords

# # Print English stop words
# english_stopwords = set(nltk.corpus.stopwords.words('english'))
# print("English Stop Words:")
# print(english_stopwords)

# # Print Urdu stop words
# urdu_stopwords_path = '/content/urdu_stopwords (1).txt'  # Adjust the file path accordingly
# urdu_stopwords = read_stopwords(urdu_stopwords_path)
# print("\nUrdu Stop Words:")
# print(urdu_stopwords)


MAX_LENGTH = 100

def filterPair(p):
    return len(p[0].split(' ')) < MAX_LENGTH and len(p[1].split(' ')) < MAX_LENGTH

def filterPairs(pairs):
    return [pair for pair in pairs if filterPair(pair)]

def prepareData(data_frame, reverse=False):
    lines_lang1 = data_frame['SENTENCES'].astype(str).tolist()
    lines_lang2 = data_frame['MEANING'].astype(str).tolist()

    pairs = [[normalizeString(lang1), normalizeString(lang2)] for lang1, lang2 in zip(lines_lang1, lines_lang2)]

    if reverse:
        pairs = [list(reversed(p)) for p in pairs]
        input_lang = Lang("Urdu")  # Replace "Urdu" with the appropriate language name
        output_lang = Lang("English")  # Replace "English" with the appropriate language name
    else:
        input_lang = Lang("English")  # Replace "English" with the appropriate language name
        output_lang = Lang("Urdu")  # Replace "Urdu" with the appropriate language name

    print("Read %s sentence pairs" % len(pairs))
    pairs = filterPairs(pairs)
    print("Trimmed to %s sentence pairs" % len(pairs))

    print("Counting words...")
    for pair in pairs:
        input_lang.addSentence(pair[0])
        output_lang.addSentence(pair[1])

    print("Counted words:")
    print(input_lang.name, input_lang.n_words)
    print(output_lang.name, output_lang.n_words)

    return input_lang, output_lang, pairs

# Assuming 'df' is your DataFrame
input_lang, output_lang, pairs = prepareData(df, True)
print(random.choice(pairs))


import torch
import torch.nn as nn
import torch.nn.functional as F


# Change this to "cuda" if you want to use CUDA

class EncoderRNN(nn.Module):
    def __init__(self, input_size, hidden_size):
        super(EncoderRNN, self).__init__()
        self.hidden_size = hidden_size
        self.embedding = nn.Embedding(input_size, hidden_size)
        self.gru = nn.GRU(hidden_size, hidden_size)

    def forward(self, input, hidden):
        embedded = self.embedding(input).view(1, 1, -1)
        output, hidden = self.gru(embedded, hidden)
        return output, hidden

    def initHidden(self):
        return torch.zeros(1, 1, self.hidden_size, device=device)


class DecoderRNN(nn.Module):
    def __init__(self, hidden_size, output_size):
        super(DecoderRNN, self).__init__()
        self.hidden_size = hidden_size

        self.embedding = nn.Embedding(output_size, hidden_size)
        self.gru = nn.GRU(hidden_size, hidden_size)
        self.out = nn.Linear(hidden_size, output_size)
        self.softmax = nn.LogSoftmax(dim=1)

    def forward(self, input, hidden):
        output = self.embedding(input).view(1, 1, -1)
        output = F.relu(output)
        output, hidden = self.gru(output, hidden)
        output = self.softmax(self.out(output[0]))
        return output, hidden

    def initHidden(self):
        return torch.zeros(1, 1, self.hidden_size, device=device)


class AttnDecoderRNN(nn.Module):
    def __init__(self, hidden_size, output_size, dropout_p=0.1, max_length=MAX_LENGTH):
        super(AttnDecoderRNN, self).__init__()
        self.hidden_size = hidden_size
        self.output_size = output_size
        self.dropout_p = dropout_p
        self.max_length = max_length

        self.embedding = nn.Embedding(self.output_size, self.hidden_size)
        self.attn = nn.Linear(self.hidden_size * 2, self.max_length)
        self.attn_combine = nn.Linear(self.hidden_size * 2, self.hidden_size)
        self.dropout = nn.Dropout(self.dropout_p)
        self.gru = nn.GRU(self.hidden_size, self.hidden_size)
        self.out = nn.Linear(self.hidden_size, self.output_size)

    def forward(self, input, hidden, encoder_outputs):
        embedded = self.embedding(input).view(1, 1, -1)
        embedded = self.dropout(embedded)

        attn_weights = F.softmax(
            self.attn(torch.cat((embedded[0], hidden[0]), 1)), dim=1)
        attn_applied = torch.bmm(attn_weights.unsqueeze(0),
                                 encoder_outputs.unsqueeze(0))

        output = torch.cat((embedded[0], attn_applied[0]), 1)
        output = self.attn_combine(output).unsqueeze(0)

        output = F.relu(output)
        output, hidden = self.gru(output, hidden)

        output = F.log_softmax(self.out(output[0]), dim=1)
        return output, hidden, attn_weights

    def initHidden(self):
        return torch.zeros(1, 1, self.hidden_size, device=device)




def indexesFromSentence(lang, sentence):
    return [lang.word2index[word] for word in sentence.split(' ')]


def tensorFromSentence(lang, sentence):
    indexes = indexesFromSentence(lang, sentence)
    indexes.append(EOS_token)
    return torch.tensor(indexes, dtype=torch.long, device=device).view(-1, 1)


def tensorsFromPair(pair):
    input_tensor = tensorFromSentence(input_lang, pair[0]).to(device)
    target_tensor = tensorFromSentence(output_lang, pair[1]).to(device)
    return (input_tensor, target_tensor)








teacher_forcing_ratio = 0.5
def train(input_pair, target_pair, encoder, decoder, encoder_optimizer, decoder_optimizer, criterion, max_length=MAX_LENGTH):
    input_tensor, target_tensor = input_pair.to(device), target_pair.to(device)
    encoder_hidden = encoder.initHidden()

    encoder_optimizer.zero_grad()
    decoder_optimizer.zero_grad()

    input_length = input_tensor.size(0)
    target_length = target_tensor.size(0)

    encoder_outputs = torch.zeros(max_length, encoder.hidden_size, device=device)

    loss = 0

    for ei in range(input_length):
        encoder_output, encoder_hidden = encoder(
            input_tensor[ei], encoder_hidden)
        encoder_outputs[ei] = encoder_output[0, 0]

    decoder_input = torch.tensor([[SOS_token]], device=device)

    decoder_hidden = encoder_hidden

    use_teacher_forcing = True if random.random() < teacher_forcing_ratio else False

    if use_teacher_forcing:
        # Teacher forcing: Feed the target as the next input
        for di in range(target_length):
            decoder_output, decoder_hidden, decoder_attention = decoder(
                decoder_input, decoder_hidden, encoder_outputs)
            loss += criterion(decoder_output, target_tensor[di])
            decoder_input = target_tensor[di].unsqueeze(0)  # Teacher forcing

    else:
        # Without teacher forcing: use its own predictions as the next input
        for di in range(target_length):
            decoder_output, decoder_hidden, decoder_attention = decoder(
                decoder_input, decoder_hidden, encoder_outputs)
            topv, topi = decoder_output.topk(1)
            decoder_input = topi.squeeze().detach().to(device)  # detach from history as input

            loss += criterion(decoder_output, target_tensor[di])
            if decoder_input.item() == EOS_token:
                break

    loss.backward()

    encoder_optimizer.step()
    decoder_optimizer.step()

    return loss.item() / target_length


def test(input_tensor, target_tensor, encoder, decoder, criterion):
    # Set the model to evaluation mode
    encoder.eval()
    decoder.eval()

    input_length = input_tensor.size(0)
    target_length = target_tensor.size(0)

    encoder_hidden = encoder.initHidden()
    encoder_outputs = torch.zeros(MAX_LENGTH, encoder.hidden_size, device=device)

    loss = 0

    with torch.no_grad():  # Disable gradient tracking during testing
        for ei in range(input_length):
            encoder_output, encoder_hidden = encoder(
                input_tensor[ei], encoder_hidden)
            encoder_outputs[ei] = encoder_output[0, 0]

        decoder_input = torch.tensor([[SOS_token]], device=device)
        decoder_hidden = encoder_hidden

        for di in range(target_length):
            decoder_output, decoder_hidden, _ = decoder(
                decoder_input, decoder_hidden, encoder_outputs)
            loss += criterion(decoder_output, target_tensor[di])

            topv, topi = decoder_output.topk(1)
            decoder_input = topi.squeeze().detach()

            if decoder_input.item() == EOS_token:
                break

    return loss.item() / target_length


import time
import math


def asMinutes(s):
    m = math.floor(s / 60)
    s -= m * 60
    return '%dm %ds' % (m, s)


def timeSince(since, percent):
    now = time.time()
    s = now - since
    es = s / (percent)
    rs = es - s
    return '%s (- %s)' % (asMinutes(s), asMinutes(rs))

def trainIters(encoder, decoder, n_iters, print_every=1000, plot_every=100, learning_rate=0.001):
    start = time.time()
    plot_losses = []
    print_loss_total = 0  # Reset every print_every
    plot_loss_total = 0  # Reset every plot_every

    encoder_optimizer = optim.SGD(encoder.parameters(), lr=learning_rate)
    decoder_optimizer = optim.SGD(decoder.parameters(), lr=learning_rate)
    training_pairs = [tensorsFromPair(random.choice(pairs))
                      for i in range(n_iters)]
    criterion = nn.NLLLoss()

    for iter in range(1, n_iters + 1):
        training_pair = training_pairs[iter - 1]
        input_tensor = training_pair[0]
        target_tensor = training_pair[1]

        loss = train(input_tensor, target_tensor, encoder,
                     decoder, encoder_optimizer, decoder_optimizer, criterion)
        print_loss_total += loss
        plot_loss_total += loss

        if iter % print_every == 0:
            print_loss_avg = print_loss_total / print_every
            print_loss_total = 0
            print('%s (%d %d%%) %.4f' % (timeSince(start, iter / n_iters),
                                         iter, iter / n_iters * 100, print_loss_avg))

        if iter % plot_every == 0:
            plot_loss_avg = plot_loss_total / plot_every
            plot_losses.append(plot_loss_avg)
            plot_loss_total = 0

    



# ... (Previous code for trainIters, data preparation, model definition, etc.) ...

# Define a test function

def testIters(encoder, decoder, test_input_tensors, test_target_tensors, criterion):
    total_loss = 0
    num_batches = len(test_input_tensors)

    for batch_idx in range(num_batches):
        input_tensor = test_input_tensors[batch_idx]
        target_tensor = test_target_tensors[batch_idx]

        loss = test(input_tensor, target_tensor, encoder, decoder, criterion)
        total_loss += loss

    average_loss = total_loss / num_batches
    return average_loss






def evaluate(encoder, decoder, sentence, max_length=MAX_LENGTH):
    with torch.no_grad():
        input_tensor = tensorFromSentence(input_lang, sentence)
        input_length = input_tensor.size()[0]
        encoder_hidden = encoder.initHidden()

        encoder_outputs = torch.zeros(max_length, encoder.hidden_size, device=device)

        for ei in range(input_length):
            encoder_output, encoder_hidden = encoder(input_tensor[ei],
                                                     encoder_hidden)
            encoder_outputs[ei] += encoder_output[0, 0]

        decoder_input = torch.tensor([[SOS_token]], device=device)  # SOS

        decoder_hidden = encoder_hidden

        decoded_words = []
        decoder_attentions = torch.zeros(max_length, max_length)

        for di in range(max_length):
            decoder_output, decoder_hidden, decoder_attention = decoder(
                decoder_input, decoder_hidden, encoder_outputs)
            decoder_attentions[di] = decoder_attention.data
            topv, topi = decoder_output.data.topk(1)
            if topi.item() == EOS_token:
                decoded_words.append('<EOS>')
                break
            else:
                decoded_words.append(output_lang.index2word[topi.item()])

            decoder_input = topi.squeeze().detach()

        return decoded_words, decoder_attentions[:di + 1]

def evaluateRandomly(encoder, decoder, n=10):
  for i in range(n):
    pair = random.choice(pairs)
    print('>', pair[0])
    print('=', pair[1])
    output_words, attentions = evaluate(encoder, decoder, pair[0])
    output_sentence = ' '.join(output_words)
    print('<', output_sentence)
    print('')

hidden_size = 256


# encoder1 = EncoderRNN(input_lang.n_words, hidden_size).to(device)
# attn_decoder1 = AttnDecoderRNN(hidden_size, output_lang.n_words, dropout_p=0.1).to(device)

# # Train the model
# trainIters(encoder1, attn_decoder1, 30000, print_every=5000)


# # Save encoder and decoder models
# torch.save(encoder1.state_dict(), 'encoder_model.pth')
# torch.save(attn_decoder1.state_dict(), 'decoder_model.pth')









#

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

# # Save the entire model
# torch.save({
#     'encoder_state_dict': encoder1.state_dict(),
#     'decoder_state_dict': attn_decoder1.state_dict(),
#     'input_lang': input_lang,
#     'output_lang': output_lang,
#     'hidden_size': hidden_size,
# }, 'entire_model.pth')









