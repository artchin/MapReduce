#!/usr/bin/env python3
import sys

current_bigram = None
doc_ids = set()

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    
    try:
        bigram, doc_id = line.split('\t')
    except ValueError:
        continue
    
    if current_bigram == bigram:
        doc_ids.add(doc_id)
    else:
        if current_bigram is not None:
            count = len(doc_ids)
            print(f"{current_bigram}\t{count}")
        
        current_bigram = bigram
        doc_ids = set([doc_id])

if current_bigram is not None:
    count = len(doc_ids)
    print(f"{current_bigram}\t{count}")
