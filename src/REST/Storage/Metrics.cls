Class REST.Storage.Metrics Extends %Persistent
{

Property AppName As %String(MAXLEN = 100) [ Required ];

Property MethodName As %String(MAXLEN = 100) [ Required ];

Property CreatedAt As %TimeStamp [ InitialExpression = {$ZDATETIME($HOROLOG, 3)}, Required ];

Property DurationSec As %Numeric(SCALE = 3) [ Required ];

Property IsError As %Boolean;

Index AppNameMethodNameIdx On (AppName, MethodName);

Index IsErrorIdx On IsError [ Type = bitmap ];

ClassMethod Log(pAppName As %String, pMethodName As %String, pDurationSec As %Numeric, pIsError As %Boolean = 0) As %Status
{
    Set metric = ##class(REST.Storage.Metrics).%New()
    Set metric.AppName = pAppName
    Set metric.MethodName = pMethodName
    Set metric.DurationSec = pDurationSec
    Set metric.IsError = pIsError
    
    Quit metric.%Save()
}

Query GetSensors() As %SQLQuery(CONTAINID = 0, ROWSPEC = "AppName:%String, MethodName:%String, MinDurationSec:%Numeric, MaxDurationSec:%Numeric, AvgDurationSec:%Numeric, SumFailed:%Integer, SumSuccessful:%Integer") [ SqlProc ]
{
    select 
        %exact(AppName) as AppName, 
        %exact(MethodName) as MethodName, 
        min(DurationSec) as MinDurationSec, 
        max(DurationSec) as MaxDurationSec, 
        avg(DurationSec) as AvgDurationSec, 
        sum(case when isError = 1 then 1 else 0 end) as SumFailed, 
        sum(case when isError = 0 then 1 else 0 end) as SumSuccessful 
    from 
        REST_Storage.Metrics 
    group by 
        AppName, 
        MethodName
}

Storage Default
{
<Data name="MetricsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppName</Value>
</Value>
<Value name="3">
<Value>MethodName</Value>
</Value>
<Value name="4">
<Value>CreatedAt</Value>
</Value>
<Value name="5">
<Value>DurationSec</Value>
</Value>
<Value name="6">
<Value>IsError</Value>
</Value>
</Data>
<DataLocation>^REST.Storage.MetricsD</DataLocation>
<DefaultData>MetricsDefaultData</DefaultData>
<IdLocation>^REST.Storage.MetricsD</IdLocation>
<IndexLocation>^REST.Storage.MetricsI</IndexLocation>
<StreamLocation>^REST.Storage.MetricsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
