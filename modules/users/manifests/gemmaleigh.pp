# Creates the gemmaleigh user
class users::gemmaleigh {
  govuk_user { 'gemmaleigh':
    fullname => 'Gemma Leigh',
    email    => 'gemma.leigh@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9b/nT3QRPujygd/umKHAkfQQrxCEstLpGNRxHU35YBkakF5rOCE2NP3gTsO/Hidj/tI9jUnUQis9yvUiyex95XLbhTBhKDMStteLym+sbtds4IXhzHiNEM+C7n44nmi0f9GeLsBWQWglkQUsg1HeimFhNGJ5EnfjFfLhoZDGjKF8tc6gEmi0X8aBMxDdf6Rp4na7WW0fCWtx8Q+pASJ0qzfE9iodzIFtoUE6e+ZyeNQZBkx8E72Z0ddnX25pLhUbCWLOORUKY3VWMAEjyYPZmOC1OvADUgG6I8RfsNidvfbhmYSgyLtVlYNKVUx0TXawXelZuw2JBMa0h1qc84/hBJT7riW8WPhfR3197YRilePxZuY5H83GvhQdRK9eammyC1QUZqbC7joh15JMlBebWGyCpQ+rrDTPxboZc/XTCRvyl1MNwbvCR7cgGO9BFoxdB/PYlQFmQtTgBjzromcCQ4rz85I9Itn6rhCmuSqY7l0j0012rcKOV5B22/t+7dYGSMaT/V1bTGUhjjHrFxdqTIj6T6NEDLGC3IPZQxm8h/Ucrog1+AXJXcMiJoWXlObDRJhOAEgFCAkt0Z3cQv2aBqdKF6ZzUPRcKCOk14f6tr/R9TkMku74PzNoXZry7w9bmH6vROIywTP2FDuWKWfqYf5/rkBuOk17ST49E6lxc/w== hello@gemmaleigh.com',
  }
}
