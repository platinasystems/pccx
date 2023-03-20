#!/usr/bin/env bash

export SUMMARY_RETENTION="${KAFKA_SUMMARY_RETENTION_MS:-120000}"

function create_topic {
  echo "Creating the topic $1. Retention is $2 ms"
  /opt/landoop/kafka/bin/kafka-topics --zookeeper 127.0.0.1:2181 --create --topic $1 --replication-factor 1 --partitions 1
  /opt/landoop/kafka/bin/kafka-topics --zookeeper 127.0.0.1:2181 --alter --topic $1 --config retention.ms=$2
}

create_topic summary $SUMMARY_RETENTION
