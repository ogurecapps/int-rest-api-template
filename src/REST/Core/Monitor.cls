/// Monitoring via REST
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCM_rest#GCM_rest_metrics_application
Class REST.Core.Monitor Extends %SYS.Monitor.SAM.Abstract
{

Parameter PRODUCT = "rest_api";

Method GetSensors() As %Status
{
    Set rset = ##class(REST.Storage.Metrics).GetSensorsFunc()

    While rset.%Next() {
        Set appName = rset.%Get("AppName")
        Set methodName = rset.%Get("MethodName")
        Set minDurationSec = rset.%Get("MinDurationSec")
        Set maxDurationSec = rset.%Get("MaxDurationSec")
        Set avgDurationSec = rset.%Get("AvgDurationSec")
        Set sumFailed = rset.%Get("SumFailed")
        Set sumSuccessful = rset.%Get("SumSuccessful")

        Set labels("app") = appName
        Set labels("method") = methodName

        Do ..SetSensorLabels("process_failed_total", sumFailed, .labels)
        Do ..SetSensorLabels("process_successful_total", sumSuccessful, .labels)
        
        Set labels("type") = "min"
        Do ..SetSensorLabels("process_duration_seconds", minDurationSec, .labels)

        Set labels("type") = "max"
        Do ..SetSensorLabels("process_duration_seconds", maxDurationSec, .labels)

        Set labels("type") = "avg"
        Do ..SetSensorLabels("process_duration_seconds", avgDurationSec, .labels)

        Kill labels
    }

    Quit $$$OK
}

}
