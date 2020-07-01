#!/bin/bash
# product-center自动构建镜像脚本
# yintiecheng 2019-12-07

work_dir=$(cd $(dirname $0);pwd)
fixed_edp=${work_dir}/fixed_config/product_center_fixed_config.sh
# 是否开启固定配置文件修改 true开启 false关闭
fixed_enabled=true
fixed_shell=${work_dir}/fixed_config.sh
config_name=${old_config}
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

# 当老版本配置文件存在时那么我们应该进行文件比较并进行更新操作
function motify_config() {
# 临时生成补丁文件位置
temporary_file="/tmp/$$.txt"

if [ ! -f ${new_config} ];then
    echo -e "\033[31m ${new_config} There is no!\033[0m"
    exit 6
else
    echo -e "\033[32m Generate differential patches ..\033[0m"
    sleep 2
    /usr/bin/diff -u ${old_config_name} ${new_config} > ${temporary_file}
    echo -e "\033[32m Patch old files: ${old_config_name}\033[0m"
    /usr/bin/patch -b ${old_config_name} ${temporary_file} && \
    fixed_config
    retun=$?
    while [ ${retun} -eq 0 ];do
	read -p '已经将老版本的主配置文件更新,您必须核对里面更新的内容,核对成功后,或修改后请输入[yes]:' confirm
	if [[ $confirm != "yes" ]];then
		continue
	else
		rm -rf ${temporary_file} && source ${work_dir}/docker_build.sh ${package_old}/product-center
	fi
    done
fi
}

# 配置文件跟新模块
function motify_product_center_config() {
# 老版本主配置文件位置
old_config=${package_old}/product-center/sds-product-center/config/
old_config_name=${old_config}/application-xkfonline.properties
# 新版本主配置文件位置
new_config_name=application-xkfonline.properties
new_config=${package_new}/sds-product-center/config/${new_config_name}

if [ ! -f $old_config_name ];then
	echo -e "\033[31m $old_config_name There is no\033[0m"
	copy_new_config
else
	motify_config
fi

}


# 更新目录模块
function copy_new() {
echo -e "\033[34m copy new directory ${dir_name} to old directory ${old_dir}\033[0m"
                new_dir=${package_new}/sds-product-center
                dir_name=$(echo ${i##*/})
                \cp -rf ${new_dir}/${dir_name} ${old_dir}
                sleep 1
}

function product_center(){

remove_directory=(
${package_old}/product-center/sds-product-center/agent
${package_old}/product-center/sds-product-center/deploy
${package_old}/product-center/sds-product-center/bin
${package_old}/product-center/sds-product-center/docker
${package_old}/product-center/sds-product-center/lib
)


# 删除老版本的目录
for i in ${remove_directory[@]};do
	old_dir=${package_old}/product-center/sds-product-center
	if [ -d ${i} ];then
	    echo -e "\033[32m 开始${package_old}清理目录\033[0m"
            sleep 5
            rm -rf $i
            echo -e "\033[32m remove directory $i successful\033[0m"
		sleep 1
	copy_new
	else
		echo -e "\033[31m $i directory Has been deleted\033[0m"
		sleep 1
	copy_new
	fi
	
done

}


function input() {
input="$1"
old="${work_dir}/old_directory.sh"
new="${work_dir}/new_directory.sh"
if [ -z $1 ];then
        echo -e "\033[31m  product-center input string error!\033[0m" 
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
                        package_old=$(source ${old} $1)
                        package_new=$(source ${new} $1)
                fi
        fi
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
product_center && motify_product_center_config
fi

}

input $1
