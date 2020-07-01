#!/bin/bash
# 用于新增与替换固定配置信息
 


config_name="$1 $2"

function fixed_config() {

if [ ! -f ${fixed_edp} ];then
        echo -e "\033[31m Fixed configuration file does not exist\033[0m"
        exit
else
        source ${fixed_edp}
	echo $config_name
        for n in ${config[@]};do

                # 获取key
                key=$(echo ${n%%=*})
                # 如果传入的是一个不存在的KEY那么将在配置文件尾部进行追加操作
                Number=$(grep -o "${key}" ${config_name} |wc -l)
                if [ ${Number} -eq 0 ];then
                   sed -i '$a '$n'' ${config_name}
                else
                # 当key存在那么进行替换操作
                   value=$(echo ${n##*=})
                   sed -i "s#^${key}=.*#${key}=${value}#" ${config_name}
                fi

        done
fi

}

fixed_config
