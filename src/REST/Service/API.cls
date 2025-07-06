/// Add this class to Production, it is common entry point in Interoperability for all your APIs
Class REST.Service.API Extends (Ens.BusinessService, %REST.Impl)
{

/// Collecting metrics
Property CollectMetrics As %Boolean;

Parameter SETTINGS = "CollectMetrics";

Parameter HTTP429TOOMANYREQUESTS As STRING = "429 Too Many Requests";

/// Just add it to your impl class: Quit ##class(REST.Service.API).Call(body, $$$CurrentMethod, $CLASSNAME())
/// (requires a 'Include %occIO')
/// pRequest can be a null or %Stream.Object or %DynamicObject
ClassMethod Call(pRequest = {$$$NULLOREF}, pMethodName As %String, pClassName As %String) As %DynamicObject
{
    Do ..%SetContentType("application/json")
    
    Quit:..RateLimited(pMethodName, pClassName, .tSC) ..Error(tSC, ..#HTTP429TOOMANYREQUESTS)
    
    Set input = ##class(Ens.StreamContainer).%New()
    Set input.Stream = ##class(%Stream.GlobalCharacter).%New()
    
    Do input.Attributes.SetAt(pMethodName, "SourceMethod")
    Do input.Attributes.SetAt(pClassName, "SourceClass")

    If pRequest '= $$$NULLOREF {
        If pRequest.%IsA(##class(%Stream.Object).%ClassName(1)) {
            Do input.Stream.CopyFrom(pRequest)
        } Else {
            Do pRequest.%ToJSON(input.Stream)
        }
    }
    
    Quit:$CLASSNAME()'=$GET($$$ConfigClassName($CLASSNAME())) ..Error($$$ERROR($$$EnsErrBusinessDispatchNameNotRegistered, $CLASSNAME()))
	
	Set tSC = ##class(Ens.Director).CreateBusinessService($CLASSNAME(), .service)
	Quit:$$$ISERR(tSC) ..Error(tSC)
	
	Set tSC = service.ProcessInput(input, .output)
	Quit:$$$ISERR(tSC) ..Error(tSC)

    Quit ..Success(output)
}

/// API calls per minute can be limited. 
/// You can use a wildcard (*) as a method name to limit all application methods
ClassMethod RateLimited(pMethodName As %String, pClassName As %String, Output pStatus As %Status) As %Boolean
{
    Set pStatus = $$$OK
    Set appName = $REPLACE(pClassName, ".impl", "")
    
    Set route = appName_":"_pMethodName
    Set limit = $GET(^Ens.LookupTable("RESTRateLimits", route), 0)
    
    If limit = 0 {  // Check wildcard
        Set route = appName_":*"
        Set limit = $GET(^Ens.LookupTable("RESTRateLimits", route), 0)
    }
    
    Quit:limit<=0 0 // No limits

    Set ts = $ZDATETIME($HOROLOG, 3, 2)
    Set count = $GET(^REST.Rate(route, ts), 0)
    Set count = $INCREMENT(count)
    Set ^REST.Rate(route, ts) = count

    If count >= limit {
        Set pStatus = $$$ERROR($$$GeneralError, $$$FormatText("The limit for route %1 has been reached. Current call counter = %2 limit is %3", route, count, limit))
        Quit 1
    }

    Quit 0
}

ClassMethod Success(pOutput As Ens.StreamContainer) As %DynamicObject
{
    Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)

    If (pOutput '= $$$NULLOREF) {
        // You can set the HTTP status during the processing of the call in your Business Process
        If pOutput.Attributes.GetAt("Status") '= "" {
            Do ..%SetStatusCode(pOutput.Attributes.GetAt("Status"))
        }
        Set stream = pOutput.StreamGet()
		Quit $SELECT($iso(stream):{}.%FromJSON(stream),1:"")
	} Else {
        Quit ""
    }
}

ClassMethod Error(pStatus As %Status, pHttpCode = {##class(%CSP.REST).#HTTP500INTERNALSERVERERROR}) As %DynamicObject
{
    Do ..%SetStatusCode(pHttpCode)
    Do ##class(%CSP.REST).StatusToJSON(pStatus, .json)
    Quit json
}

Method OnProcessInput(pInput As Ens.StreamContainer, Output pOutput As Ens.StreamContainer) As %Status
{
    Set start = $ZHOROLOG
    Set appName = $REPLACE(pInput.Attributes.GetAt("SourceClass"), ".impl", "")
    Set methodName = pInput.Attributes.GetAt("SourceMethod")
    Set pOutput = ##class(Ens.StreamContainer).%New()
    Set target = $GET(^Ens.LookupTable("RESTRoutes", appName_":"_methodName))
    
    If target '= "" {
        Set tSC = ..SendRequestSync(target, pInput, .pOutput)
    } Else {
        Set errorText = "Route %1 not found. You need to add your routes to the RESTRoutes lookup table. "_
                        "For example: key = Sample.API.impl:TestGet, value = Sample.Process.TestGet, where "_
                        "Sample.Process.TestGet - it is a process that processes a GET /test API call."
        Set tSC = $$$ERROR($$$GeneralError, $$$FormatText(errorText, appName_":"_methodName))
    }

    If ..CollectMetrics {
        Set status = ##class(REST.Storage.Metrics).Log(appName, methodName, $ZHOROLOG - start, $$$ISERR(tSC))
        If $$$ISERR(status) $$$LOGWARNING($$$FormatText("Error in metrics collecting: %1", $SYSTEM.Status.GetErrorText(status)))
    }

    Quit tSC
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Set prod = ##class(Ens.Config.Production).%OpenId(##class(Ens.Director).GetActiveProductionName())
	Quit:'$iso(prod)
	
    Set className = ##class(REST.Process.CallHandler).%ClassName(1)
	For i=1:1:prod.Items.Count() {
		#dim item As Ens.Config.Item = prod.Items.GetAt(i)
		Set:$CLASSMETHOD(item.ClassName, "%IsA", className) pArray(item.Name) = ""
	}
}

}
