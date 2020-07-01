#!/bin/bash
# product_center每次更新不应该变动的配置文件
# 以key=values格式写在数组内

# 固定不需要修改的配置内容以key=values格式写在数组里面
config=(
'datasource.config.location=file:${application.workdir}/config/db_config_online.properties'
'redis.config.location=file:${application.workdir}/config/redis_config_online.properties'
)

# 'nlu.server.host=NLU_SERVER_HOST_VALUE'
# 'knowledgebase.url=KEOWLEDGEBASE_URL_VALUE'
# 'faq.in.url=FAQ_IN_URL_VAULE'
# 'kafka.producer.servers=KAFKA_PRODUCER_SERVERS_VALUE'
# 'kafka.authentication.enable=KAFKA_AUTHENTICATION_ENABLE_VALUE'
# 'pod.product.center.system.id=PRO_PRODUCT_CENTER_SYSTEM_ID_VALUE'
