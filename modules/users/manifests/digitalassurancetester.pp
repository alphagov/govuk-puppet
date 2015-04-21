# Creates the digitalassurancetester user
class users::digitalassurancetester {
  govuk::user { 'digitalassurancetester':
    fullname => 'digitalassurancetester',
    email    => 'digitalassurancetester@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDwa8/GjKGHfXWjPdIQzMtsXiiPWIn3RXfh5v2Ek20DSSlfE9/lqU4TEYdo7D5KZtMQigDQp78f/RgrvkB/YxZSDVJ+e2+ky1lrY8H/cl1g+Ec3n01+deu9r4gf9JfYO+/7hrQt2/Li203Frpq4lHAUJX/xJuRTjJTILlOmgQHpclYuRap10NqDAsPoMEYS7zlW2sprHi3kA8f/TLtru0FdmIO24Oy47MRKZkRWq8YGEzrnRN9Ofm11IGJ+zSQOn2LKlYoYqLxWj9woMbPxz4XEan8oR0co54vF7F+vOMGzLKKvx/BV+Vvj1XAZK3c6XpIdELe3077Rvof6vHK3E9NMk08D8Xarkd8tSEUxuFU0DoGchGI4VmU5Omw2nWEaDdrtVDxRztq1kxPjh3JXQhCZUaQh6Icf/qA5hXm5UpakvI7DuuUC8m/EEIUue4SR9ipjZhgmmJkuqhUePqLhBjUScoSXq3cIbSlR8wxlHvleV9DvD1qYimjzVXHi3ZeRTWW+bTS3ej6VdxrPZP9VN0lQnKS1a0HJ/gcTIKxeRGjH8qQGSem+2/5Obtj2KYxIFpaZmMo0nbviVNxOBBE/NTn2FjFeZGHe5Lt9+RTfTla2TF3c/CoC0s7lUN/6YixaJIoWRPsVeqYL3BXYHyHVmHiD0j43LryfhjYGU72KOvOGw==',
  }
}
