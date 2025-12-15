#!/usr/bin/env python3
import sys

current_bigram = None
count = 0 

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    
    try:
        bigram, doc_id = line.split('\t')
        cnt = int(cnt)
    except ValueError:
        continue
    
    if current_bigram == bigram:
        count += cnt 
    else:
        if current_bigram is not None:
            print(f"{current_bigram}\t{count}")
        
        current_bigram = bigram
        count = cnt

if current_bigram is not None:
    print(f"{current_bigram}\t{count}")

