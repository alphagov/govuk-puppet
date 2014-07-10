class ruby::govuk_seed_crawler (
  $govuk_gemfury_source_url
){
  package { 'govuk_seed_crawler':
    ensure   => '0.0.1',
    provider => system_gem,
    source   => $govuk_gemfury_source_url,
  }
}
