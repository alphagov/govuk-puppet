#!/usr/bin/env bash

cd /data/vhost/search.*/current
RACK_ENV=production bundle exec rake rummager:delete_all_indexes rummager:put_all_mappings

