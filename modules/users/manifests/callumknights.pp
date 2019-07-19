# Creates the callumknights user
class users::callumknights {
  govuk_user { 'callumknights':
    fullname => 'Callum Knights',
    email    => 'callum.knights@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT/e+Pb4Od9QFUA9478EVAegwoc+Lm7j3nw/B2eyRpsYKZEYmQvCZTXVJPNwBvmitgzG6GH+vgr40X4/sOfOXfOjD1rQk8hCk7rbxEdFIjR0rhHNGkImnaVDzfeh2BwqLWfrYpJ10d10oTq/4RgDyJLrsv6esFs/C04Ih4AKQ/3O5WxulyxUeREsRwNUdCKAp/iE+HznGIcJTVFhrVgCM172wOM+RoLBNyinwQ5FURF2KdAcXANFQZbdjLGfCTuPrScxHPAqXW4Elgkqx9AiMVYYKfRceSN5vojtRtUHIf7dMInU0Ooy2SltqThbHxxbx1xVwkZvuIMjPpKByd+lb44Sjq+KSIJteSAVC8nX/tAH3R91V9lKjvZa2nFFNjCirGOhaKdvD69IuzXuXKzZ2FhJbXKLTvXskJqS0w66lD0uaYrmQYLe0DNAp7NhUYsFXw+6cVlxjPD+QdK5sf2tuu1wJOTzpU1iHas+pN3dIiciXGzaAyIKQI4whkx8559VexZ57PFk5Puv1ETvIIOCm8MYmb0++xgZS2IWnnPdbGqOB6zXKrNaLrvAJe3xIu2orFga+h9v/mP7xdTXEhymx4PBAT+WqZ5jR+JGSuUGzVdDaETsFcaPwh89oU01jsNJI1wpZJyIymkpUvd4Gy7afrgJQLWkTqawWiiH4bC84lvw== callum.knights@digital.cabinet-office.gov.uk',
  }
}
