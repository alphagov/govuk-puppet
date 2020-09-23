# Creates ovasiqbal user
class users::ovasiqbal {
  govuk_user { 'ovasiqbal':
    fullname => 'Ovas Iqbal',
    email    => 'ovas.iqbal@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9kI6Dv5GgmlGgHymBnCAAZabXaR8Df+OMZJN1iw/w7R4l9jqvPNa+G9Te5X5BE2TVLATsucd6jTzIDAIz2xGpWnEFt+I8REVKXfCHBKAoBLaIHqBOoW6U+eTvC8pUWMpjXSda2d6Ew/Ggj3R+VylyR4Ouq2cgxK3Dxlg1cm7nc34V0HsPZdxqzMR1BUGzDnUk+ehrgArsuNj1pxnmMK3YkoftLPIeIrBzfqQ7p6sg/k1eWwPumfoGQegA8fYaJshpM8wxIbL7N6EJ9GTg2PJMsN11BF7ko0qax+qwisAWOvXupm315U0D3LQ6Ikv88+SItqdalKu0Qkyt3Q22a1TM+uzfzrcc5Q0ZQmvtzftioCzkjw8bpDciagXMD7Q8rl5E35syzmR3jeiymamw31BBpRsAGHhWQoGY8xscvEUJKnXuWSb7Q9CG89MTOcfHgEWpx46bmjFqKSENOC9EcjlF7UxF7+aYvAC/3vWt1FiBF5Sw6BnjbanyCovR1TSqr7LogoJ95nY7oxUXrLnDmDGrF9z8MnXtTrDLBt6upttumb5O1uTbmrFVKPRDryYGgH81/YSLjeoRjj1NhruVGO7gRbzJe9fRWLgsWDGgxWlr1xqnxfD6sNSLmEJ0+x1FYwTtxM2CdzfrkqIT5q3y0BqbcdvWxlqE9bquy6NZd3tLHw==',
  }
}
