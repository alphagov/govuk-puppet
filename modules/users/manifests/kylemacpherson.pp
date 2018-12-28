# Creates the kylemacpherson user
class users::kylemacpherson {
  govuk_user { 'kylemacpherson':
    ensure   => absent,
    fullname => 'Kyle MacPherson',
    email    => 'kyle.macpherson@digital.cabinet-office.gov.uk',
    ssh_key  => [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJw+BTtFiD1WjCwOcenqFGqgXRUaaqwQ1i1NDeEHxsZPpCu4FrRTj6vPWhbDgYrI6RwZOFgAk544hDfr86C8g5AjvF9RhaNY3zfmm89Y9/HRFBUpd4XbgkmpGZoBbJuW8mKh1fn1ZfyJ4xAo0i/WHtt7lwZQxgKjdCr7gWLXQvbUJagEf4a01d3+4CqaPKt+XN3HQFxAj60IITEfwmHIaV6LJqUDWnJq/0TlNxlxIhWTvjdutM2Iuz25tZyycco49KOAdGYF0fBC95Rv/8jI4y/j/9o0GacaqjXJTMMejXSdWSE3KZoF8F8XNBJNCZrsWWyN7oFDHUhyjt3zS/EjUgYmqDzBaWz8WvQoxt2vzhL5p/+OJG81mR4JHBdUbKWSq6/e25t4liu1gjKP3Y+D+RMk31s9BrGcxMaxA5SZzywTAecfZ5Vlo/NQ+TUhtDgb0x69LSLVuXDOG9di/4qfH8DwzBH1/KLeIjXp2LJXgFswWcUltd0ir9jX8ltmHuwkbLpEtixXLgizuNI3cyStcfAxGPrjYLFBoVWek3seOHLBJLRqeyYW6vWiL96/EHGVmF3OzgeeMBpzJkXwwdMC8BqdwiGJAQ6PHViCSica3woPzSYuZfymLUPYuhODvZEtpUZ2Ctln6NKF+aJdQt85U3v7CfAtJAZGzToKmlWUwjiw== kyle.macpherson@digital.cabinet-office.gov.uk',
    ],
  }
}
