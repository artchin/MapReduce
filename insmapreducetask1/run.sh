#!/usr/bin/env bash

OUT_DIR=/user/instruments2025a07/output
NUM_REDUCERS=8

hdfs dfs -rm -r -skipTrash ${OUT_DIR} 

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="Mixing IDs_Arthur_Chupakhin" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/ids \
    -output ${OUT_DIR} 2>&1

hdfs dfs -cat ${OUT_DIR}/part-* | head -n 50
