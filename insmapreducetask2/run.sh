#!/bin/bash

STREAMING_JAR="/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar"

# Входные и выходные директории
INPUT_DATA="/data/wiki/en_articles_part"  # Используем семпл, для полных данных: /data/wiki/en_articles
OUTPUT_JOB1="/user/$(whoami)/bigrams_counts"

# Удаляем выходные директории если они существуют
hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB1} 2>/dev/null
hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB2} 2>/dev/null

echo "=== Запуск Job 1: Подсчёт биграмм по документам ==="
hadoop jar ${STREAMING_JAR} \
    -D mapreduce.job.name="Bigrams Count" \
    -D mapreduce.job.reduces=1 \
    -input ${INPUT_DATA} \
    -output ${OUTPUT_JOB1} \
    -mapper mapper.py \
    -reducer reducer.py \
    -file mapper.py \
    -file reducer.py

if [ $? -ne 0 ]; then
    echo "Ошибка в Job 1"
    exit 1
fi

echo "=== Job 1 завершён успешно ==="
echo ""

hdfs dfs -cat /user/$(whoami)/bigrams_counts/part-* | \
    sort -t$'\t' -k2 -rn | \
    head -10 | \
    awk '{print $1, $2, $3}'
