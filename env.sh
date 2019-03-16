#!/usr/bin/env bash
# 切換到 evn.sh 檔案目錄底下
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
clear

pressAnyKeyToContinue() {
    removeInfo
    removeError
    read -n 1 -s -r -p "Press any key to continue..."
    clear
}

godzilla() {
    echo '                                   ,▄▄▄'
    echo '                                 ,█▓████▓b'
    echo '                                /▓████████▄'
    echo '                               ╔▓██▓█████"▀'
    echo '                             ▄.▓█████████▀'
    echo '                           ███▓████████'
    echo '                        ╔,p▓███████████'
    echo '                       ²███▓███████████▄'
    echo '                        ▓▓███████████████µ'
    echo '                      ╔▄▓▓████████████████▄'
    echo '                       ████████████████████Γ'
    echo '                     j▄████████████████████'
    echo '                     ▀████████████████████Γ'
    echo '                      █████████████████████▄▄▄'
    echo '                    -███▓████████████████▀████'
    echo '                    ▀█▓█████████████████▓'
    echo '                    ▐████████████████████'
    echo '                     ▓███████████████████▄'
    echo '                    å▓▓▓███████████████████▄'
    echo '                   ]▓▓█▓█████████████████████µ'
    echo '                   Å▓▓█▓██████████████████████▄╓'
    echo '     :▓██████▄,   ]▓▓██████████████████████████▄'
    echo '         `▀▀█████▄j▓▓███████████████████████████'
    echo '             █▓████▓████████████████████████████'
    echo '             ▐█▓████████████████████████████████'
    echo '             ╙██████████████████████████████████'
    echo '              "██▓██████████████████████████████'
    echo '               ╙▀█████████████████████████████▀'
    echo '                 ^█████████████████╖█████████'
    echo '                   ╙▀███████████▀Γ  @███████'
    echo '                     ▐████████▄     ████████▄,,'
    echo '                     ▓▓██████████w   ████████████▄'
    echo '                     ▐▓▀▀▀█▓▀▀▀▀Γ       "▀▀"▀▀▀▀ `^'
}

initCommend() {
    local commendArray
    local stringArray
    declare commendArray
    declare stringArray

    commendArray=(n r c l s i q)
    stringArray=(跳置編號 重啟 關閉 狀態 查詢 進入 結束)

    for key in ${!commendArray[@]}
    do
        COMMENDSTRING=${COMMENDSTRING}"   [\033[31m"${commendArray[$key]}"\033[0m]\033[30;42m"${stringArray[$key]}"\033[0m"
    done
}

printPartition() {
    cols=""
    for((j=1; j<=${windowsWidth}; j++ ))
    do
        cols=${cols}-
    done
    echo -e "\033[0;32m${cols}\033[0m"
}

printFace() {
    printf "\E[0;33m"
    echo "   ______                   ______          __"
    echo "  / ____/___  ________     /_  __/__  _____/ /_"
    echo " / /   / __ \\/ ___/ _ \\     / / / _ \\/ ___/ __ \\"
    echo "/ /___/ /_/ / /  /  __/    / / /  __/ /__/ / / /"
    echo "\\____/\\____/_/   \\___/    /_/  \\___/\\___/_/ /_/ "
    echo -e "          Welcome to use Core-Tech Docker. v3.1.0  ${INFO} ${ERROR}"
    printf "\E[0m"
    printPartition
}

printEmpty() {
    for((j=0; j<=$[${windowsHigh}-14-${PROJECT_MAX_NUM}]; j++ ))
    do
        echo ""
    done
}

showInfo() {
    INFO="\033[37;46m${1}\033[0m"
}

removeInfo() {
    INFO=""
}

showError() {
    ERROR="\033[37;41m${1}\033[0m"
}

removeError() {
    ERROR=""
}

existedCurrentProject() {
    if [[ ${CURRENT_PROJECT_NAME} ]]; then
        echo 1
    else
        echo 0
    fi
}

setSelectProject() {
    SELECTED_PROJECT_NAME=${PROJECT_LIST[$1]}
    SELECTED_PROJECT_YML="./project/${SELECTED_PROJECT_NAME}/docker-compose.yml"
    SEKECTED_PROJECT_ENV="./project/${SELECTED_PROJECT_NAME}/.env"
}

setCurrentProject() {
    CURRENT_PROJECT_NAME=$1
    CURRENT_PROJECT_YML="./project/${CURRENT_PROJECT_NAME}/docker-compose.yml"
}

