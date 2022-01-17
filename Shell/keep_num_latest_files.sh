#!/bin/bash
#Keep the latest number of files.
 
KEEP_NUM=4
DEL_DATE=`date +'%Y%m%d'`
WORK_PATH=/backup/local
LOG_PATH=/backup/log
LOG_FILE_NAME=delete.log
LOG=${LOG_PATH}/${LOG_FILE_NAME}
 
if [ ! -d ${WORK_PATH} ];then
    mkdir -p ${WORK_PATH}
fi
if [ ! -d ${LOG_PATH} ];then
    mkdir -p ${LOG_PATH}
fi
 
echo -e '\n\n' >> ${LOG}
echo ${DEL_DATE} >> ${LOG}
 
cd ${WORK_PATH}
echo "The following files in the working path will be deleted:\n" >> ${LOG}
ls -1tr | head -n -${KEEP_NUM} | grep -v "${LOG_FILE_NAME}" >> ${LOG}
ls -1tr | head -n -${KEEP_NUM} | grep -v "${LOG_FILE_NAME}" | xargs -d '\n' rm -rf &> /dev/null
