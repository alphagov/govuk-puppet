class backup::client {

    user { 'backup':
      ensure     => present,
      comment    => 'Backup User <webops@digital.cabinet-office.gov.uk>',
      home       => "/home/$title",
      managehome => true,
      groups     => ['backup'],
      require    => Group['backup'],
      shell      => '/bin/bash',
    }

  govuk::user { 'backup':
      fullname  => 'Backup User',
      email     => 'webops@digital.cabinet-office.gov.uk';
    }
}
