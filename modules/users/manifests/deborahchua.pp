# Creates the deborahchua user
class users::deborahchua {
  govuk_user { 'deborahchua':
    fullname => 'Deborah Chua',
    email    => 'deborah.chua@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5tqpYNPG5Qaa4/NpQKJ+pQwdDqcMMHDjhjm/oChR4/ZyYSztlzFKPbq0IHVGdeZVR4ourABwyqXjZoGkmrzcRRPgSegUhEzPh7aTpj1j+QoJsBmC4tcPMtVWWa8dLU7qO9iBJcZBGt2/hQnJbY+/MMXcWj91ixfBBPgGGKWw2ERG3iIvlW51qSeYXuyzmlqU/LCAef6IjjaM/Kyt9GTtOKDEfqo43RM++D07BOdaHW2naEVSBAIyiU2YJk044PzTzJ/KNPkyUA8+RXtoNkno2SM0xqvlbnl5zbxrIIoCcViQJetpqK+n6oSfKyn3J8YZn+R1B8i4uM375StqEmDlQXSdNdC85xD8DSicQh1+mHI4VBRDLkjvGiGHlxIuTTyFkyshw+/j03JDEkeUK5yYtwTstM+eG/s2pHyj4eaAdB0ycw9ONhIULFXoe2+jOayUZzCFV6z4aoxJzOJwBAktDXespOQnqz0LcCHBZXS8M55Ec1kEZ5o32tsSz19MhvQ/+4bWK5thzSUV8blU2EqqXzeSM881oIqgC7Z36K0cLDxf/fC4oMIQVSjtANRCgK0lez4bQ2/ao8FPGi5H/Qp6CizMVQCoZaDx8wMJJaHWx5qfFo3ulB6ttpGEMzaIBVqYN4RsfNebZKk0mHiwCEx6HDaNlhhSIwZsfrzYUApir1Q== deborah.chua@digital.cabinet-office.gov.uk',
  }
}
