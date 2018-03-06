# Create the benthorner user
class users::benthorner {
  govuk_user { 'benthorner':
    fullname => 'Ben Thorner',
    email    => 'ben.thorner@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCZW9wF+kWQh6rgtMniBb2J6P+hu/DBNP3bjs9Lnp9MvcqOCYjJxyHKZFzsH60p2KA3J42NvfMYGwYgJ8mHBHJKmI7oUW1ByG2a5GCb8ZH7hX3hcEAvkiSyW+piU6YNP23y7BuMK7NI70Rc158fXlLDSLff11mfnWsipZCWC1SGCtAwxqGofazvF79r7XXUVenUSy/IyfiNcUL7Vf+5+bEE69BiImZ7SRuGHm1bQSHMhLNFFanwlobttjPkf8q5UWlfWoHJHH9kkQUmZYuxuFU+AfWc+gxnY4sMCdljtl8O9c3UA+HQ9PsnqHPtNdVVjh5bgWmFn/kFM/0GGLu8TlMn25qeeMJ+WIzLyW+lzWng0Sc0+sdIHmqrr6Uv0MA1o7FDvMJRuxVlGawCGmTDKO4fJ43jmDhO4s56st/LbulH/ZLe77CXrz2Nka1OHC84TJQDaXLwo7Fd2TAi+/IJQbNHTzf/vEDgHhdvt0pLKFuAyYfw/6+VEWvgjMT8Px2XZgT+uqRLoE1L+OD6iYuOTE8tAzMdF48+rTpApnAKSIEAbXROVUOKUxT9QU6gBYP6Rdj0nTXs7MKttvqr54JO/4+cr5Jnv6TeeXUy7g7ZXw7sxtcSRk1Z1fjujntLA0dRIfxCJVf45cBb0slONPpTFrpoLus8mmMtosRcSKBivNgxIQ== ben.thorner@digital.cabinet-office.gov.uk',
    ],
  }
}
