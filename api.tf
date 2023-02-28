resource "aws_api_gateway_rest_api" "api" {
        name = "api-gateway"
        description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://upwardmobility.online/{proxy}"

  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}
#resource "aws_api_gateway_domain_name" "domain" {
#  domain_name = domain_name
#  certificate_name = "example-api"
#  certificate_body = "${file("${path.module}/upwardmobility.online/example.crt")}"
#  certificate_chain = "${file("${path.module}/upwardmobility.online/ca.crt")}"
#  certificate_private_key = "${file("${path.module}/upwardmobility.online/example.key")}"
#}
#resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
#  api_id      = "${aws_api_gateway_rest_api.api.id}"
#
#  domain_name = "${aws_api_gateway_domain_name.domain.domain_name}"
#}