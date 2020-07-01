#!/bin/bash
# 用于自动版本迭代docker镜像版本
# 2019-12-10
# Yin

# 运算
function sum() {

if [[ -z ${new_tag} ]];then
	last_tag=$(awk -F= 'END{print $NF}' ${log_name} |cut -d ':' -f 2)
	BBB=${last_tag##*.}
	CCC=${last_tag%.*}
	iteration_tag=$(echo "${Start_Sum} ${BBB}" |awk '{print ($1+$2)}')
	if [ ${iteration_tag} -gt 100 ];then
	   # 定义初始值
	   sum=1
           BBBb=${CCC#*.}
           DDDc=${CCC%.*}
           new_label=$(echo ${sum} ${BBBb} |awk '{print $1+$2}')
	   name_tag="${input_dockerTag}:${DDDc}.${new_label}.${sum}"
           echo ${name_tag}
        else
	name_tag="${input_dockerTag}:${CCC}.${iteration_tag}"
	echo ${name_tag}
	fi
else
	iteration_tag=${new_tag}
	name_tag="${input_dockerTag}:${iteration_tag}"
	echo ${name_tag}
fi

}

# 该模块用于当对应的镜像标签日志不存在时，必须手动生成一个
function Notlogfile() {

if [ ! -f ${log_name} ];then
	while true
	do
	read -p "对应${input_dockerTag}日志文件不存在，您必须手动给予一个标签生成日志例如[edp:1.1]:" newTag
		# 判断输入的是否为数值
		new_name=${newTag%%:*}
		new_tag=${newTag##*:}
		echo "1 ${new_tag}"|awk '{print ($1/$2)}' >/dev/null 2>&1
		if [ $? -ne 0 ];then
			echo -e "\033[31m ${newTage}错误,请输入正确的标签例"edp:1.1"\033[0m"
			continue
		else
			echo "2019-12-09 A docker version was iterated=${newTag}" >> ${log_name}
			# 实际镜像自动迭代+0.1
			sleep 2
			sum
			break
		fi
	done
else
	sum
fi

}


function tag() {
# 通过字符传参获取对应的服务版本
input_dockerTag=$(echo ${1%%:*})

# 版本迭代 对应标签+0.1
Start_Sum=1
if [ ${input_dockerTag} == "edp" ];then
        log_name="/var/www/html/web/update/edp_tag.log"
	Notlogfile
elif [ ${input_dockerTag} == "nlu" ];then
	log_name="/var/www/html/web/update/nlu_tag.log"
	Notlogfile
elif [ ${input_dockerTag} == "publish" ];then
	log_name="/var/www/html/web/update/publish_tag.log"
	Notlogfile	
elif [ ${input_dockerTag} == "product-center" ];then
	log_name="/var/www/html/web/update/product-center_tag.log"
	Notlogfile
elif [ ${input_dockerTag} == "porter" ];then
	log_name="/var/www/html/web/update/porter_tag.log"
        Notlogfile
else
	# 如果都不满足，那么说明非标准镜像构建 或者第一次进行构建
	name_tag=""
        # 调用build镜像脚本
	echo ${name_tag}
fi

}
tag $1
