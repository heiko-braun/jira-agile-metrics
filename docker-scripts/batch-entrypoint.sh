#!/bin/bash

echo "Processing all .yml and .yaml files in /config"
for config in $(ls /config/*) ; do
    filename=$(basename -- "$config")

    extension="${filename##*.}"
    filename="${filename%.*}"
    output="/data/output/${filename}"

    extension="$(echo ${extension} | tr '[:upper:]' '[:lower:]')"

    if [ "${extension}" == "yml" ] || [ "${extension}" == "yaml" ] ; then
        mkdir -p ${output}
        rm ${output}/*
        jira-agile-metrics -vv --output-directory ${output} $@ ${config} --username "$JIRA_USER" --password "$JIRA_PASS" 2>&1 | tee ${output}/metrics.log
    fi
done