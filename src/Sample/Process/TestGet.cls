Class Sample.Process.TestGet Extends REST.Process.CallHandler
{

Method OnRequest(request As Ens.StreamContainer, Output response As Ens.StreamContainer) As %Status
{
    Set response = ##class(Ens.StreamContainer).%New()
    Set response.Stream = ##class(%Stream.GlobalCharacter).%New()
	Do ({"message": "Hello, world!"}).%ToJSON(response.Stream)

    Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
