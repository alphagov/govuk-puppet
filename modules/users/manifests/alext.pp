# Creates the alext user
class users::alext {
  govuk::user { 'alext':
    fullname => 'Alex Tomlins',
    email    => 'alex.tomlins@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEgfmhnlrUBF5i39bRssSJDaPvSxOn+cGUv2W+nliyExgbzxjIjE/qsbzPONyp1S1eBj2//EdLXR0ywzafNtLYG20dETF4RYGrULzww7RdX9KoJoLcujQy/T2+EbjcbuA+WXe9NLARSod3Sba+udFxV9uoVcVvHl659aVIKOe0I4iiu14XySn46NEXwmoL904bdqqc4FyBAYD1ch0uk2O5233TEwC32tQ4EENLTRsClYIGy2Pnq0h0gI8F031JMSuzYuum9CR4F1BkrrOJ+t7RJAy6rp8wuSrZM9Y6VLwMRHDbGStq3mNBZK4f7ZsIcaJwaCv2rtLYoZEmEjSQNVeP',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAX9REw1y0fcZRaQLJ2xC3dkBODCcsd4rsJGaHlvSGd54n5TJD9gZUakC7EJIsIREGxI5DuadFuu6aFrnIoVythF7dnULfgoDaGx7rKJXTpRewbhlE2r+dLhOOBMIXKstGWoF4YCo5JTE0paegQZtwpcX8YUhO6XpD0iAubOw85J5+fJqxoHZ70tzRbg8p4ts1pWNvZMrNQzte4osDdytxPEaR29srKMADojqkm62tX0hT7Vt97LAPmiwz/oWh/OhTI3qJGGMQQz323tTtE1VQeoGXI4zOaFjihyV3tqJn5ZY1qbGVGIIJMhn9vKhCwMo5PEnfuWZZKg15hIPN2tbV alex@anduril'
    ],
  }
}
