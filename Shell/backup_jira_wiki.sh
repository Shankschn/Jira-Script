#!/bin/bash
#Backup for Jira and Confluence.
REMOTE_IP=IP地址
REMOTE_DIR=/data/jira_wiki_backup
 
MYSQL_ACCOUNT=root
MYSQL_PASSWORD=root
MYSQL_DB_NAME_JIRA=jira
MYSQL_DB_NAME_CONFLUENCE=confluence
 
SRC_INSTALL_DIR=/opt/atlassian
SRC_HOME_DIR=/var/atlassian/application-data
SRC_MYSQL_CONF=/etc/my.cnf
 
BACKUP_DIR=/backup
BACKUP_DIR_LOG=${BACKUP_DIR}/log
BACKUP_DIR_LOCAL=${BACKUP_DIR}/local
BACKUP_DIR_REMOTE=${BACKUP_DIR}/remote
 
BACKUP_DATE=`date +'%Y%m%d'`
BACKUP_DIR_LOCAL_BACKUP_DATE=${BACKUP_DIR_LOCAL}/${BACKUP_DATE}
BACKUP_DIR_LOG_BACKUP_DATE=${BACKUP_DIR_LOG}/backup.log
 
RSYNC_LOG=${BACKUP_DIR_LOG}/rsync.log
 
if [ ! -d ${BACKUP_DIR_LOG} ];then
    mkdir -p ${BACKUP_DIR_LOG}
fi
if [ ! -d ${BACKUP_DIR_LOCAL_BACKUP_DATE} ];then
    mkdir -p ${BACKUP_DIR_LOCAL_BACKUP_DATE}
fi
if [ ! -d ${BACKUP_DIR_REMOTE} ];then
    mkdir -p ${BACKUP_DIR_REMOTE}
fi
 
echo -e '\n\n' >> ${BACKUP_DIR_LOG_BACKUP_DATE}
echo "`date +'%Y-%m-%d %H:%M'` Backup start." >> ${BACKUP_DIR_LOG_BACKUP_DATE}
 
# 本地备份
# 备份 安装程序 程序家目录 到本地
echo "`date +'%Y-%m-%d %H:%M'` Backup SRC_INSTALL_DIR and SCR_HOME_DIR" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
 
cp -a ${SRC_INSTALL_DIR} ${BACKUP_DIR_LOCAL_BACKUP_DATE}/ &> /dev/null
if [ $? -eq 0 ];then
    echo "`date +'%Y-%m-%d %H:%M'` Backup SRC_INSTALL_DIR Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
else
    echo "`date +'%Y-%m-%d %H:%M'` Backup SRC_INSTALL_DIR Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
 
cp -a ${SRC_HOME_DIR} ${BACKUP_DIR_LOCAL_BACKUP_DATE}/ &> /dev/null
if [ $? -eq 0 ];then
    echo "`date +'%Y-%m-%d %H:%M'` Backup SRC_HOME_DIR Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
else
    echo "`date +'%Y-%m-%d %H:%M'` Backup SRC_HOME_DIR Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
 
# 备份 数据库实例 数据库配置文件 到本地
echo "`date +'%Y-%m-%d %H:%M'` Backup Database" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
 
mysqldump -u${MYSQL_ACCOUNT} -p${MYSQL_PASSWORD} ${MYSQL_DB_NAME_JIRA} > ${BACKUP_DIR_LOCAL_BACKUP_DATE}/${MYSQL_DB_NAME_JIRA}.sql &> /dev/null
if [ $? -eq 0 ];then
    echo "`date +'%Y-%m-%d %H:%M'` Backup Jira Database Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
else
    echo "`date +'%Y-%m-%d %H:%M'` Backup Jira Database Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
 
mysqldump -u${MYSQL_ACCOUNT}  -p${MYSQL_PASSWORD} ${MYSQL_DB_NAME_CONFLUENCE} -R > ${BACKUP_DIR_LOCAL_BACKUP_DATE}/${MYSQL_DB_NAME_CONFLUENCE}.sql &> /dev/null
if [ $? -eq 0 ];then
    echo "`date +'%Y-%m-%d %H:%M'` Backup Confluence Database Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
else
    echo "`date +'%Y-%m-%d %H:%M'` Backup Confluence Database Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
 
echo "`date +'%Y-%m-%d %H:%M'` Backup my.cnf" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
cp -a  ${SRC_MYSQL_CONF} ${BACKUP_DIR_LOCAL_BACKUP_DATE}/ &> /dev/null
if [ $? -eq 0 ];then
    echo "`date +'%Y-%m-%d %H:%M'` Backup my.cnf Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
else
    echo "`date +'%Y-%m-%d %H:%M'` Backup my.cnf Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
echo "`date +'%Y-%m-%d %H:%M'` Backup end." >> ${BACKUP_DIR_LOG_BACKUP_DATE}
 
# 更新 软链 local_latest
cd ${BACKUP_DIR_LOCAL}
ln -snf ${BACKUP_DIR_LOCAL}/"$(ls -1t | head -n 1)" ${BACKUP_DIR}/local_latest &> /dev/null
 
# NFS 挂载 RSYNC 同步 最新本地备份 到 远程
echo "`date +'%Y-%m-%d %H:%M'` Mount BACKUP_DIR_REMOTE" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
mount -t nfs ${REMOTE_IP}:${REMOTE_DIR} ${BACKUP_DIR_REMOTE} &>> ${RSYNC_LOG}
if [ $? -eq 0 ];then
 
    echo "`date +'%Y-%m-%d %H:%M'` Mount BACKUP_DIR_REMOTE Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
 
    echo "`date +'%Y-%m-%d %H:%M'` Backup BACKUP_DIR_LOCAL to BACKUP_DIR_REMOTE" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    rsync -av --ignore-existing --delete ${BACKUP_DIR}/local_latest/  ${BACKUP_DIR_REMOTE}/ &>> ${RSYNC_LOG}
    if [ $? -eq 0 ];then
        echo "`date +'%Y-%m-%d %H:%M'` Backup Local to Remote Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    else
        echo "`date +'%Y-%m-%d %H:%M'` Backup Local to Remote Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    fi
 
    echo "`date +'%Y-%m-%d %H:%H'` UMount BACKUP_DIR_REMOTE..." >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    umount -l ${BACKUP_DIR_REMOTE} &>> ${RSYNC_LOG}
    if [ $? -eq 0 ];then
        echo "`date +'%Y-%m-%d %H:%M'` UMount BACKUP_DIR_REMOTE Successful!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    else
        echo "`date +'%Y-%m-%d %H:%M'` UMount BACKUP_DIR_REMOTE Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
    fi
 
else
    echo "`date +'%Y-%m-%d %H:%M'` Mount BACKUP_DIR_REMOTE Failed!" >> ${BACKUP_DIR_LOG_BACKUP_DATE}
fi
