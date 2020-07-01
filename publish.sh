#!/bin/bash
# publish 自动化构建docker image
# 2019-12-07
# Yintiecheng

work_dir=$(cd $(dirname $0);pwd)
docker_build="${work_dir}/docker_build.sh"
# 是否开启固定配置文件修改 true开启 false关闭
fixed_enabled=true
fixed_edp=${work_dir}/fixed_config/publish_fixed_config.sh
fixed_shell=${work_dir}/fixed_config.sh
config_name=${old_publish_name}
md5_file=${work_dir}/md5.sh
# 替换指定内容，在补丁合成完毕之后
function fixed_config() {

A=$old_publish_name

if [ -f ${fixed_shell} ];then
        source ${fixed_shell} $A
else
        echo -e "\033[31m ${fixed_shell} Shell Not Find!\033[0m"
        exit
fi

}


function copy_mode() {

if [ ! -f ${update_file_name} ];then

	echo -e "\033[31m file ${update_file_name} There is no!\033[0m"
	exit
else
      echo -e "\033[32m backup ${update_file_name} to ${update_file_dir}\033[0m"
        sleep 3
        \cp -rf ${update_file_name} ${update_file_dir}
fi

}

# 该模块是因为publish/sds-publish/bin/update_config不能删除所以先进行备份
function update_file() {

update_file_dir="/tmp/publish_$(date +%F)"
update_file_name="${old_package}/publish/sds-publish/bin/update_config"
if [ ! -d ${update_file_dir} ];then

	mkdir -p "${update_file_dir}"
	copy_mode
else
	copy_mode
fi

}


function motify_config() {

old_publish_dir="${old_package}/publish/sds-publish/config/bak"
old_publish_name="${old_publish_dir}/application-online.properties"
new_publish_dir="${new_package}/sds-publish/config"
new_publish_name="${new_publish_dir}/application-xkfonline.properties"
# 补丁文件存放位置
patch_file="$update_file_dir/publish_patch"

if [ ! -f ${old_publish_name} ];then
	echo -e "\033[31m old file ${old_publish_name} There is no!\033[0m"
	exit
else
	if [ ! -f ${new_publish_name} ];then
	echo -e "\033[31m new file ${new_publish_name} There is no!\033[0m"
	exit
	else
	# 生成补丁
	/usr/bin/diff -u ${old_publish_name} ${new_publish_name} >${patch_file}
	echo -e "\033[32m patch file ${patch_file} \033[0m"
	sleep 3
	echo -e "\033[32m Composes the master configuration file: ${old_publish_name} \033[0m"
	sleep 3
	/usr/bin/patch -b ${old_publish_name} ${patch_file} && \
        fixed_config && \
	\cp -rf ${old_publish_name} ${old_publish_dir}/application.properties && \
	\cp -rf ${update_file_dir}/update_config ${old_package}/publish/sds-publish/bin/
	retun=$?
		while [ ${retun} -eq 0 ];do
			read -p "publish 配置文件已经合成完毕,请确认里面是否有需要更改选项，如果有请直接进行修改，如何没有请输入[yes]" confirm
			if [[ ${confirm} != "yes" ]];then
				continue
			else
				source ${docker_build} ${old_package}/publish/ && break
			fi
		done
	fi
fi
} 


function copy_directory() {
	sleep 3
        new_directory_name=$(echo ${i##*/})
        old_directory_name=${old_package}/publish/sds-publish
echo -e "\033[32m copy new ${directory_name} to ${old_directory_name}\033[0m"
        \cp -rf ${new_package}/sds-publish/${new_directory_name} ${old_directory_name}

}


function remove_directory() {
# publish 需要替换的目录
directory_name=(
${old_package}/publish/sds-publish/agent
${old_package}/publish/sds-publish/bin
${old_package}/publish/sds-publish/docker
${old_package}/publish/sds-publish/lib
)

update_file && \

for i in ${directory_name[@]};do
	if [ -d ${i} ];then
	rm -rf $i
	echo -e "\033[32m remove directory ${i} successful\033[0m"
	copy_directory
	else
	echo -e "\033[31m directory ${i} There is no!\033[0m"
	copy_directory
	fi
done

}



# 核心模块进行迭代操作
function publish() {
#read -p "输入老版本publish位置绝对路径:" old_package
input="$1"
old="${work_dir}/old_directory.sh"
new="${work_dir}/new_directory.sh"
if [ -z $1 ];then
	echo -e "\033[31m publish input string error!\033[0m" 
	exit
else
	if [ ! -f ${old} ];then
		echo -e "\033[31m ${old} file not find!\033[0m"
		exit
	else
		if [ ! -f ${new} ];then
			echo -e "\033[31m ${new} file not find!\033[0m"
			exit
		else
			old_package=$(source ${old} $1)
			new_package=$(source ${new} $1)
		fi
	fi
fi
#read -p "输入新版本publish位置绝对路径:" new_package

if [ ! -d ${old_package} ];then
	echo -e "\033[31m directory ${old_package} There is no!\033[0m"
	exit
else
	if [ ! -d ${new_package} ];then
	echo -e "\033[31m directory ${new_package} There is no!\033[0m"
	exit
	else
	# 替换目录文件
	remove_directory  && \
	# 替换主配置文件
	motify_config
	fi
fi

}
publish $1
