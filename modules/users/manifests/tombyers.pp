# Creates the tombyers user
class users::tombyers {
  govuk_user { 'tombyers':
    ensure   => absent,
    fullname => 'Tom Byers',
    email    => 'tom.byers@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4mm2MuSHLbQM79UZET5G9Tc8mXv49dzSGI8m/ZH5rPjIBtnu4mhlEtpCEmuKC2EoPxheoLz6/Wgqt3IidDxyyWDFPN91wkIvqTO36YGG/ajjIELH1RifnIb68+ndJd4F5ClJ5B7dRllgBpEEUxM5eRfYs7qt/nozIIfwddx3DSipk6vYrJqmcyHxy8g95pYQtSDkGK9xFYi+C5hYVEHVfgvpXtZj5+i7FV+29RgwHyWETVFayaJ8OEWTh6Q/gn45MnyFK88oeZsVjiw1jwEtilmLVeQ1XSt4g4nonDVlWE0TOuxtpOkMs0+RwcHzgYSWNQ3z0hIwmMndacLWBj7Hbf5//hL5wINUO84xbKC2oJkbf46ufK+tkokIqGRuC9wzbOSH0+5gVAun+BuevKt8zHITDqxcB8uIJRUeSZ7QYCX70ENDURhmRZ1pE/SOOqpDssuRMSXPsgpe8LOaEVVUzhetp7AfVHJoBEp7Xw2s8UHWQnGCJpyVNxyK8XAsgmoyuV/nwuMRou9xbupDUyUwTgo8y3/8e/jebilcyhM4gOqjbF2R0L5W/jo6iA9inFOwJ+kIV4rPfLFvWK2ajPA7EkrfAmHe7N8aO008W6kcm/fz1W7X7wUl+5VbnC2ekXzVi+2KM6Cgx6NAlvOlKQc+5CxXYHuUFGZdy+gvkYCoB3w==',
  }
}
