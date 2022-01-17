#!/bin/bash
#远程备份后 远程机器本地备份 两份备份。
 
SRC_PATH=/data/jira_wiki_backup
DST_PATH=/data/jira_wiki_backup_old
RSYNC_LOG=/data/rsync.log
rsync -av --ignore-existing --delete ${SRC_PATH}/  ${DST_PATH}/ &>> ${RSYNC_LOG}
