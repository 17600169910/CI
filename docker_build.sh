#!/bin/bash
# 自动构建docker image
# yintiecheng 
# 2019-12-07
URL="http://10.153.205.30:8002/images"
work_dir=$(cd $(dirname $0);pwd)
# 传参判断
function title() {

if [ $# -eq 0 ];then
	echo -e "\033[31m $0 input parameter empty\033[0m"
	exit 10
fi

}


# 日志输出模块
function log_output() {

log=''${DATE}' A docker version was iterated='${1}''
log_file="${work_dir}/log.sh"
if [ ! -f ${log_file} ];then
        echo -e "\033[31m ${log_file} mode srcipt not find!\033[0m"
        exit 6
else
        source ${log_file} ${log}
fi

}



# 大版本或跨版本更新模块
function Big_Version() {
if [ ! -f ${log} ];then
	read -p "${confirm_tag} 日志文件没有找到，请指定一个版本标签例如"1.1":" NeW_Tag
	# 格式匹配
	Fromat="[0-9]+?\.[0-9]+?"
	Fromat_Name=$(echo "${NeW_Tag}" | egrep ${Fromat})
	if [[ -z ${Fromat_Name} ]];then
		echo -e "\033[31m ${NeW_Tag} Input Error, Pleass Input example "1.1"\033[0m"
		continue
	else	
		sum_version_name="${confirm_tag}.${NeW_Tag}.${Big_Version_Tag}"
		echo "$(date +%F) A docker version was iterated=${sum_version_name}" > ${log}
        	action_build ${sum_version_name} && break
	fi
else
	commd=$(awk -F= 'END{print $NF}' ${log} | cut -d ':' -f 2)
	commdq=$(echo ${commd#*.})
	commd1=$(echo ${commdq%.*})
	# 获取叠加版本号
	# 每次叠加0.1
	version=0.1
	# 获取叠加结果
	growth_version=$(echo "${commd1}" "${version}" |awk '{print ($1+$2)}')
	# 最终版本号拼接
	sum_version_name="${confirm_tag}.${growth_version}.${Big_Version_Tag}"
	# 版本确认
	read -p "本次迭代版本为:${sum_version_name} yes|no: ?" L
		# 键入yes 直接进行build动作
		if [[ ${L} == "yes" ]];then
			echo "$(date +%F) A docker version was iterated=${sum_version_name}" >> ${log}
			sleep 2
			action_build ${sum_version_name} BIG && break
		# 键入为no 将手动进行版本输入，然后执行build操作
		elif [[ ${L} == "no" ]];then
			read -p "请手动输入准确的名称加版本标签!" M
			fromat="[a-zA-Z0-9]+?\:[0-9]+?\.[0-9]+?"
			fromat_name=$(echo "${A}" | egrep -o ${fromat})
			if [[ -z ${fromat_name} ]];then
				echo -e "\033[31m $M Input Error,Pleass Input example "edp:1.1"\033[0m"
				continue
			else
			echo "$(date +%F) A docker version was iterated=${M}" >> ${log}
			sleep 2
			action_build $M BIG && break
			fi
		else
			continue
		fi

fi

}

function Across_versions() {
while true
do
        read -p "是否为大版本更新或者跨版本更新'yes|no':" confirm
        if [[ ${confirm} == "yes" ]];then
		read -p "输入大版本服务名称例如"edp":" confirm_tag
		read -p "输入大版本标签例如"3020":" Big_Version_Tag
		if [[ ${confirm_tag} == "edp" ]];then
			log="/tmp/big_edp_tag.log"
			Big_Version
		elif [[ ${confirm_tag} == "nlu" ]];then
			log="/tmp/big_nlu_tag.log"
			Big_Version
		elif [[ ${confirm_tag} == "product-center" ]];then
			log="/tmp/big_product-center_tag.log"
			Big_Version
		elif [[ ${confirm_tag} == "publish" ]];then
			log="/tmp/big_publish_tag.log"
			Big_Version
		elif [[ ${confirm_tag} == "porter" ]];then
			log="/tmp/big_porter_tag.log"
			Big_Version
		else
			echo -e "\033[31m 请输入 edp|publisg|product-center|nlu|porter\033[0m"
			continue
		fi
	elif [[ ${confirm} == "no" ]];then
			break
	else
			continue
	fi
		
done
}
# 主体
function action_build() {
if [[ $2 != "BIG" ]];then
/usr/bin/docker build -t baidu/${1} . 
        retun=$?
        if [ ${retun} -eq 0 ];then
                echo -e "\033[32m ${1} build successful\033[0m"
                DATE=$(date +%Y%m%d)
                slave_image_name=$(echo ${DATE}_${1%%:*}.tar)
                image_dir_name=${image_dir}/${slave_image_name}
                /usr/bin/docker save baidu/${1} -o ${image_dir_name}
                if [ -e ${image_dir_name} ];then
                echo -e "\033[32m Compressed image file \033[0m"
                cd ${image_dir} && \
                /usr/bin/tar -acf ${image_dir_name}.gz ${slave_image_name} >/dev/null 2>&1 && \
                rm -rf ${image_dir_name} && \
                echo -e "\033[32m Compressed image file ${image_dir_name}.tar.gz successful\033[0m" 
		echo -e "\033[32m Download URL: "${URL}/${slave_image_name}.gz"\033[0m"
		log_output "${1}"
                exit
                else
                        echo -e "\033[31m ${image_dir_name} not find!\033[0m"
                        exit 8
                fi
        else
                        echo -e "\033[31m docker build There is an error\033[0m"
                        exit 9
        fi
else
	/usr/bin/docker build -t baidu/${1} . 
        retun=$?
        if [ ${retun} -eq 0 ];then
                echo -e "\033[32m ${1} build successful\033[0m"
                DATE=$(date +%Y%m%d)
                slave_image_name=$(echo ${DATE}_${1%%:*}.tar)
                image_dir_name=${image_dir}/${slave_image_name}
                /usr/bin/docker save baidu/${1} -o ${image_dir_name}
                if [ -e ${image_dir_name} ];then
                echo -e "\033[32m Compressed image file \033[0m"
                cd ${image_dir} && \
                /usr/bin/tar -acf ${image_dir_name}.gz ${slave_image_name} >/dev/null 2>&1 && \
                rm -rf ${image_dir_name} && \
                echo -e "\033[32m Compressed image file ${image_dir_name}.tar.gz successful\033[0m" 
		echo -e "\033[32m Download URL: "${URL}/${image_dir_name}.tar.gz"\033[0m"
                exit
                else
                        echo -e "\033[31m ${image_dir_name} not find!\033[0m"
                        exit 8
                fi
        else
                        echo -e "\033[31m docker build There is an error\033[0m"
                        exit 9
        fi
fi
}


function matching_A() {
Across_versions
# 当反馈值为空时
NUM=$(source ${work_dir}/docker_tag.sh ${service_name})
# 判断如果反馈的是空值，那么表示该build版本非标准版本，需要手动进行指定名称:tag
if [[ -z "${NUM}" ]];then
        read -p "您构建的镜像属于非标准镜像构建,请手动指定'镜像名称:tag':" A
	 if [[ -z ${A} ]];then
            # 当新键入的标签为空时
            matching
	else
	   fromat="[a-zA-Z0-9]+?\:[0-9]+?\.[0-9]+?"
           fromat_name=$(echo "${A}" | egrep -o ${fromat})
           if [[ -z ${fromat_name} ]];then
              echo -e "\033[31m $M Input Error,Pleass Input example "edp:1.1"\033[0m"
              continue
	   else
                # 当键入的标签正确时
                action_build "$A" && break
	   fi
        fi
else
           while true
           do
                read -p "当前build的镜像为:${NUM},是否确认更新,yes即可:" B
                	if [[ ${B} == "yes" ]];then
                        	A=${NUM}
                		# 当键入的标签正确时
                		action_build "$A" && break
                	elif [[ ${B} == "no" ]];then
                		read -p "请自己手动输入镜像及标签:" not_tag
				fromat="[a-zA-Z0-9]+?\:[0-9]+?\.[0-9]+?"
           			fromat_name=$(echo "${not_tag}" | egrep -o ${fromat})
          			 if [[ -z ${fromat_name} ]];then
              				echo -e "\033[31m $not_tag Input Error,Pleass Input example "edp:1.1"\033[0m"
              				continue
				 else
                			action_build "${not_tag}" && break
			       	 fi
                	else
                        	continue
                	fi
           done
fi
}
# build 镜像操作
function matching() {
image_dir="/var/www/html/images"
while true
do
	read -p "输入您本次需要build镜像的服务名称例如'edp':" service_name
	if [[ ${service_name} == "edp" ]];then
		matching_A
	elif [[ ${service_name} == "publish" ]];then
		matching_A
	elif [[ ${service_name} == "nlu" ]];then
		matching_A
	elif [[ ${service_name} == "product-center" ]];then
		matching_A
	elif [[ ${service_name} == "porter" ]];then
		matching_A
	else
		continue
	fi
done
}

# 脚本传参
function build_image() {

title $*

if [ ! -d "$1" ];then
	echo -e "\033[31m $1 directory not find!\033[0m"
	exit 7
else
	cd $1 && matching $*
fi	

}
build_image $*
