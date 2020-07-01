#!/bin/bash
# 2020-06-08
# 用于检测配置文件是否新增配置


old_config=/tmp/test1
new_config=/tmp/test2

new=(
$(echo ${new_files})
)
function check() {
# 判断如果文件不存在将直接COPY文件
old_files=$(find ${old_config} -maxdepth 1 -type f |xargs -n 1)
new_files=$(find ${new_config} -maxdepth 1 -type f |xargs -n 1)
new=(
$(echo ${new_files})
)

for i in ${new[@]};do
	# 检测是否存在文件
        Base_Name=$(basename ${i})
	number=$(find ${old_config} -maxdepth 1 -type f -name "${Base_Name}" |wc -l)
	if [ ${number} -eq 0 ];then
		\cp -rf $i ${old_config}

	else
	        # 检测新包配置文件MD5值	
		A=$(md5sum ${i} |awk '{print $1}')
		B=$(find ${old_config} -maxdepth 1 -type f -name ${Base_Name} -exec md5sum {} \; |awk '{print $1}')
		if [ "${A}" == "${B}" ];then
			echo -e "\033[32m ${Base_Name} MD5 OK\033[0m"
		else
			echo -e "\033[31m ${Base_Name} MD5 False\033[0m"
			#\cp -rf ${i} ${old_config} && echo -e "\033[32m ${i} file Motify!\033[0m"
		fi
	fi
done
}
check
