# Creates the jackscotti user
class users::jackscotti {
  govuk::user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDunm3CoYCN02e6cqR2bcl27qddR5AuV2UbDogh3gSZeSMyDOHuar6dPUVGv8/RBKl7zGjhaSMWplZ8JCiFylxjCcsZw5crsjrc3k3lkmFda/jDdpq+9lNSCP/wRkNmicVnC6+TSj4cU7iNLHCo645jRVDoH8wfcrY3v8v4ac8oinIBINFp6Rul24byQ1TrnOCQlkYYB6tjmSypOE8sE/ev9ap+8KMj7dS75oyX4pmZbQP5YtPXNLwi/AQOBU4IP6kuOZ/BKkAtPRTa9t6UKefm8mJE4iGcYVzvwbJsTi4+T1oBvg9wT32uZ0TmO7Zab+QWpIJjAr+EqUtYS/UE0zSaIMG6yEEOSjTvzdogfLVQzDoHwaNC0AriBteUeABvXCe1/TtQtY81R8fbOf7WvRj5lsDgMrs8WEe+Bdk7ttiQoicv9P10NPRvw0okAGCcI3zxd9GKawWWiai+wHDsM2AJEP7O+i6jj6Hc5KIRj13be3bE4clrF2HLak7Hu0zdzDKYUCRxvn7yqLqK65MhTi0Ej0wA4AyWnnZfVEeZiGRi7B6ACyFgaAPG5ulZk8dTylgmgYhN6fLyiCnMXGKvORXLGdBh7OCZbCQXjGQFnjewbFrsrY4hechizwtbuVqiw5IJaxDz5suc2278OKk3vepiWV+EbFjlDAhXoG26uo6EQw== jack.scotti@digital.cabinet-office.gov.uk',
  }
}
