import pandas as pd
import numpy as np
from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag

def nltk_pos_tagger(sentence):
    # Tokenize the sentence
    tokens = word_tokenize(sentence)
    # Apply statistical POS tagging
    statistical_tags = pos_tag(tokens)
    return statistical_tags
