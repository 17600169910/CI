#!/bin/bash
# porter每次更新不应该变动的配置信息
# 以key=values格式写在数组内

# 固定不需要修改的配置内容以'key=values'格式写在数组里面
config=(
'redis.password=redispassword'
'elasticsearch.auth.enable=ELASTICSEARCH_AUTH_ENABLE'
'elasticsearch.username=ELASTICSEARCH_USERNAME'
'elasticsearch.password=ELASTICSEARCH_PASSWORD'
)
