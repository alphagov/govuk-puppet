#!/usr/bin/env python3

import argparse
import boto3
import logging


def create_elasticache_client():
  try:
    logging.info("getting elasticache client")
    client = boto3.client('elasticache')
    return client
  except Exception as e:
    logging.error("error occurred when getting elasticache client {}".format(e.message))
    raise

def get_redis_cluster_node_ids(elasticache_client):
  try:
    ec_description=elasticache_client.describe_cache_clusters(ShowCacheNodeInfo=True)
    redis_cluster_and_node_ids_dict={cluster['CacheClusterId']:[node['CacheNodeId'] for node in cluster['CacheNodes']] \
      for cluster in ec_description['CacheClusters'] if "redis" in cluster['Engine']}

    return redis_cluster_and_node_ids_dict
  except Exception as e:
    logging.error("error occurred when getting redis cluster IDs: {}".format(str(e)))
    raise

def reboot_redis_cluster(elasticache_client, redis_cluster_and_node_dict):
  try:
    for cluster_id, node_ids in redis_cluster_and_node_dict.items():
      logging.info("rebooting cluster id: {} with node list {}".format(cluster_id, node_ids))
      elasticache_client.reboot_cache_cluster(CacheClusterId=cluster_id, CacheNodeIdsToReboot=node_ids)
      logging.info("successfully rebooted cluster id: {} with node list {}".format(cluster_id, node_ids))
  except Exception as e:
    logging.error("error rebooting  redis clusters: {}".format(str(e)))
    raise

def configure_commandline():
  parser = argparse.ArgumentParser()
  parser.add_argument("--log", help="set the log level", default="WARNING")
  args = parser.parse_args()
  return args.log

def configure_logging(log_level):
  numeric_level = getattr(logging, log_level.upper(), None)
  if not isinstance(numeric_level, int):
    raise ValueError('Invalid log level: %s' % log_level)
  logging.basicConfig(level=numeric_level)

def main():
  elasticache_client=create_elasticache_client()
  redis_cluster_and_node_ids_dict=get_redis_cluster_node_ids(elasticache_client)
  reboot_redis_cluster(elasticache_client, redis_cluster_and_node_ids_dict)

if __name__ == "__main__":
    try:
        log_level=configure_commandline()
        configure_logging(log_level)
        main()
    except Exception as e:
        print("error occurred: {}", str(e))
