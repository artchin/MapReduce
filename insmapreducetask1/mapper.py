#!/usr/bin/env python3

import sys
import random

for line in sys.stdin:
    id = line.strip()
    random_key = random.randint(0, 1000000)
    print(f"{random_key}\t{id}")
