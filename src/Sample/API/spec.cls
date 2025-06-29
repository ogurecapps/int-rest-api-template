Class Sample.API.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "version":"1.0.0",
    "title":"Test API",
    "description":"Simple test API with two methods: get (some data) and post (some data)",
    "contact":{
      "name":"Andrew Sklyarov",
      "url":"https://www.linkedin.com/in/andrey-sklyaroff",
      "email":"coder1cv8@gmail.com"
    },
    "license":{
      "name":"Apache 2.0",
      "url":"https://www.apache.org/licenses/LICENSE-2.0.txt"
    }
  },
  "basePath":"/v1",
  "schemes":[
    "https"
  ],
  "consumes":[
    "application/json"
  ],
  "produces":[
    "application/json"
  ],
  "security":[
    {
      "basicAuth":[
      ]
    }
  ],
  "securityDefinitions":{
    "basicAuth":{
      "type":"basic"
    }
  },
  "paths":{
    "/test":{
      "get":{
        "tags":[
          "Default"
        ],
        "summary":"Test GET method",
        "description":"Returns a simple message",
        "operationId":"TestGet",
        "responses":{
          "200":{
            "description":"Successful Response",
            "schema":{
              "type":"object",
              "properties":{
                "message":{
                  "type":"string",
                  "example":"Hello, world!"
                }
              }
            }
          },
          "500":{
            "description":"Error Response",
            "schema":{
              "$ref":"#/definitions/ErrorModel"
            }
          }
        }
      },
      "post":{
        "tags":[
          "Default"
        ],
        "summary":"Test POST method",
        "description":"It takes a JSON as input",
        "operationId":"TestPost",
        "parameters":[
          {
            "in":"body",
            "name":"body",
            "description":"Inbound data",
            "required":true,
            "schema":{
              "type":"object",
              "properties":{
                "input":{
                  "type":"string",
                  "example":"Test input"
                }
              }
            }
          }
        ],
        "responses":{
          "200":{
            "description":"Successful Response",
            "schema":{
              "type":"object",
              "properties":{
                "message":{
                  "type":"string",
                  "example":"Data received successfully!"
                }
              }
            }
          },
          "500":{
            "description":"Error Response",
            "schema":{
              "$ref":"#/definitions/ErrorModel"
            }
          }
        }
      }
    }
  },
  "definitions":{
    "ErrorModel":{
      "type":"object",
      "properties":{
        "errors":{
          "type":"array",
          "items":{
            "$ref":"#/definitions/ErrorDetail"
          }
        },
        "summary":{
          "type":"string",
          "description":"Summary error message"
        }
      },
      "required":[
        "errors",
        "summary"
      ]
    },
    "ErrorDetail":{
      "type":"object",
      "properties":{
        "code":{
          "type":"integer",
          "format":"int32",
          "description":"Error code"
        },
        "domain":{
          "type":"string",
          "description":"Error domain or category"
        },
        "error":{
          "type":"string",
          "description":"Full error message"
        },
        "id":{
          "type":"string",
          "description":"Error identifier"
        },
        "params":{
          "type":"array",
          "items":{
            "type":"string"
          },
          "description":"Additional parameters related to the error"
        }
      },
      "required":[
        "code",
        "domain",
        "error",
        "id"
      ]
    }
  }
}
}

}
