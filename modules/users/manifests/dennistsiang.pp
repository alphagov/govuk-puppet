# Create the dennistsiang user
class users::dennistsiang {
  govuk_user { 'dennistsiang':
    fullname => 'Dennis Tsiang',
    email    => 'dennis.tsiang@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYgI4fx7t+shqQvhvcgCeidhv/paUcU934cZEgB5km4MCk1dg1SdwMbrRt+93AE8W1xf7ZKHzno7HzS/gF9fm4Sa/2+odh18eavuz+71NpSWajs+6v0a5Voeqs49L/HNqZXPoRe5qaMRhRJdGrVwgXaXhwoefZIm41dK8NQ+WviTSbiM1t5/kwvPzXT/wYo4lDZ+KS8P59wsHHuqFB6GcO6ukfh1hwFOg1c0madtccdlBUKS472ID6iXTkcJeaYDC+eQMY3TywdF4gSBFB6/oFnORTbjGoaHrBZv93lP0FnSKM0vUlwfhq+EJu5/OMrziqz8z45j6L9bnZyJxt4uI8O5YJfPVRQzVh5lhHC1khMJLVm+OnEthEuDkO3Wxch3wVykoEn/JtxpHcP5EUaBOgBA+0CH3d38XZ3eNqrtaZJTwUBjx3SOchPrV8T0HKCqryUnm7WKpQ+N2GhweW2hgBuLmIhQiqUnfP0q8oasECY9Dn0Kvafp2LVRfj0y2LzcfOf26hZlZZHrVoJXTpD2/IP6rZWPgzv4hYu3AYJ77zWs+hys2L0zea5s23g8ofBlJsu6CBYcf/Wi9u7ZL4BezimokQcKUYgbfCSl6kIi3uVdSNuIXTGTUAhRFpnLYzZfBoO4y6Raen4MiiAE2mHJaf1ZKRXRsFgf1qrX0cNvva4w== dennis.tsiang@unboxed.co',
  }
}
