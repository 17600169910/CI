#!/bin/bash
# 自动解压新版本部署包
package_name="output.tar.gz"

# 下载包

function download_mode() {


while :
do
read -p "请输入output包下载链接:" URL
if [ -z "${URL}" ];then
        #echo -e "\033[31m 下载URL不能为空!\033[0m"
        continue
else
        break
fi
done
        cd ${download_dir} && \
        echo "$URL" |bash 
#|| exit && tar -xvf ${package_name} >/dev/null 2>&1 
	retun=$?
	if [ $retun -eq 0 ];then
		tar -xvf ${package_name} >/dev/null 2>&1
	else
		echo -e "\033[31m dowknload ${package_name} False!\033[0m"
		exit
	fi




}
function download_package() {
if [ ! -e ${download_dir}/${package_name} ];then
	download_mode
else
	while :
	do
	read -p "output.tar.gz 已经存在是否需要重新下载?\"yes|no\":" are_output
	if [[ ${are_output} == "yes" ]];then
		download_mode && break
	elif [[ ${are_output} == "no" ]];then
		break
	else
		continue
	fi
	done

fi
}


# 生成当天更新记录
function directory() {

if [ ! -d ${download_dir} ];then
	mkdir -p ${download_dir} && \
	download_package
else
	download_package

fi

}

# 解压模块通用
function A() {
sleep 2
tar -xvf ${download_dir}/output/${tar_name} -C ${target_name} >/dev/null 2>&1
}

# edp 标准解压
function unzip() {
directory && \
if [ ! -d ${output_name} ];then
	echo -e "${output_name} not find!\033[0m"
	directory
else
	cd ${download_dir} && \
	if [ ! -d ${target_name} ];then
		sleep 2
			mkdir -p ${target_name} && \
		A  && \
		echo ${target_name%/*}
	else
		A && \
		echo ${target_name%/*}

	fi 
	
fi
}

function main() {
case $1 in
	edp)
	DATE=$(date +%F)
#	edp 标准部署位置
	download_dir="/home/zy/1unicom/1edp/0docker/${DATE}/tar"
	output_name="${download_dir}/output"
	target_name="${download_dir}/edp/sds-dialogue-feedback"
        tar_name="sds-dialogue-feedback-*-application.tar.gz"
	unzip
	;;
	publish)
	DATE=$(date +%F)
#	publish 标准部署位置
	download_dir="/home/zy/1unicom/1edp/0docker/${DATE}/tar"
	output_name="${download_dir}/output"
	target_name="${download_dir}/publish/sds-publish"
        tar_name="sds-publish-*-SNAPSHOT-application.tar.gz"
	unzip
	;;
	product-center)
	DATE=$(date +%F)
#       product-center 标准部署位置
        download_dir="/home/zy/1unicom/1edp/0docker/${DATE}/tar"
        output_name="${download_dir}/output"
        target_name="${download_dir}/product-center/sds-product-center"
        tar_name="sds-product-center-*-SNAPSHOT-application.tar.gz"
        unzip
	;;
	porter)
	DATE=$(date +%F)
#       product-center 标准部署位置
        download_dir="/home/zy/1unicom/1edp/0docker/${DATE}/tar"
        output_name="${download_dir}/output"
        target_name="${download_dir}/porter/sds-porter"
        tar_name="sds-dialogue-porter-*-SNAPSHOT-application.tar.gz"
        unzip
esac	
}
#function main() {

#if [ $2 == 3020 ];then
#	download_dir="/home/zy/1unicom/1edp/0docker/3020_version/${DATE}/tar"
#	case_main $1
#else
#	download_dir="/home/zy/1unicom/1edp/0docker/${DATE}/tar"
#	case_main $1

#fi

#}

main $1