prevItem() {
    ((SELECTED_PROJECT_NUMBER--))
    if [[ ${SELECTED_PROJECT_NUMBER} -lt 0 ]]; then
        SELECTED_PROJECT_NUMBER=${PROJECT_MAX_NUM}
    fi
}

nextItem() {
    ((SELECTED_PROJECT_NUMBER++))
    if [[ ${SELECTED_PROJECT_NUMBER} -gt ${PROJECT_MAX_NUM} ]]; then
        SELECTED_PROJECT_NUMBER=0
    fi
}

removeAllDockerContainer() {
    local id
    id=($(docker ps -a -q))

    if [[ ${id} ]]
    then
#        docker stop $(docker ps -a -q) | awk '{print "關閉 \""$1"\" Container"}'
#        docker rm $(docker ps -a -q) | awk '{print "移除 \""$1"\" Container"}'
        docker rm -f $(docker ps -a -q) | awk '{print "移除 \""$1"\" Container"}'
    fi
}

jumpToNum() {
    read -p '跳至編號: ' -r num
    [[ ${num} != '' ]] && [[ ${PROJECT_LIST[$num]} ]] && SELECTED_PROJECT_NUMBER=${num}
}

keyInput() {
    # 熱鍵前綴
    local ESC=$(printf "\033")
    local input
    input=$1
    # 上下左右 是 三字元 例: up => ${ESC}[A
    if [[ ${input} = ${ESC} ]] || [[ ${input} = '[' ]] ; then
        read -r -sn1 input
    fi;
    if [[ ${input} = ${ESC} ]] || [[ ${input} = '[' ]] ; then
        read -r -sn1 input
    fi;

    if [[ $input = A ]]; then echo up;
    elif [[ $input = B ]]; then echo down;
    elif [[ $input = C ]]; then echo right;
    elif [[ $input = D ]]; then echo left;
    elif [[ $input = "" ]]; then echo enter;
    else echo $input;
    fi;
}
# init COMMENDSTRING
COMMENDSTRING=""
initCommend
# 選擇的專案編號
SELECTED_PROJECT_NUMBER=''
# 選擇的專案名稱
SELECTED_PROJECT_NAME=''
# 選擇的專案docker-compose.yml
SELECTED_PROJECT_YML=''
# 選擇的專案.ENV
SEKECTED_PROJECT_ENV=''
# 當前專案名稱
CURRENT_PROJECT_NAME=''
# 取得畫面寬
windowsWidth=$(tput cols)


# 歡迎介面
printFace
printf "\E[0;32m"
read -p "請按Enter開始Docker... " admin
printf "\E[0m"
[[ ${admin} = 'admin' ]] && godzilla && pressAnyKeyToContinue
clear

