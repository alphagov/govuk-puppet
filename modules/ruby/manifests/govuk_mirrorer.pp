# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class ruby::govuk_mirrorer (
  $govuk_gemfury_source_url
){
  package { 'govuk_mirrorer':
    ensure   => '1.3.1',
    provider => system_gem,
    source   => $govuk_gemfury_source_url,
    require  => Package['libxml2-dev'],
  }
}
