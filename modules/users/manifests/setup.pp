class users::setup {
  include shell
  package { 'zsh':
    ensure => latest,
  }
  group { 'admin':
    name        => 'admin',
    gid         => '3000',
  }
  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    shell       => '/bin/bash'
  }
  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
    require => User['deploy'],
  }
  if $::govuk_platform == 'preview' and $::govuk_class == 'support' {
    $mysql_host = 'rds.cluster'
    $mysql_user = 'backup'
    /*  WARNING: this fallback is in place to keep the rspec build happy.
        However, it will fail silently if the external data is not present,
        for example if deployed with the wrong version of the CSV file.
    */
    $mysql_password = extlookup('mysql_preview_backup', '')

    file { '/home/deploy/.my.cnf':
      ensure  => file,
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0600',
      require => User['deploy'],
      content => template('users/my.cnf')
    }
  }
  ssh_authorized_key {
    'deploy_key_minglis':
      ensure  => present,
      key     => extlookup('minglis_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_heathd':
      ensure  => present,
      key     => extlookup('heathd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_fberriman':
      ensure  => present,
      key     => extlookup('fberriman_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_paulb':
      ensure  => present,
      key     => extlookup('paulb_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_garethr':
      ensure  => present,
      key     => extlookup('garethr_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_james':
      ensure  => present,
      key     => extlookup('james_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_mwall':
      ensure  => present,
      key     => extlookup('mwall_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jordanh':
      ensure  => present,
      key     => extlookup('jordanh_key', ''),
      type    => 'ssh-dss',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_dafydd':
      ensure  => present,
      key     => extlookup('dafydd_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jenkins':
      ensure  => present,
      key     => extlookup('jenkins_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_annashipman':
      ensure  => present,
      key     => extlookup('annashipman_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jamesweiner':
      ensure  => present,
      key     => extlookup('jamesweiner_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_davidt':
      ensure  => present,
      key     => extlookup('davidt_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_mazz':
      ensure  => present,
      key     => extlookup('mazz_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_robyoung':
      ensure  => present,
      key     => extlookup('robyoung_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_alext':
      ensure  => present,
      key     => extlookup('alext_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jabley':
      ensure  => present,
      key     => extlookup('jabley_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_jamiec':
      ensure  => present,
      key     => extlookup('jamiec_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_kushalp':
      ensure  => present,
      key     => extlookup('kushalp_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_bradleyw':
      ensure  => present,
      key     => extlookup('bradleyw_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_ppotter':
      ensure  => present,
      key     => extlookup('ppotter_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_ssharpe':
      ensure  => present,
      key     => extlookup('ssharpe_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_carlmassa':
      ensure  => present,
      key     => extlookup('carlmassa_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_joshua':
      ensure  => present,
      key     => extlookup('joshua_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    'deploy_key_eddsowden':
      ensure  => present,
      key     => extlookup('eddsowden_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    }
}
