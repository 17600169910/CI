#!/bin/bash
# 通用老版本目录标准迭代
# 2019-12-12


work_dir=$(cd $(dirname $0);pwd)
# 通过传参来自动复制上一次服务版本迭代
function copy() {
cp -rf $Commd ${dir}/${DATE} >/dev/null 2>&1 && \
# 定义每次更新都需要删除tar目录
rm -rf ${dir}/${DATE}/tar >/dev/null 2>&1

retun=$?
	if [ $? -eq 0 ];then
           echo "$NEW"
        fi
}


function automatic() {

Commd=$(find $dir -maxdepth 1 -type d -name "[0-9]*[0-9]" |sort -nr |uniq |head -n 1)
DATE=$(date +%F)
NEW="${dir}/${DATE}"
if [ -d ${NEW} ];then
	while true
	do
	read -p "${NEW} 当天的目录已经存在了是否基于今天继续迭代 yes|no:" confirm
	if [[ ${confirm} == "yes" ]];then
		echo "${NEW}" && \
		break
	elif [[ ${confirm} == "no" ]];then
		read -p "请输入迭代版本号 YYYY-DD-MM 格式:" DATEI
		if [[ -z "${DATEI}" ]];then
			echo -e "\033[31m输入不能为空\033[0m"
			continue
		else
			# 匹配输入进来的格式
			Format="[0-9]\{1,4\}-[0-9]\{1,2\}-[0-9]\{1,2\}"
			Format_DirName=$(echo "${DATEI}" | grep -o ${Format})
			if [[ -z ${Format_DirName} ]];then
				echo -e "\033[31m ${DATEI} 输入错误，请输入YYYY-DD-MM格式:\033[0m"
				continue

			else
				DATE=${DATEI}
				NEW=${dir}/$DATE
				copy && break
			fi
		fi
	else
		continue
			
	fi
	done
else
	copy
fi

} 
function Big_Version() {

while :
do
if [[ ${2} == "3020" ]];then
        dir="/home/zy/1unicom/1edp/0docker/3020_version"
	automatic && break
elif [[ ${2} == "" ]];then
	automatih && break
else
	continue
fi
done

}

function main() {
case $1 in
	edp|EDP)
	dir="/home/zy/1unicom/1edp/0docker"
	#Big_Version $1 $2
	automatic
	;;
	publish)
	dir="/home/zy/1unicom/1edp/0docker"
#	Big_Version $1 $2
	automatic
	;;
	product-center)
	dir="/home/zy/1unicom/1edp/0docker"	
#	Big_Version $1 $2
	automatic
	;;
	porter)
	dir="/home/zy/1unicom/1edp/0docker"
	automatic
	;;
esac
}

main $1
