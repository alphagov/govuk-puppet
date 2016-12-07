# Creates the digitalassurancetester2 user
class users::digitalassurancetester2 {
  govuk_user { 'digitalassurancetester2':
    fullname => 'digitalassurancetester2',
    email    => 'digitalassurancetester2@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCipoo+H7d+3WSsdoqXWuXYkLTl5qbVHP3FRnRS0mnWG4VY59nuwRaPlxQe9TkWDr4nYptdbjxTFshCYXYGSaMqcgPAP+EUmuakUCzb4uqAv2kD4V/9weI1pQTAKk9ARzA6XDKCYhSizboOC71EfA3Yfy/RcWFbRIgMMg4fSh5ATw9xQCFG9HgB+EgHsqzETg7t3MyJU8Qixd9ljtRD+r1//GEnn9JNduCu5K2ZUgyWAe6NCFDfurYnAX8cjSzva7Deky9dsJukE4o1dQ5OOKwftucqEDIObcp6eVc+/1uuW5X9zQGR/BeXN1kUn4gQWDx3vXmKflJjz2dmdTA84Q/4aDB+GQxZFWs0aSdc9wyhhIo3IQHRwSU4aZTrkvrywOx8HEIaU1egcxizsl+61nqvgg6+/4F39EudaFYhKek8EaEuY2UXaLYZZ0kLLyjvedTAFh1K2CDzkuPtl+KA6OYp9OzQW0YBfhGJCzpFXgWXdOo1DTOjHqiOYIJsUqZp/YnTJFGz9tKQ2d2L+bW/65pPdLLDhZPliJGY7CoY/cyUjhO/l/4uaqSiNi1aq/FNVbveEM1rmxpyiZd8875RrksLudu4U/lf5jkCp5w+nf+Bnfn56kDpxutWzAxLeN2wX+5e5tcKN9lL0IXhvNgE+P3ouq1ojGhBV4PANEW0wOBKKQ== user@computer',
  }
}
