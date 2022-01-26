import com.atlassian.jira.component.ComponentAccessor

String b = String.join("", cfValues['需求来源部门（新）'].name);
def groupManager = ComponentAccessor.getGroupManager() 
if(groupManager.isUserInGroup(issue.reporter?.name, b)) {
    return true
} else {
    return false
}
