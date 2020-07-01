#!/bin/bash
# publish每次更新不应该变动的配置文件
# 以key=values格式写在数组内

# 固定不需要修改的配置内容以key=values格式写在数组里面
config=(
'datasource.config.location=file:/home/work/opdir/deploy_temp/sds-publish/sds-publish/config/db_config.properties'
'redis.config.location=file:/home/work/opdir/deploy_temp/sds-publish/sds-publish/config/redis_config.properties'
'k8s.service.account=prodnewcs'
'docker.market.username=zbnewcs_ai'
'docker.market.password=Xkf@123wsx'
'docker.market.address=10.172.49.246'
'k8s.client.master.url=http://10.172.54.178:9000'
'k8s.default.namespace.name=prodnewcs'
'k8s.client.master.auth.token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJwcm9kbmV3Y3MiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoibmV3Y3MtZGFzaGJvYXJkLXRva2VuLXZ3bGRmIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Im5ld2NzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjNiM2RiNjMyLWM3ZDktMTFlOS1iZjQyLTZjOTJiZmNjZWVhNSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpwcm9kbmV3Y3M6bmV3Y3MtZGFzaGJvYXJkIn0.zF8PIEg-6M3_eNkSPU4GfRghkbvHX3mxKgpNrKSlG0nbaYFeuCR1v6YwP5fJa7rBfE2tpTtD_NpyzLSCjaOCB5nM4weaK3AqqETtlQG9MKGyyQdIIIQRJMsABKKzQ_WYPEcLpeUznxzYCcK6a6BR45ENHsqh_mdZcTPCm-DWRbsPpYUr-7wwIgwpCiwgAC5SrVNwctfxE-4DKca02z9980yZ2CfUNev_OI2p3h5IqZAB84jf5FnFqk_rJs6f3_hLbzKlp5pH8-eI7exEr4corU_Dtav4sEHp_yOBPIO20GVJ0KL_Q2J-b6t2AtggGDYRiaKY0GuGLEMcFtgHo4SDXQ'
'easypack.ip=10.172.50.103'
'k8s.deploy.namespace.name=prodnewcs'
'k8s.access.domain.url=http://10.172.54.170:30080'
'default.ingress.namespace=prodnewcs'
'kafka.user=xkf_ai_record'
'kafka.password=ai\$Xkf8d'
'elasticsearch.auth.enable=ELASTICSEARCH_AUTH_ENABLE'
'elasticsearch.username=ELASTICSEARCH_USERNAME'
'elasticsearch.password=ELASTICSEARCH_PASSWORD'
)
