# Creates brendanbutler user
class users::brendanbutler {
  govuk::user { 'brendanbutler':
    fullname => 'Brendan Butler',
    email    => 'brendan.butler@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjvOpkpGT2WT5SIQxYB1a59Z7JE9QjQoWQF2aNEtIQEuO7rBeCcgNMe2jLtUiXCY/vNoruT0iWm2hL7vJO3pqCSA1OXiSOHDJ7ZnEHtk9BeV0Fxbp7yE4Xyhm9RKfFkges9OqfBfkQROPrdZDB/G6vlqYBPi53w36NdDlxynbygWzrRS/8NEuQYqDS9yHAS+F/VfAhEchvUuHuyAdtA3VFNBUY2/dBxh25M4sATurVtR/KrkYZGxB+59yytkHVGrbMX6woheK9WcXiiqdtLz9xdeKSplo4VbXqIUeVJG+8fDCxRehWF2RriOOI3/8dS3bSkLDdIK9BMv8UF53TeKvGM8rqZvMzX+xwRYvJQsEVVc4SlqbhYjJcDSyv8VurepV0iKmiAC/Sw0P8+g9aJvOVDMqa3ardxJ1qlT5hKqrV/XQrklL3e5h6k4AnE+P5W86DyMXaWnTGHtkX04ChMj/ysnUJ6FHUGM5lBIfAl3jF3UQq7gSTYOw9ABccx8S34QcaGOZkerc6r0jV1FmBS7an9ADAwnpW0HQIVOY4wBKub0T+T2PCNtRTVWP64C5AL9s5N/yblwus4JtlW8ZNNg01xt67RtWaJXZ+ymB/+e+tn9h3gYyPVz92oOTZeIKT1E9wxEyZDDG42uDZ/AedGwNtEPP0pGf0btGBnR6ImK/o4w== brendan.butler@digital.cabinet-office.gov.uk',
  }
}
