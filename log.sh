#!/bin/bash
# 通用脚本用于生成日志并通过日志产生的标签进行迭代
# 2019-12-09
# Yintiecheng
#
work_dir=$(cd $(dirname $0);pwd)
log_file="/var/www/html/web/update/update.log"
nlu_log=/var/www/html/web/update/nlu_tag.log
edp_log=/var/www/html/web/update/edp_tag.log
publish_log=/var/www/html/web/update/publish_tag.log
product_log=/var/www/html/web/update/product-center_tag.log
porter_log=/var/www/html/web/update/porter_tag.log

function titel() {
if [ $# -ne 1 ];then
	echo -e "\033[31m Input parameters cannot be less than one！\033[0m"
	exit
fi
}

function log() {
#titel $*
# 截取关键字
input_srting=$*
# 取标签
string_tag_motify=$(echo ${input_srting##*=})
# 取名称
string=$(echo ${string_tag_motify%%:*})

if [[ ${string} == "edp" ]];then
	echo $input_srting >> ${edp_log}
elif [[ ${string} == "nlu" ]];then
	echo $input_srting >> ${nlu_log}
elif [[ ${string} == "publish" ]];then
	echo $input_srting >> ${publish_log}
elif [[ ${string} == "product-center" ]];then
	echo $input_srting >> ${product_log}
elif [[ ${string} == "porter" ]];then
	echo $input_srting >> ${porter_log}

else
	echo $input_srting >> ${log_file}

fi

}
log $*
