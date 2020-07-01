#!/bin/bash
# 全国联通自动化构建服务镜像
# 包括替换主配置文件，build镜像
# 2019-12-07
# Yintiecheng


work_dir=$(cd $(dirname $0);pwd)

function parameter() {

A=true

while $A
do

	if [[ -z ${action} ]];then
	
		echo -e "\033[31m Type parameters != [edp|nlu|product-center|publish|porter]\033[0m"
		read -p "输入要自动化构建的任务[edp|nlu|product-center|publish|porter]:" action
		continue
	else
		A=false

	fi
done

}


function menu(){

read -p "输入要自动化构建的任务[edp|nlu|product-center|publish|porter]:" action
parameter

case $action in
	edp)
	source ${work_dir}/edp.sh ${action}
	;;
	nlu)
	source ${work_dir}/nlu.sh
	;;
        product-center)
	source ${work_dir}/product-center.sh ${action}
	;;
	publish)
	source ${work_dir}/publish.sh ${action}
	;;
	porter)
	source ${work_dir}/porter.sh ${action}
	;;
	*)
	echo -e "\033[31m $0: Input [edp|nlu|porter|product-center|publish]\033[0m"
	exit
esac

}
menu
