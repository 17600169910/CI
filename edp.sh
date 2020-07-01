#!/bin/bash
# edp自动构建镜像脚本
# yintiecheng 2019-12-07

work_dir=$(cd $(dirname $0);pwd)
fixed_edp=${work_dir}/fixed_config/edp_fixed_config.sh
fixed_shell=${work_dir}/fixed_config.sh
# 是否开启固定配置文件修改 true开启 false关闭
fixed_enabled=true
# 替换指定内容，在补丁合成完毕之后
function fixed_config() {
A=$old_config_name

if [ -f ${fixed_shell} ];then
	source ${fixed_shell} $A
else
	echo -e "\033[31m ${fixed_shell} Shell Not Find!\033[0m"
	exit
fi
 
}

# 当老版本配置文件不存在时进行的操作
function copy_new_config() {

if [ ! -f ${new_config} ];then
    echo -e "\033[31m ${new_config} There is no!\033[0m"
    exit 6
else
    echo -e "\033[32m copy new config: ${new_config} to ${old_config}\033[0m"
    \cp -rf ${new_config} ${old_config}
    if [ -f ${old_config_name} ];then
	echo -e "\033[32m The update is successful\033[0m"
    else
	echo -e "\033[32m ${old_config_name} There is no \033[0m"
	exit
    fi
fi

}


function docker_build() {
while [ ${retun} -eq 0 ];do
read -p '已经将老版本的主配置文件更新,您必须核对里面更新的内容,核对成功后,或修改后请输入[yes]:' confirm
        if [[ $confirm != "yes" ]];then
                continue
        else
                rm -rf ${temporary_file} && source ${work_dir}/docker_build.sh ${package_old}/edp
        fi
    done
}

# 当老版本配置文件存在时那么我们应该进行文件比较并进行更新操作
function motify_config() {
# 临时生成补丁文件位置
temporary_file="/tmp/$$.txt"
# 临时生生吃补丁文件名称
patch_file_name="${old_config_name}.orig"

if [ ! -f ${new_config} ];then
    echo -e "\033[31m ${new_config} There is no!\033[0m"
    exit 6
else
    echo -e "\033[32m Generate differential patches ..\033[0m"
    sleep 2
    /usr/bin/diff -u ${old_config_name} ${new_config} > ${temporary_file} && \
    echo -e "\033[32m Patch old files: ${old_config_name}\033[0m"
    /usr/bin/patch -b ${old_config_name} ${temporary_file} && \
    rm -rf ${patch_file_name} && \
    fixed_config
    retun=$?
    docker_build
fi
}


# 配置文件跟新模块
function motify_edp_config() {
# 老版本主配置文件位置
old_config=${package_old}/edp/sds-dialogue-feedback/config
old_config_name=${old_config}/application-xkfonline.properties
# 新版本主配置文件位置
new_config_name=application-xkfonline.properties
new_config=${package_new}/sds-dialogue-feedback/config/${new_config_name}

if [ ! -f ${old_config_name} ];then
	echo -e "\033[31m ${old_config_name} Config file There is no\033[0m"
	copy_new_config && \
	fixed_config && \
	retun=$?
	docker_build
else
	motify_config
fi

}

#  替换所有的train 配置文件
function remove_train_config() {

echo -e "\033[32m Remove Edp Train Config file \033[0m"
sleep 3
find ${package_old}/edp/sds-dialogue-feedback/config -type f -name "train*" -exec rm -rf {} \; && \

echo -e "\033[32m Copy New Train Config file \033[0m"
sleep 3
find ${new_dir}/config -type f -name "train*" -exec cp -rf {} ${package_old}/edp/sds-dialogue-feedback/config \;

}


# 更新目录模块
function copy_new() {

echo -e "\033[34m copy new directory ${dir_name} to old directory ${old_dir} \033[0m"
                new_dir=${package_new}/sds-dialogue-feedback
                dir_name=$(echo ${i##*/})
                \cp -rf ${new_dir}/${dir_name} ${old_dir}
                sleep 1
#		remove_train_config
}

function edp(){

remove_directory=(
${package_old}/edp/sds-dialogue-feedback/agent
${package_old}/edp/sds-dialogue-feedback/bin
${package_old}/edp/sds-dialogue-feedback/docker
${package_old}/edp/sds-dialogue-feedback/lib
)


# 删除老版本的目录
for i in ${remove_directory[@]};do
	old_dir=${package_old}/edp/sds-dialogue-feedback
	if [ -d ${i} ];then
	    echo -e "\033[32m 开始${package_old}清理目录\033[0m"
            sleep 5
            rm -rf $i
            echo -e "\033[32m remove directory $i successful\033[0m"
		sleep 1
	copy_new
	else
		echo -e "\033[31m $i directory Has been deleted\033[0m"
		sleep 2
	copy_new
	fi
	
done
remove_train_config
}


function input() {
service="$1"
if [[ ${service} == "edp" ]];then
	# 获取上次迭代edp版本
	package_old=$(source ${work_dir}/old_directory.sh ${service})
	if [ -d ${package_old} ];then
			# 获取本次迭代的edp版本
			package_new=$(source ${work_dir}/new_directory.sh ${service})
		if [  ! -d ${package_new} ];then
			echo -e "\033[31m new ${package_new} not find!\033[0m"
			exit
		fi
	else
		echo -e "\033[31m old ${package_old} not find!\033[0m"
		exit
	fi

if [ ! -d $package_old ];then
	echo -e "\033[31m $package_old not find\033[0m"
	exit 1
	
else
       echo -e "\033[32m 老版本位置:$package_old\033[0m"
       if [ ! -d $package_new ];then
          echo -e "\033[31m $package_new not find\033[0m"
          exit 2
	else
	  echo -e "\033[32m 新版本位置: $package_new\033[0m"
       fi
edp && motify_edp_config
fi       
else
	echo -e "\033[31m ${service} not string "edp"\033[0m"
	exit
fi
}

#function input() {

#while :
#do
#	read -p "是否为大版本更新3020?\"yes|no\":" confirm_big
#	if [[ "${confirm_big}" == "yes" ]];then
#		commd_old=$(source ${work_dir}/old_directory.sh ${service} 3020)
#		commd_new=$(source ${work_dir}/new_directory.sh ${service} 3020)
#		input_o $1 && break
#	elif [[ "${confirm_big}" == "no" ]];then
#		commd_old=$(source ${work_dir}/old_directory.sh ${service})
#                commd_new=$(source ${work_dir}/new_directory.sh ${service})
#                input_o $1 && break
#	else
#		continue
#	fi
#done
#}


input $1 
