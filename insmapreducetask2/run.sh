#!/bin/bash

STREAMING_JAR="/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar"
INPUT_DATA="/data/wiki/en_articles" 
OUTPUT_JOB1="/user/$(whoami)/bigrams_counts"
OUTPUT_JOB2="/user/$(whoami)/bigrams_top10"

hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB1} >/dev/null
hdfs dfs -rm -r -skipTrash ${OUTPUT_JOB2} >/dev/null

hadoop jar ${STREAMING_JAR} \
    -D mapreduce.job.name="Bigrams Count" \
    -D mapreduce.job.reduces=8 \
    -input ${INPUT_DATA} \
    -output ${OUTPUT_JOB1} \
    -mapper mapper.py \
    -reducer reducer.py \
    -file mapper.py \
    -file reducer.py > /dev/null

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

hdfs dfs -cat ${OUTPUT_JOB2}/part-*
