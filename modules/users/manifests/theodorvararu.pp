# Creates the theodorvararu user
class users::theodorvararu {
  govuk_user { 'theodorvararu':
    fullname => 'Theodor Vararu',
    email    => 'theodor.vararu@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCm1KYvsc5eYyprx1fQ1SLALpa4XbnQ1e7tH1LENlh+/kgI6QIYPLgn2dP8qbVRm9iQu8D7MQjK7AEYQrWx7nCOIH5hhlevJMOgHen1OTqh3xYqoy0WIyLXO0Ix8NfM+D66/IZurmEpB+iTd7JYUwo+xj8JyxLwEDmbxYZczjzgvwFcsTEKVZpxdpCXF4sjjISBIi+Orm9xsN6CCOw2KSaPHmITkxe6R5UUtezenfx5cfl9oF9qpPgfcFnh0yZ432EPkGRdpPQ0dM8Q56qJ6JbIimQLhxZ3p4BmX1F0w3XCOlof/JLdeYcfii57i8Ypt9OEK1Rxbn3RV+yX2L/um/Mb+QoEvKLVQt6OLmFVU6RT9EHcM2zEvDTW2lLGt7X+C7d3wfPugK5lBcJnte1vJV93mh/6WJ+QCpH3NHFlARHUEI3LP6LUgZ4OUtBsUw2tDWlZapkopZHo7xMMPkEMePx6JEejDvSHjNoze9W4GFEdmlcaphvlC6yNRR5AphsLnsn/PsDcKGfRwsx35rRRED//QuQf7T8k1QLtHLRgZreTdA+du2EEdBDsLWIoYTIt5bQo9+vdyLfmNtIwU6D0teEXulbeGrAxQ+tDUsJ7gkkuMHDCNx2xypPGyQ3ktKvAVMixh5Th1UPzX8EsLUYpvA886mYJkjgAdiz9AD86sAK+1Q== theodor.vararu@digital.cabinet-office.gov.uk',
  }
}
