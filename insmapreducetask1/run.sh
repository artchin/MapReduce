
#!/usr/bin/env bash

OUT_DIR=output_$(date +%Y%m%d_%H%M%S)
NUM_REDUCERS=4

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="Mixing IDs_Arthur_Chupakhin" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/ids \
    -output ${OUT_DIR} > /dev/null

hdfs dfs -cat ${OUT_DIR}/part-* | head -n 50


