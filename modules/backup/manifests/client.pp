class backup::client {

    govuk::user { 'govuk-backup':
      fullname  => 'Backup User',
      email     => 'webops@digital.cabinet-office.gov.uk';
    }

}
