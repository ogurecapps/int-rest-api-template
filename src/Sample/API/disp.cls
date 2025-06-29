/// Simple test API with two methods: get (some data) and post (some data)
/// Dispatch class defined by RESTSpec in Sample.API.spec
Class Sample.API.disp Extends REST.Core.Base [ GeneratedBy = Sample.API.spec.cls, ProcedureBlock ]
{

/// The class containing the RESTSpec which generated this class
Parameter SpecificationClass = "Sample.API.spec";

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 1;

/// Default the Content-Type for this application.
Parameter CONTENTTYPE = "application/json";

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Test GET method -->
  <Route Url="/test" Method="get" Call="TestGet" />
  <!-- Test POST method -->
  <Route Url="/test" Method="post" Call="TestPost" />
  <Route Url="/swagger" Method="get" Call="GetOpenAPISpec" />
  <Route Url="/healthcheck" Method="get" Call="Ping" /> 
</Routes>
}

/// Test GET method
ClassMethod TestGet() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") {
            Try {
                Do ##class(Sample.API.impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            }
            Quit
        }
        Set response=##class(Sample.API.impl).TestGet()
        Do ##class(Sample.API.impl).%WriteResponse(response)
    } Catch (ex) {
        Try {
            Do ##class(Sample.API.impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("Sample.API.impl","ExposeServerExceptions"))
        } Catch {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("Sample.API.impl","ExposeServerExceptions"))
        }
    }
    Quit $$$OK
}

/// Test POST method
ClassMethod TestPost() As %Status
{
    Try {
        If $CASE(%request.ContentType,"application/json":0,:1) {
            Try {
                Do ##class(Sample.API.impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType))
            }
            Quit
        }
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") {
            Try {
                Do ##class(Sample.API.impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            }
            Quit
        }
        If '$ISOBJECT(%request.Content) || (%request.Content.Size=0) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"body")) Quit
        Set pbody=##class(%DynamicAbstractObject).%FromJSON(%request.Content)
        Set response=##class(Sample.API.impl).TestPost(pbody)
        Do ##class(Sample.API.impl).%WriteResponse(response)
    } Catch (ex) {
        Try {
            Do ##class(Sample.API.impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("Sample.API.impl","ExposeServerExceptions"))
        } Catch {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("Sample.API.impl","ExposeServerExceptions"))
        }
    }
    Quit $$$OK
}

}
