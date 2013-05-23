class ruby::govuk_mirrorer {
  package { 'govuk_mirrorer':
    ensure   => present,
    provider => gem,
    source   => "https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/",
    require  => Package['libxml2-dev'],
  }
}
