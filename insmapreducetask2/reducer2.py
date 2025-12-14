#!/usr/bin/env python3
"""
Reducer для второй джобы: выводит только первые 10 записей.
Вход: count\tbigram (уже отсортировано Hadoop по убыванию count)
Выход: bigram\tcount
"""
import sys

TOP_N = 10
counter = 0

for line in sys.stdin:
    if counter >= TOP_N:
        break
        
    line = line.strip()
    if not line:
        continue
    
    try:
        count, bigram = line.split('\t', 1)
        print(f"{bigram}\t{count}")
        counter += 1
    except ValueError:
        continue