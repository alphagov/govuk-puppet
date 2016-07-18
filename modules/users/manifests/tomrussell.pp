# Creates the tomrussell user
class users::tomrussell {
  govuk_user { 'tomrussell':
    fullname => 'Tom Russell',
    email    => 'tom.russell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAvriPWs4sYYXlJKh6ZjlrYdLXQYTOhgHrNiw3mMwzzv3Gf0HRg99l+ILKvpIrgaGNMdrGPJpdUYRiK/D+5MiYmwTxLY4QBjCPz5r4CUYG36Hej6YDliaUgOSB+dVMrMnZzvaS8Ubuu6VwPHjVkvnWGDSAVAr7oAlsXwbjy+YdaHHNgMfFca3Pazfqam/H4lvBvwrbx22CStRfuB0ovVHu6ObJanMeMAbsO3iJEEjxck+o542Uk8y2GYOFXUEY0wuU+/XvNV+o4DIgdSW4kMYLd7kkg0Ro0bPqAyYlYyTNMVF51ZS5JBYzgsnwYENleo+T99TyLOQrOuJSdIMMQ5ilsaa+XbwTGNDhEXITnI3dzhuyp5loqbVtPu+Ee6NyckiIVz1NOrKpRoKHk6mFZhcZ0XvVTLQsKeImFqWbaImhJZ3Wkd+SsuaXnFt6Pz0Cwc6mTSDJTZcJ+twheA7+YvGvkTluZjYr0ulHTHs/C9hwIjFqNv4TAYxmXA5Eajzz+j237h5nQXyyHjZ0+eLC1neXuMXY8zsw4ZKhCOxN2AWK1256d+jvfObXkrVx7IPuvVkt9IOi+Zf/9YW+JydTTi5JUczesV93EGtN498Lp4R2SSyZC64AumJLYPMCZUmWkl2Xyt0drJIxeHEYSt0i1hfFj4okxF/YIAY8mkzKgvLKbAs= trussell@toms-mbp.local',
  }
}
