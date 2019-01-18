# Creates the nickcolley user
class users::nickcolley {
  govuk_user { 'nickcolley':
    ensure   => absent,
    fullname => 'Nick Colley',
    email    => 'nick.colley@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnjErrzaQCWzOHMsPqYXPo6r1ChNu1RhOu58FArbwkj8gv8QToSvF/EZAzMnWdKnNGumaN4j3fVSR/CeITuNa2Syook+k5wCpIa8W+o9XYf/enPz3QMsOVBZnf3qMjzO0TVc/uTsbiopqqMLgwyOhK1wAUumDcjKqf+3hlZ9hQ4PZ8l1cVKSumIFMGAJWyuhBnBX3kgh4wNC8BU/iR7WGP/48kfzg64g4Fw5GLzSe1MpozzskvjRYaHtF6efuDszy4Z5wOiznU/lqhE7a4IAyVAgtTBMSjhIAYVyyYqnS0JcYzTii1v3LV9czSBfsZcUBs1RHQQSy0i0AV5DtasQVUTHsoeN75EpISXG5YoJX1gLnnoJaU4RFs73fgtpW/GDYR0dPQzdpSS8ruJCOkDYDGcyTHD39d/cLJbQMHAR2XfpLyTz/VFOIKvBUeEB7gAZDzhBuSg1cqzZqiyD77R/aRzpqOYRu7uJyMI0kvdt1/iycVaXSPQI9X6OlfujFna+u3SgkY6KAO9Pip04WTtznmHa3fvdGNPwMf81cDl4oSc/FBVYlxcordIAs/8h6P7oqY5KYlq1sSel+VDgz4evO8LHpGPNMZmclYPA+xN3W6A7VX+78y3XRJTCZj8JOhjxAOpZdix1lPgtsrctiEcpyBAlg84QCVTPijV4aI7KrrbQ== nick.colley@digital.cabinet-office.gov.uk',
  }
}
