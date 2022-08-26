# Creates the benjamineskola user
class users::benjamineskola {
  govuk_user { 'benjamineskola':
    ensure   => absent,
    fullname => 'Benjamin Eskola',
    email    => 'benjamin.eskola@digital.cabinet-office.gov.uk',
    ssh_key  => 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCqhKxQmlo3pK4ndmm+IMjgafyOboRjytMn9/ptcyk0AcHeC8NPRyNqo1ni1Fl5y5CRzC5nyORyFt5MIV+7Oed8=',
  }
}
