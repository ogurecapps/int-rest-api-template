/// Adds an online OpenAPI specification and "health check" to a typical REST API on IRIS. 
/// You need to inherit your <b>disp</b> class from this one and add routes: 
/// <Route Url="/swagger" Method="get" Call="GetOpenAPISpec" />
/// <Route Url="/healthcheck" Method="get" Call="Ping" />  
Class REST.Core.Base Extends %CSP.REST [ ProcedureBlock ]
{

ClassMethod GetOpenAPISpec() As %Status
{
    Set tSC = ##class(%REST.API).GetApplication($REPLACE($CLASSNAME(),".disp",""), .spec)
    Quit:$$$ISERR(tSC) tSC

    Do ##class(%REST.Impl).%SetStatusCode(##class(%CSP.REST).#HTTP200OK)
    Do ##class(%REST.Impl).%SetContentType("application/json")
    Do ##class(%REST.Impl).%WriteResponse(spec.%ToJSON())
    
    Quit $$$OK
}

ClassMethod Ping() As %Status
{
    Do ##class(%REST.Impl).%SetStatusCode(##class(%CSP.REST).#HTTP200OK)
    Do ##class(%REST.Impl).%SetContentType("application/json")
    Do ##class(%REST.Impl).%WriteResponse({"message": ($$$FormatText("Server time: %1", $ZDATETIME($HOROLOG,3)))}.%ToJSON())

    Quit $$$OK
}

}
