import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.MutableIssue;
import com.atlassian.jira.issue.IssueManager;

CustomField tempEpicName = ComponentAccessor.getCustomFieldManager().getCustomFieldObjectByName("Epic Link")
IssueManager issueManager = ComponentAccessor.getIssueManager();
MutableIssue epic = issueManager.getIssueObject(
    (String)issue.getParentObject().getCustomFieldValue(tempEpicName)
);
if (epic) {
    // customfield_10005 = Your Epic Name Field
    CustomField strEpicName = ComponentAccessor.getCustomFieldManager().getCustomFieldObject("customfield_10005")
    String fh = epic.getCustomFieldValue(strEpicName)
    return fh
} else {
    return null
}
