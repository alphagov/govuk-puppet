# Creates the user chrisbanks for Chris Banks
class users::chrisbanks {
  govuk_user { 'chrisbanks':
    fullname => 'Chris Banks',
    email    => 'chris.banks@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrx4EHsIPpeSOcGXu0aR0ndmbAdzEJn3OQomYLODd8h3r+RPWlerAX3mNyKVmUHsD2TsPzB+Ci7DLU6O9IE06cgqect4P9TrNgQGnp0b6li+CHUN8Uspbyoc4ApWVqA7B5BRWpaPpzquiiFhhSc2Tj/Yn0TqvZYUpDT4EHq9luyygveD31kLcoU3kuuujLpFRN1syLszf6FoIRklnH4Q0KQRIDRaY/AS41Zll8oNqR30mGZ5UPKmHioUeubSLDfMVzl9O0cN4g1mXFKCcwmt6RVyawyA++5g+Sfa3OA/u4QooRx9QkXlk1h1gyb2EeNn2fQt6/42kPfZ96SS141Pffs8/VqruSwuZiilZMWHFa+xQjyrnkBCJwRkX0AofgVPf2dfZiFZklreT7LQIqpXMNwy7otgOL+1zhIPNIEk/Id4fik2fZ0j0qTevmsgkPAhsDRPtxUn7+bkYTO0bDVxDPJMidhk1rCshqoPb3j9YB7s0SPHPXe9CFbi5wRCvAmWMLRLILzedD4wPKf+FlREry2XPe7NsBd3ORBedhhqFYbIuWLL4ajvwcdE6oo1UXWzek1E8nNZO/bVjV/QvExY29kIoWrqdrwx1GnpI1Pzcfc8HQuru2xhFvgPf6qXqYZ19NwVoDmorDwPASW+gxmeDdjeku9PSCCQVDnn/GmFVdAw== chris.banks@digital.cabinet-office.gov.uk',
    ],
  }
}
