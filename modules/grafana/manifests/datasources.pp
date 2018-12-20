# == Class: grafana::datasources
#
# Adds datasources to Grafana via its web API
#
# [*webapi_user*]
#   The user used to authenticate to the web API
#
# [*webapi_password*]
#   The password used to authenticate to the web API
#
# [*webapi_user*]
#   The user used to authenticate to the Logit Elasticsearch interface
#
# [*webapi_password*]
#   The password used to authenticate to the Logit Elasticsearch interface
#
# [*elasticsearch_endpoint*]
#   Logit Elasticsearch Endpoint URL to connect to
#
class grafana::datasources(
  $webapi_user = undef,
  $webapi_password = undef,
  $elasticsearch_endpoint = undef,
  $elasticsearch_user = undef,
  $elasticsearch_password = undef,
) {

  $graphitesourcejson = '{ "name":"Graphite","type":"graphite","url":"https://graphite","access":"proxy" }'

  $graphitesourceadd = shellquote([
    'curl','-f',"http://${webapi_user}:${webapi_password}@127.0.0.1:3204/api/datasources",
    '-X','POST','-H','Content-Type: application/json;charset=UTF-8',
    '--data-binary',$graphitesourcejson,
  ])

  $graphitesourcemisses = join([
    'curl',shellquote("http://${webapi_user}:${webapi_password}@127.0.0.1:3204/api/datasources/name/Graphite"),
    '2>/dev/null','|','grep',shellquote('{"message":"Data source not found"}'),
  ], ' ')

  $elasticsearchsourcejson = "{\
    \"name\":\"Elasticsearch\",\
    \"type\":\"elasticsearch\",\
    \"url\":\"${elasticsearch_endpoint}\",\
    \"basicAuth\":true,\
    \"basicAuthUser\":\"${elasticsearch_user}\",\
    \"basicAuthPassword\":\"${elasticsearch_password}\",\
    \"database\":\"*-*\",\
    \"jsonData\":{\"interval\":\"Daily\"}\
  }"

  $elasticsearchsourceadd = shellquote([
    'curl','-f',"http://${webapi_user}:${webapi_password}@127.0.0.1:3204/api/datasources",
    '-X','POST','-H','Content-Type: application/json;charset=UTF-8',
    '--data-binary',$elasticsearchsourcejson,
  ])

  $elasticsearchsourcemisses = join([
    'curl',shellquote("http://${webapi_user}:${webapi_password}@127.0.0.1:3204/api/datasources/name/Elasticsearch"),
    '2>/dev/null','|','grep',shellquote('{"message":"Data source not found"}'),
  ], ' ')

  exec{'ensure-graphite-source':
    require => [Package['curl']],
    command => $graphitesourceadd,
    onlyif  => $graphitesourcemisses,
  }

  exec{'ensure-elasticsearch-source':
    require => [Package['curl']],
    command => $elasticsearchsourceadd,
    onlyif  => $elasticsearchsourcemisses,
  }
}
