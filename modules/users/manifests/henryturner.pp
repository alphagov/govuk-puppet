# Creates the henryturner user
class users::henryturner {
  govuk_user { 'henryturner':
    fullname => 'Henry Turner',
    email    => 'henry.turner@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEI+exhJ8u7p2SrlAemxLQMuNr5dKzWIeJcvWY+pGLQXFlpkbFjSU4o+8FAGQuOFofTgC3eBriiWUBKdC6mAcF1OjJszPgrQePAGfCvvYK/C+3Pjsw9BQUACTNHLx3ufh5qirgxRSp21hyclfhjzQUZiQEIUhoUhzqL6IuvpHMvGem3IjpKpLQlL/38wAtxZtXXFL12d9I5ys7qvUZ2jofkxxBDujQ9qXqwUPV22waT9dGAJweCHXkOcTKN+QQYNube+mg0W1fKDOolsX9WkXnCdJATqO2CpLY8MJxC2iz+08zwXiJHOYeC5fpF58RXGof4yUxhbyJJ6Bdo7sKoE9eacp9J50m+jcj5Of3Z3DOeHOFO9GfocXHPNlN948X50bDhQkyKRIuny2GFU7D/0A+/QVrQGocx/lNDo3fZCuvUpcgSUA6VHFWwqXcIRPu2CLE3VniNVIsvXoBbIIWL9RDVgEDAtmUOnX+o9n4PaWkyw87nRN4QH0HJtv97KRAIvZN1fO5PDBcOZkFa10BF1ajT9NyK9t7kfIMmWyHXKQz1gQkJ72YaU0Jjf5ZHhqQtrNHmYTX+apxnDnzqsjC17OT1BAIougZBbGHSI7a0zklNsoMhbzFJ2whTZWzvHcvEkKeiZ36fZoqA5it4FgDW54D4S/ICzp3BfiT5of/DqM6EQ== henry.turner@digital.cabinet-office.gov.uk',
  }
}
