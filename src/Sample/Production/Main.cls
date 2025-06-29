Class Sample.Production.Main Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Sample.Production.Main" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">10</Setting>
  <Item Name="Sample.Process.TestGet" Category="" ClassName="Sample.Process.TestGet" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Sample.Process.TestPost" Category="" ClassName="Sample.Process.TestPost" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="REST.Service.API" Category="" ClassName="REST.Service.API" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
