# Creates the leenagupte user
class users::leenagupte {
  govuk_user { 'leenagupte':
    fullname => 'Leena Gupte',
    email    => 'leena.gupte@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCZR0b38YB8xwcvKPW5l2OrbYh3ON/xSEu8NCtDM9aO4bqhsdDjI3rwr6VPSWtP8SaY7Kib2rx5Ocp/GnvXtMvq56zMAKh5P+cB9cn9OppSE/Gh03zXebfwW6h89qx2DpMZ/p0DDE6MuAY1Zc2ZMFSh6ySzlQejNbtVyW5JdQvdZWAnszTJhElerW3v1ZVfEIqfg5yuz1QYhVochJMgq+j1wQCrn3sQrsmN6mxowerpF1GuCQYha+G4Wvh60Yxf1B7W418cJCoOESxzmCywgPJ9DQ4aobNGy1qBGia5jTOKDW1Jfnv3IJGuXq3ej0Bxu7hC4wKSiaTlm/45JWOfJ9rEaRwRn2ic/V5aENXESAzz7VhtydCNqdNtFSkhY/iKMUPGQBuTi3t3eihZOtZum9SCeaXarQijWK5lQpV4fypS4FnYOlAuVm6jPb+1d7slPFsUm3CHRlACHTjM14ugc6MGVvjRfBiSM/7DKRfrVBWFPYMlmF2zF33LmPJzEqZYugOL8b7g/CNVGxKY1QUqH8w7p2ImDCehfcsVUYvOm8LSh81mpIK5oc2l1ITjbOc2sI6ZEDuvvDfumta+1b/wH7v7HZSO09HHhEEVqJsUDQAV1eJML2PPXR9yILZAv/hqHoYxtAimwUZPzU3OB3AhX5LGHrrYKiLlyOMqjL5ZwO6a8Q== leena.gupte@digital.cabinet-office.gov.uk',
  }
}
