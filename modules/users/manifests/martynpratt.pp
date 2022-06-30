# Creates the user martynpratt for Martyn Pratt
class users::martynpratt {
  govuk_user { 'martynpratt':
    fullname => 'Martyn Pratt',
    email    => 'martyn.pratt@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIGa1v2kN8lXJ4WQU1/Vfw2UemSLf1dvhWQ6QP2lloz31Z2WGfsK5GxopTfmIIBCtM3ZCWjdg5XYokCUYM/wQV3062B2P3LU43qO4/06lTd2wmQGRjzzuMCUMZc6t/TiVClR5W5G14Ikzf7rWAKBdMiDw8syHsgbaiPrNZ/a0YX/QT5Geir6HCyXtB4K1iP8nHyBbrAznR9T+M4C5k7v8FUetLQAqCo8VTUFuYj3tvT5xMn9TALrHdDvomz9KqPNuOJcXqz6NN5ukBc8J0U8m9KVJjMGGj790FYUWkKiRyMgHPWJAaHGxNkD99azlIxjWoO37e9rfgoBDY+LV4jeI0JF0sY9vJN1QfqinOQuiJbnh9iCzymFKv7ivqEbho/BflbNGTKImjfDLOiU7I36B3jIgJud5HF3HET9D+l3FuCf9ZrjA/rdJNZFxs2OqBAqQ4GovrRb3gMEwd+EtMm7usoOOp8880dE6ASuDXi+FCzY9/HRIDmYd+QDN+FX6jFbLJq31fb9yqZQfoQhr2EFVyyb29YrlazGH6vqO9sIibdgw+OGrPQy5fHr/kwv8/sGwbevRViu4NbcetsizFUI9hVzrASzqlXLYbPP8ILwSdT6RVZKzseoCJ7Ket3fbDocCsvO8ildoL10loPdxySl2q8UOnPJ1D7nXTmeMkTWAHew== martyn.pratt@digital.cabinet-office.gov.uk',
    ],
  }
}
