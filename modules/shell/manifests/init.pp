class shell {
  file { '/etc/skel/.bashrc':
    ensure  => 'absent',
  }
  file { '/etc/profile.d/govuk-prompt.sh':
    ensure => 'present',
    source => 'puppet:///modules/shell/govuk-prompt.sh'
  }
}
