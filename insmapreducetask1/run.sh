#!/usr/bin/env bash

OUT_DIR=/user/instruments2025a007/output
NUM_REDUCERS=8

hdfs dfs -rm -r -skipTrash ${OUT_DIR} > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="Mixing IDs_Arthur_Chupakhin" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/ids \
    -output ${OUT_DIR} 

hdfs dfs -cat ${OUT_DIR}/part-00000 | head -n 50
