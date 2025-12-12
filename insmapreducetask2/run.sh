#!/bin/bash

STREAMING_JAR="/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar"
INPUT_DATA="/data/wiki/en_articles" 
OUTPUT_JOB="/user/$(whoami)/bigrams_counts"

hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB} 2>/dev/null

echo "=== Запуск Job 1: Подсчёт биграмм по документам ==="
hadoop jar ${STREAMING_JAR} \
    -D mapreduce.job.name="Bigrams Count" \
    -D mapreduce.job.reduces=1 \
    -input ${INPUT_DATA} \
    -output ${OUTPUT_JOB} \
    -mapper mapper.py \
    -reducer reducer.py \
    -file mapper.py \
    -file reducer.py > /dev/null


hdfs dfs -cat /user/$(whoami)/bigrams_counts/part-* | \
    sort -t$'\t' -k2 -rn | \
    head -10 | \
    awk '{print $1, $2, $3}'
