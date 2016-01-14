# Creates the bob user
class users::bob {
  govuk::user { 'bob':
    fullname => 'bob walker',
    email    => 'bob.walker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiocsYQ5QyshThjdfgaYNp9byopWa1Qlhr956pE5JqwD6fLuC9msEfDU426gNQmR+XneUFaONgzfHXv33WbKnb1e+ccUTV4MmmfEIXZzhwtjwJyROEJ3DbPrOWmwWZr3BChmw9OQ537kXIeNQ9VFqo7vWXlYEAlsU0J//P0WWkKb23zmi8GkG/lIZ/bWpj92SHVMKXAfurFMV1EBn5QBdHOdJfh6mzb/CiZpQ+bPstUNF1UJG02twkAqVehPfSKfwdjmrmRwA8UQeTEyHfDgUZt/Mq4SN5uWwBS3lXS/bV1sc5bDbLDM43gzwRLrN2uNAW3jgRz5BbqH03SOwoY1CjSPmFrxQ1X62QO8Dc8IHxXF8y5+wNEeLsH/Ev8E0W6Ds0KHMQpoNDnTdQ6vPblgsiHGpT0zIn7VOG+GqJHS/LoZy3V9JeeJ7n9sqhQ2CQRISyyJLhHoK5W278bWMRUlYX2MV7NRhmOfSSYiTY1uegzqSgH38Io2EaIUC/jgcCyqf4vDTG9U/0WnYE2H7HEeNtk8w1C3//B8EWY43JXMQT1suUryIjNvONa3j3rTmvMkldxpCktRuK7LKLTHuh1Ls/KIY7MlbS9BqkpaKO06UnutvOpNJ0hz7T8KiQwb49ENfgQQPrb5q5GiD8DIW3YgB/duOmvrU+xUDUvIjgmkHKow== bobwalker@GDS479.local',
  }
}
