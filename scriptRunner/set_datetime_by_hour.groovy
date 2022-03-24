import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.event.type.EventDispatchOption
import com.atlassian.jira.issue.IssueManager
import com.atlassian.jira.issue.ModifiedValue
import com.atlassian.jira.issue.util.DefaultIssueChangeHolder
import java.sql.*

    
IssueManager im = ComponentAccessor.getIssueManager();
def cfm = ComponentAccessor.getCustomFieldManager()
def jfsj = cfm.getCustomFieldObjectByName("交付时间")
def tmp1 = issue.getCustomFieldValue(jfsj).toString()
def tmp2 = tmp1.substring(0, 13) + ":00:00"
Timestamp value = Timestamp.valueOf(tmp2);
String msg = "格式化 交付时间 " + tmp1 + " 为 " + tmp2
addMessage(msg)
def changeHolder = new DefaultIssueChangeHolder()
jfsj.updateValue(null, issue, new ModifiedValue(issue.getCustomFieldValue(jfsj), value), changeHolder)
