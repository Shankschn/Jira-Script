import com.atlassian.jira.issue.Issue
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import com.atlassian.jira.component.ComponentAccessor

def issue = event.issue as Issue
log.warn(issue.key)
log.warn(issue.issueType.name)

if (issue.issueType.name == "子任务") { // issue.issueType.name
    
    def issue2 = issue.getParentObject()
    log.warn(issue2.key)
    log.warn( issue2.issueType.name)
    
    if (issue2.issueType.name == "任务") { // issue2.issueType.name
        
        issue = issue2

        def subTaskSum = 0
        issue.getSubTaskObjects()?.each { subtask ->
            subTaskSum += 1
        }
        // customfield_12210 自定义字段
        def tgtField = ComponentAccessor.getCustomFieldManager().getCustomFieldObject("customfield_12210")
        def changeHolder = new DefaultIssueChangeHolder()

        if (subTaskSum != 0) {
            def subTaskOKSum = subTaskSum
            issue.getSubTaskObjects()?.each { subtask ->
                subtask.getResolution() != null ? subTaskOKSum -= 1 : subTaskOKSum 
            }

            String jg = (int) (((subTaskSum-subTaskOKSum) * 100) / subTaskSum)
            jg = jg + "%"

            tgtField.updateValue(null, issue, new ModifiedValue(issue.getCustomFieldValue(tgtField), jg), changeHolder)
        }
    }
}
