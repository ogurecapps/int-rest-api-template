Include %occIO

/// Simple test API with two methods: get (some data) and post (some data)<br/>
/// Business logic class defined by OpenAPI in Sample.API.spec<br/>
/// Updated Jun 28, 2025 10:47:08
Class Sample.API.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Returns a simple message
ClassMethod TestGet() As %DynamicObject
{
    Quit ##class(REST.Service.API).Call(, $$$CurrentMethod, $CLASSNAME())
}

/// It takes a JSON as input<br/>
/// The method arguments hold values for:<br/>
///     body, Inbound data<br/>
ClassMethod TestPost(body As %DynamicObject) As %DynamicObject
{
    Quit ##class(REST.Service.API).Call(body, $$$CurrentMethod, $CLASSNAME())
}

}
