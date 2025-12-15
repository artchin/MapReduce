#!/bin/bash

STREAMING_JAR="/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar"
INPUT_DATA="/data/wiki/en_articles" 
OUTPUT_JOB1="/user/$(whoami)/bigrams_counts"
OUTPUT_JOB2="/user/$(whoami)/bigrams_top10"

# Очистка предыдущих результатов
hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB1} 2>/dev/null
hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB2} 2>/dev/null

echo "=== Job 1: Подсчёт биграмм по документам ==="
hadoop jar ${STREAMING_JAR} \
    -D mapreduce.job.name="Bigrams Count" \
    -D mapreduce.job.reduces=8 \
    -input ${INPUT_DATA} \
    -output ${OUTPUT_JOB1} \
    -mapper mapper.py \
    -combiner reducer.py \
    -reducer reducer.py \
    -file mapper.py \
    -file reducer.py > /dev/null

echo "=== Job 2: Сортировка и выбор топ-10 ==="
hadoop jar ${STREAMING_JAR} \
    -D mapreduce.job.name="Bigrams Top10" \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options="-k1,1nr" \
    -input ${OUTPUT_JOB1} \
    -output ${OUTPUT_JOB2} \
    -mapper mapper2.py \
    -reducer reducer2.py \
    -file mapper2.py \
    -file reducer2.py > /dev/null

# Вывод результата
hdfs dfs -cat ${OUTPUT_JOB2}/part-*
