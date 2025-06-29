Class Sample.Process.TestPost Extends REST.Process.CallHandler
{

Method OnRequest(request As Ens.StreamContainer, Output response As Ens.StreamContainer) As %Status
{
	Set jsonInput = {}.%FromJSON(request.StreamGet())
    $$$LOGINFO(jsonInput.input)

    Set response = ##class(Ens.StreamContainer).%New()
    Set response.Stream = ##class(%Stream.GlobalCharacter).%New()
    Do ({"message": "Data received successfully!"}).%ToJSON(response.Stream)
    Do response.Attributes.SetAt(##class(%CSP.REST).#HTTP201CREATED, "Status")

    Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
