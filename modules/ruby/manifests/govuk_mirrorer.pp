class ruby::govuk_mirrorer {
  package { 'govuk_mirrorer':
    ensure   => '1.3.0',
    provider => system_gem,
    source   => extlookup('govuk_gemfury_source_url'),
    require  => Package['libxml2-dev'],
  }
}
