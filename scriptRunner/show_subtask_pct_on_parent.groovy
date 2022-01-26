def subTaskNum = 0
issue.getSubTaskObjects()?.each { subtask ->
    subTaskNum += 1
}

if (subTaskNum!=0){
    def subTaskOKNum = subTaskNum
    issue.getSubTaskObjects()?.each { subtask ->
        subtask.getResolution()!=null?subTaskOKNum -= 1: subTaskOKNum 
    }

	String pct_num = (int) (((subTaskNum-subTaskOKNum)*100)/subTaskNum)
    return pct_num + "%"
} else {
    return null
}
