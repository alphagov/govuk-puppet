# Creates the davidjeche user
class users::davidjeche {
  govuk_user { 'davidjeche':
    ensure   => absent,
    fullname => 'David Jeche',
    email    => 'david.jeche@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDE/6DHMRG5sAL3Ms5wXfCPXyWKuxT4i9ct1Fh9djbpCtdEtgDNnu4p7N+W+wfQU8ZFZ2NvpYb/8aY1m14OIY6lHMNftEvDHf6VXUYXTN4n7fTW2V70ulNMZtL3KWYWwy0wZ4DfnMBbCYbrcCvcWtGXzaB6RNW2XRt4hh55aALc7Hq7nUsVy5RqoBiV27nWpQXE755/Pyc9BJ0IBOouu/E9jx8R7D3rb8U4idPJaBhAUpoDtSHHMiYQBh76C1tHZ/7MrYhCHE8FwsftBWjID9ZHN2tgySbjxmkzJbGJW7UUuFQJr8jBOcMReQe8+qNZ2Erhn/46al4X9YMZHS06jjGjSuD/welQu0aPJu2+rDLLoo913DnTUt9/gF+wiUHZrfPEN2j7157/c5X6fH2uEQRBQbH/7cLOYTRz6plXc4IcS52dWYdop9Cy5C8US7Zd8f671IIbT2AOoNkrvKlCF3gFjRxPGrQ6p2AGBZot2dPEaz6ZAQ4l/429yXgFsz+7ZsDS5EbjkH+pdgp282AFRB80hsri3c3KRbjbHEPdgXoI/NND9SKPSl5jpp1wdWkJ8zGxMKe3O7bcWFvsPmFABSeSWFLcnzFeb3JTL4pK01SJTG6e3fdMUmPjMCPpCa7oAglnNo03p+16YobanSSZYF90j8mkzlmmGVpKVjkugJbbMw== davidjeche@gds',
    ],
  }
}
