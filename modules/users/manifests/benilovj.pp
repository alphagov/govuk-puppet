# Creates the benilovj user
class users::benilovj {
  govuk_user { 'benilovj':
      fullname => 'Jake Benilov',
      email    => 'jake.benilov@digital.cabinet-office.gov.uk',
      ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZlq/ByLPy7iB1R4KH5qocTGFk6g/U89fd9O1iyiABx99jf2ogBWjKQp9dkrS0NYMCrnFjPJZFM5Kn+Gz0/YQG2L22uWLsrMPlb8RBqPHPVurt4eFIPRCeZ+kEUNF7nK+vxsvEOnpaNzXzlYDCooB9UcwujgIsdeEPSelS4fmSi3Dg4/nSgf+HxiJYyI1CvBrQGtm9kgOFY4wpL6Y0Fnn7mTRGGvA9MXiGegHkBNIwaD8wAFvoIbt938uXXv+AWGIfCVMM8yLUag7QC10eBR0dfKSUqyChBhPpdMr6wWziaX3agwD66SGL0UyBmNvh2ZQvnr4Ur3w551VzQBZ8RbMhFRAG7nDzzheFJwtCwQ5cXts9n4jgwvuTfXH2peoh3IC5DrxvSeiJyhaIwKzwdzMBa+9t/KVt0+Wt4IpEMPxKXXmZPraaQ1Rm/9ompLXIlYYm06jnncsYJN1YTRpcz1FjRDTdIQbso7+3LK8uoHtjCVSDjPf2mk9jB7VEswSLqz8KFl4HnfgxWLV0mjdmjjsiaiT7SR7jzaAN3mMfb3BwKGkHV2IhNQe2OjwctEf2/9VZhwt73E4qbdRg1cn6OmGf7dV/+p8X9BI6dUEr0XnNfgVvG5zGSdjBmqIp/hYLyr9ly3iCv8ceKoHGF8j3X/1QwZHHTiUiJ5LJpWAT9jO2Tw== benilov@gmail.com',
    }
}
