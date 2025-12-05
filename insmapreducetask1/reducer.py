#!/usr/bin/env python3
import sys
import random

buffer = []
batch_size = random.randint (1, 5)

for line in sys.stdin:

    random_key, id = line.strip().split('\t', 1)
    buffer.append(id)

    if len(buffer) >= batch_size:
        print(', '.join(buffer))

        buffer = []
        batch_size = random.randint (1, 5)

if buffer:
    print(', '.join(buffer))