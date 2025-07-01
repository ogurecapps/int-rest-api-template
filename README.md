# Interoperability REST API Template
Yet another API template for the InterSystems IRIS Data platform<br><br>
![Production](https://raw.githubusercontent.com/ogurecapps/ogurecapps.github.io/refs/heads/master/screen.png)
## What's new?
Added performance sensors and failed/successful request counts. All metrics are provided in [OpenMetrics](https://openmetrics.io) format. So, you can grab it with [Prometheus](https://prometheus.io) and visualize it in [Grafana](https://grafana.com). Details about setting up monitoring in the IRIS can be found [here](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCM_rest). Don't forget to check the roles of `api/monitor` application and to enable custom sensors in the IRIS terminal:
```
zn "%SYS"
d ##class(SYS.Monitor.SAM.Config).AddApplicationClass("REST.Core.Monitor", "YOUR_NAMESPACE")
```
## About
Features from the box:

- Adds online [OpenAPI 2.0](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md) specification (see `/swagger` endpoint) to your APIs
- Adds `/healthcheck` endpoint - a simple way to check API publication
- Metrics in [OpenMetrics](https://openmetrics.io) format are included
- And main: adds to all your API common entry point in Interoperability (Production). That, in turn, allows you to use the best IRIS feature - visual traces! :fire:
## Quick start
1. Implement the needed API using a [specification-first way](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_intro)
2. Add to your `.disp` class routes `/swagger` and `/healthcheck` (see `Sample.API.disp` for example)
3. Add calls `REST.Service.API` to your `.impl` class (see example in `Sample.API.impl`)
```
Quit ##class(REST.Service.API).Call(body, $$$CurrentMethod, $CLASSNAME())
```
4. Add to Production `REST.Service.API` service
5. Create and add to Production handlers for the methods of your custom API. Set `REST.Process.CallHandler` as the parent class if you need correct links building in Production UI. You can find a sample of handler in the `Sample.Process.TestPost` class
6. Add routes for API methods to the `RESTRoutes` lookup table (sample `RESTRoutes.LUT`)
7. Enjoy! :sunglasses: