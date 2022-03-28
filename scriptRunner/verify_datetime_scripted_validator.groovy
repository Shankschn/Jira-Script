import com.opensymphony.workflow.InvalidInputException
import java.sql.Timestamp
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.fields.CustomField
import java.text.SimpleDateFormat

def date = new Date()
def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
Timestamp ct_sj = Timestamp.valueOf(sdf.format(date))

String tmp1 = ct_sj.toString()
log.warn("创建时间：" + tmp1)

def tmp2 = tmp1.substring(0, 11) + "14:00:00.0"
log.warn("限制时间：" + tmp2)
Timestamp xz_sj = Timestamp.valueOf(tmp2);

def jr_rq = tmp1.substring(0, 10)
log.warn("今日日期：" + jr_rq)

CustomField cf = ComponentAccessor.getCustomFieldManager().getCustomFieldObject("customfield_10400")
String jf_rq = issue.getCustomFieldValue(cf).toString().substring(0, 10)
log.warn("交付日期：" + jf_rq)

// Simple scripted validator ScriptRunner
if (ct_sj>xz_sj && jf_rq==jr_rq) {
    return false
} else {
    return true
}

// Custom script validator ScriptRunner
//if (ct_sj>xz_sj && jf_rq==jr_rq) {
//    throw new InvalidInputException("交付日期错误。当前时间在 14 点之后时，只能选择明日或之后的日期。")
//}
