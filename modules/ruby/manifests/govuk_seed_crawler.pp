# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class ruby::govuk_seed_crawler (
  $govuk_gemfury_source_url
){
  package { 'govuk_seed_crawler':
    ensure   => '0.4.0',
    provider => system_gem,
    source   => $govuk_gemfury_source_url,
  }
}
