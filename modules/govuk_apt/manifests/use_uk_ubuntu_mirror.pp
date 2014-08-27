# == Class: govuk_apt::use_uk_ubuntu_mirror
#
# Class to update the apt sources.list to point at the
# UK ubuntu mirror (gb.archive.ubuntu.com) instead of the US one.
#
class govuk_apt::use_uk_ubuntu_mirror {
  exec { 'use_gb_source_in_sources_list':
    command => "sed -i 's/us.archive.ubuntu.com/gb.archive.ubuntu.com/' /etc/apt/sources.list",
    onlyif  => "grep -q 'us.archive.ubuntu.com' /etc/apt/sources.list",
    before  => Class['apt::update'],
  }
}

