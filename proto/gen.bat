set PATH_PROTO=./proto/authentication_management_api.proto
set GO_OUT=.
set GRPC_OUT=.
set GRPC_GATEWAY_OUT=.
set OPENAPI_OUT=.

protoc -I. --go_out %GO_OUT% --go-grpc_out %GRPC_OUT% --grpc-gateway_out %GRPC_GATEWAY_OUT% --openapiv2_out %OPENAPI_OUT% --openapiv2_opt use_go_templates=true %PATH_PROTO%