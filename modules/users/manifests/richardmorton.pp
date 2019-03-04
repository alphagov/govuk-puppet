# Creates the richardmorton user
class users::richardmorton {
  govuk_user { 'richardmorton':
    fullname => 'Richard Morton',
    email    => 'richard.morton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwcMaE5Ppb7zGW4rBe0zaWMHIzCi3KI0baVW8oqkwcyvksdw1M+T+2Qb3SDcmfqW5XAzyaJL2G3sXuwaUEkhF6sm/L0Sba/iaddwglnTn2lB3AW/b8AB2e96T3XnXA99R6VMZ8Xc4/D6bqPwm9c+B24mvXYYZcgGXv35a63FkQ7+gGAyCI7ry+DxMZ4fRTqD6yHbHAKIMVD/NFkmv/aZfnvi/nFxuV8qXdop81AmU4+zCemr7v/jAG4hxfZvWAzKu7yK+7EhawIFa3ATVmH8Gc5vI4RQeSoGGVZjQpW7zDRapPuYqWxEWS2Qpv5W+G/n5mf6bP8pkMvd7zofyKpgjznlPHg8Piveuc6w2mNgl01e43bV1dihOPwZS56G+P2IK1sFYno96rVfqENI9XhifNtV8upPS7aItP41VEnuybI4xcpz38eeftSNkNJKg0bKy10ZBi4QvrfJoMU8bO7vslNKxwGdlag4DMWdYHg2m/84QISkViRVBdGMUvaXXJB1HVRjIuhqw34fqe6oZMXw5rjy0Knn1s6oJfXeYCBcBQDkoyp0SyTY1a4Z3Rgpnq764h6GNYAJ7sZdKcDs+HKDw0hDYPzHebfx02nD5bfhrpHcQzSlbcLtAaEGfdriwgzXGfEMke255hPS6x4UhQnbSrnMvtQSye7r10EmGcvznVsw== richard@qmconsulting.co.uk',
  }
}
