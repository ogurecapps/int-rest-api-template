/// Inherit your API call handlers from this class for display connections in Production
Class REST.Process.CallHandler Extends Ens.BusinessProcess
{

/// Handle a 'Request'
Method OnRequest(request As Ens.StreamContainer, Output response As Ens.StreamContainer) As %Status
{
	Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