# 基本介面
while :
do
    # 取得畫面高
    windowsHigh=$(tput lines)
    # 讀取所有 project
    rawProjectList=$(ls './project')
    # 去掉example資料夾
    declare -a PROJECT_LIST=(${rawProjectList/_example/})
    # 最大專案編號
    PROJECT_MAX_NUM=$((${#PROJECT_LIST[@]}-1))
    # 如有選擇專案 則執行 setSelectProject
    [ ${SELECTED_PROJECT_NUMBER} ] && setSelectProject ${SELECTED_PROJECT_NUMBER}

    # 介面分隔 & title & info & error
    printFace
    echo -e "  狀態\t 編號\t 專案名稱\t"
    removeError
    removeInfo
    printPartition

    for i in ${!PROJECT_LIST[@]}
    do
        projectName=${PROJECT_LIST[${i}]}
        # 預設選擇第一個專案
        if [ -z ${SELECTED_PROJECT_NUMBER} ];then
            SELECTED_PROJECT_NUMBER=${i}
            setSelectProject ${SELECTED_PROJECT_NUMBER}
        fi

        # 是選擇的專案 & 是當前專案
        if [  "${projectName}" == "${SELECTED_PROJECT_NAME}" ] && [ "${projectName}" == "${CURRENT_PROJECT_NAME}" ]; then
            echo -e "  \033[32m●\033[0m\t \033[31m${i}.\033[0m\t \033[30;43m${PROJECT_LIST[${i}]}\033[0m"
        # 是選擇的專案
        elif [  "${projectName}" == "${SELECTED_PROJECT_NAME}" ]; then
            echo -e "  \033[31m●\033[0m\t \033[31m${i}.\033[0m\t \033[30;43m${PROJECT_LIST[${i}]}\033[0m"
        # 是當前專案
        elif [  "${projectName}" == "${CURRENT_PROJECT_NAME}" ]; then
            echo -e "  \033[32m●\033[0m\t \033[31m${i}.\033[0m\t ${PROJECT_LIST[${i}]}"
        # 其他
        else
            echo -e "  \033[31m●\033[0m\t \033[31m${i}.\033[0m\t ${PROJECT_LIST[${i}]}"
        fi
    done

    # 計算介面及專案數印出 Ｎ row 空行
    printEmpty

    # 指令面板
    printPartition
    echo -e ${COMMENDSTRING}
    printf "\33[?25l"
    read -r -sn1 input
    input=$(keyInput ${input})

    # case
    case ${input} in
        up)
            clear
            prevItem
            continue
            ;;
        down)
            clear
            nextItem
            continue
            ;;
        enter)
            clear

            # 設定 env ()
            if [[ -f ${SEKECTED_PROJECT_ENV} ]] ; then
                export $(grep -v '^#' ${SEKECTED_PROJECT_ENV} | xargs)
            else
                showInfo "該專案無.env檔"
            fi
            printFace

            # 關閉 container
            removeAllDockerContainer

            # docker up
            docker-compose -p core_docker --project-directory . -f ${SELECTED_PROJECT_YML} up -d
            setCurrentProject ${SELECTED_PROJECT_NAME}

            pressAnyKeyToContinue
            ;;
        r)
            clear
            # 檢查當前專案存在
            if [[ $(existedCurrentProject) == 0 ]] ; then
                showError "沒有執行中的專案"
                continue
            fi
            printFace

            # 關閉 container
            removeAllDockerContainer
            # 啟動 all server
            docker-compose -p core_docker --project-directory . -f ${CURRENT_PROJECT_YML} up -d
            clear
            ;;
        s)
            clear
            # 檢查當前專案存在
            if [[ $(existedCurrentProject) == 0 ]] ; then
                showError "沒有執行中的專案"
                continue
            fi
            printFace

            newProjectDockerCompose=$(cd "$(dirname "$0")";pwd)/project/${CURRENT_PROJECT_NAME}/docker-compose.yml
            echo -e "\033[32mProject Name: \033[0m"${CURRENT_PROJECT_NAME}
            echo -e "\033[32mLocal Domain: \033[0m"$(sed -n 2,2p ${newProjectDockerCompose} | sed 's/#//g')
            cat ${newProjectDockerCompose} | grep -n "container_name" | awk '{sub(/container_name:/,"\033[32mContainer:\033[0m")}{print $2$3}'
            cat ${newProjectDockerCompose} | grep -n "PMA_PASSWORD" | awk '{sub(/PMA_PASSWORD:/,"\033[32mCloudDbPassword:\033[0m")}{print $2$3}'
            pressAnyKeyToContinue
            continue
            ;;
        l)
            clear
            printFace
            # 查看目前的 container
            docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}"
            pressAnyKeyToContinue
            ;;
        c)
            clear
            printFace
            CURRENT_PROJECT_NAME=''
            # 關閉 container
            removeAllDockerContainer
            pressAnyKeyToContinue
            ;;
        i)
            clear
            printFace
            # 查看目前的 container
            docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}"
            echo -e "\033[37;41m請輸入 Container Name(ex: apache)\033[0m"
            read -p "Name:" containerName
            clear
            #  進入 container
            if [[ ${containerName} ]]; then
                docker exec -it ${containerName} bash
            fi
            clear
            ;;
        q)
            clear
            # 離開程序
            exit
            ;;
        n)
            jumpToNum
            clear
            ;;
        x)
            clear
            printFace
            echo -e " \033[37;41m進階工具\033[0m"
            printPartition
            echo -e "  \033[31mnewpj.\033[0m  建立新專案 + 專案名稱\033[31m(勿自行使用)\033[0m"
            echo -e "      \033[0;32;mexample => \033[31minput:newpj owlcrm\033[0m"
            echo -e "  \033[31msa.\033[0m   顯示整份yml"
            echo -e "  \033[31mimg.\033[0m   顯示本機所有image"
            echo -e "  \033[31mrmif.\033[0m   移除所有tw-registry的images"
            echo -e "  \033[31mpull.\033[0m   更新當前專案的images"
            printPartition

            printf "\E[0;31m"
            read -p "Input: " xinput xinput2
            printf "\E[0m"

            case $xinput in
                newpj)
                    clear
                    if [  "$xinput2" == "" ]; then
                        showError "\033[37;41m請輸入專案名稱\033[0m"
                    else
                        # 取得 project name
                        newProjectName=${xinput2}
                        # 設定基本路徑
                        baseDir=$(cd "$(dirname "$0")";pwd);
                        apacheConfPath='/apache/conf';
                        nginxConfPath='/nginx/conf';
                        sqlFilePath='/sql';
                        # 取得 example & new project path
                        exampleDockerDir=${baseDir}/project/_example;
                        projectDockerDir=${baseDir}/project/${newProjectName};
                        # 建立 project dir 程序
                        if [ -d ${projectDockerDir} ]
                        then
                            showInfo '\033[37;41m已經建立 '${projectDockerDir}' 專案\033[0m'
                            continue
                        else
                            mkdir -m 755 ${projectDockerDir}
                            if [ ! -d ${projectDockerDir} ]
                            then
                                showError '\033[37;41mmkdir '${projectDockerDir}' 失敗\033[0m'
                                continue
                            fi
                        fi
                        mkdir -m 755 -p ${projectDockerDir}${apacheConfPath};
                        mkdir -m 755 -p ${projectDockerDir}${nginxConfPath};
                        mkdir -m 755 ${projectDockerDir}${sqlFilePath};
                        # 取的 conf 基本變數
                        newProjectLocalDomain=local.${newProjectName}.jp;
                        newProjectDocumentRoot='\/public';
                        exampleApacheConf=${exampleDockerDir}${apacheConfPath}/example.loc.conf
                        newProjectApacheConf=${projectDockerDir}${apacheConfPath}/${newProjectName}.conf
                        exampleNginxConf=${exampleDockerDir}${nginxConfPath}/example.loc.conf
                        newProjectNginxConf=${projectDockerDir}${nginxConfPath}/${newProjectName}.conf
                        exampleProjectENV=${exampleDockerDir}/.env.example
                        newProjectENV=${projectDockerDir}/.env
                        exampleDockerCompose=${exampleDockerDir}/docker-compose.yml
                        newProjectDockerCompose=${projectDockerDir}/docker-compose.yml
                        # 替換 apache conf 文件新增至 new project 內
                        sed "s/{{PROJECT_LOCAL_DOMAIN}}/${newProjectLocalDomain}/g;s/{{PROJECT_NAME}}/${newProjectName}/g;s/{{DOCUMENT_ROOT}}/${newProjectDocumentRoot}/g" ${exampleApacheConf} > ${newProjectApacheConf};
                        # 替換 nginx conf 文件新增至 new project 內
                        sed "s/{{PROJECT_LOCAL_DOMAIN}}/${newProjectLocalDomain}/g;s/{{PROJECT_NAME}}/${newProjectName}/g;s/{{DOCUMENT_ROOT}}/${newProjectDocumentRoot}/g" ${exampleNginxConf} > ${newProjectNginxConf};
                        # 替換 .env.example 文件新增至 new project 內
                        sed "s/{{PROJECT_NAME}}/${newProjectName}/g" ${exampleProjectENV} > ${newProjectENV};
                        # 替換 docker compose 文件新增至 new project 內
                        sed "s/{{PROJECT_LOCAL_DOMAIN}}/${newProjectLocalDomain}/g;s/{{PROJECT_NAME}}/${newProjectName}/g" ${exampleDockerCompose} > ${newProjectDockerCompose};

                        showInfo "${newProjectName} 已建立請編輯該專案的 docker-compose.yml"
                    fi
                    ;;
                sa)
                    clear
                    # 檢查當前專案存在
                    if [[ $(existedCurrentProject) == 0 ]] ; then
                        showError "\033[37;41m沒有執行中的專案\033[0m"
                        continue
                    fi

                    newProjectDockerCompose=$(cd "$(dirname "$0")";pwd)/project/${CURRENT_PROJECT_NAME}/docker-compose.yml
                    cat ${newProjectDockerCompose} | more
                    pressAnyKeyToContinue
                    continue
                    ;;
                img)
                    clear
                    printFace
                    # 顯示所有 image
                    docker images
                    pressAnyKeyToContinue
                    ;;
                rmif)
                    clear
                    printFace
                    # 移除所有tw-registry的images
                    docker rmi -f $(docker images | grep "tw-registry" | awk '{print $3}')
                    ;;
                pull)
                    clear
                    printFace
                    docker-compose -p core_docker --project-directory . -f ${SELECTED_PROJECT_YML} pull
                    ;;
                *)
                    clear
                    ;;
            esac
            ;;
        *)
            clear
            ;;
    esac
done
