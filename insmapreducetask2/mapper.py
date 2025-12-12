#!/usr/bin/env python3

import sys
import re


def clean_text(text):
    text = re.sub(r'[^A-Za-z\s]', '', text)
    text = text.lower()
    return text


def get_bigrams(words):
    bigrams = []
    for i in range(len(words) - 1):
        bigram = f"{words[i]} {words[i+1]}"
        bigrams.append(bigram)
    return bigrams


for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    parts = line.split('\t', 1)

    if len(parts) == 2:
        current_doc_id = parts[0]
        text = parts[1]
    else:
        if current_doc_id is None:
            continue
        text = parts[0]

    cleaned = clean_text(text)    
    words = cleaned.split()
        
    if len(words) < 2:
        continue
        
    bigrams = get_bigrams(words)
        
    unique_bigrams = set(bigrams)
        
    for bigram in unique_bigrams:
        print(f"{bigram}\t{current_doc_id}")
