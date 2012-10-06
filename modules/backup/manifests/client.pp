class backup::client {

    govuk::user { 'backup':
      fullname  => 'Backup User',
      email     => 'webops@digital.cabinet-office.gov.uk';
    }

}
