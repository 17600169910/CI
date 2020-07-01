#!/bin/bash
# 自动化构建nlu镜像
# 2019-12-07
# Yintiecheng
# 考虑到nlu替换的文件不固定因顾，所以将采用交互式的传参构建

work_dir=$(cd $(dirname $0); pwd)
docker_build="${work_dir}/docker_build.sh"



# copy配置文件模块
function copy_mode() {
echo -e "\033[32m The backup ${old_nlu_file} to ${backup_dir}\033[0m"
     sleep 2
   file_name=$(echo ${new_nlu_file##*/})
\cp -rf ${old_nlu_file}/${file_name} ${backup_dir}

}


# 备份模块，在替换配置文件前应该先进行备份操作
function backup_mode() {

# 备份配置文件路径，按天生成
backup_dir="/tmp/nlu_backup_$(date +%F)"
if [ ! -d ${backup_dir} ];then
	mkdir -p ${backup_dir}
	copy_mode
else
	copy_mode
fi

}


# 主核心模块
# 该模块决定了应该进行哪些操作，包括替换配置文件，build镜像操作
function nlu() {
# 使用死循环的原因在于，你不能确定他到底提供了多少个配置文件需要替换
# 因此将采用交互模式，通过判断传入的键值来确定我们到底应该进行什么操作
# 参数介绍：
# exit   //表示我应该退出操作了，毕竟是死循环
# build  //表示我已经把需要替换的文件替换完成，下一步应该进行build docker镜像操作
# 其他的都是要替换的配置文件

while true
do

read -p "输入新的替换文件绝对路径,如果替换结束请输入[exit],如果需要build镜像，输入[build]:" new_nlu_file

if [ ${new_nlu_file} == "exit" ];then
	exit

elif [ ${new_nlu_file} == "build" ];then
	if [ ! -f ${docker_build} ];then
		echo -e "\033[31m ${docker_build} There is no!\033[0m"
		exit
	else
		read -p "开始build镜像，请输入需要build的nul目录，注意此处应该输入的是老版本的nlu位置:" nlu_dir
		source ${docker_build} ${nlu_dir} && break

	fi
else
	read -p "输入被替换文件绝对路径:" old_nlu_file
	if [ ! -e ${new_nlu_file} ];then
		echo -e "\033[31m ${new_nlu_file} There is no!\033[0m"
		exit
	else
		if [ ! -e ${new_nlu_file} ];then
		echo -e "\033[31m ${new_nlu_file} There is no!\033[0m"
		exit
		else
			backup_mode
			echo -e "\033[32m copy ${new_nlu_file} to ${old_nlu_file}\033[0m"
			sleep 3
			\cp -rf ${new_nlu_file} ${old_nlu_file}
			
		fi
	fi
fi

done
}
nlu
