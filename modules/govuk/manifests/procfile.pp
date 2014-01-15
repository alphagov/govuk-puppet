class govuk::procfile {
  file { '/usr/local/bin/govuk_run_procfile_worker':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_run_procfile_worker',
    mode    => '0755',
  }
}
