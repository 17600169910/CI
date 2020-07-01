#!/bin/bash
# edp每次更新不应该变动的配置信息
# 以key=values格式写在数组内

# 固定不需要修改的配置内容以'key=values'格式写在数组里面
config=(
'redis.config.location=file:${application.workdir}/config/redis_config_online.properties'
'datasource.config.location=file:${application.workdir}/config/feedback_db_config_online.properties'
'train.platform.propfile=file:${application.workdir}/config/train-platform_xkfonline.properties'
'train.master.propfile=file:${application.workdir}/config/train_master_xkfonline.properties'
'elasticsearch.auth.enable=ELASTICSEARCH_AUTH_ENABLE'
'elasticsearch.username=ELASTICSEARCH_USERNAME'
'elasticsearch.password=ELASTICSEARCH_PASSWORD'
)

