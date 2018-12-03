# Creates the jonathankerr user
class users::jonathankerr {
  govuk_user { 'jonathankerr':
    fullname => 'Jonathan Kerr',
    email    => 'jonathan.kerr@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGg7sg1vI4K312TA+kdBSqOxGa7groqLhETtt9Mz0MSb39PXLwlHUuxS6cy3ye6siJ9ooma9qiDZvL9JavBYjJA++C62C4sbyPmulmOtAR4V1wKVCzG0Wz/0pF+KC/16qMq0KmGGEhfM7qsvbSm4kumpbINYHolyCz5NbivLowqaR3TH2UCJpqpIivu1CASikRGcvKijW8MOnaj0BgA/JQRUyWWObqJD1rQKOumrQe39KaVLHACu1V+gRKTe3gqf9LlB+cWqWH3PrqLMfkxFo8+5RR+qVcvMYPuQfqDaFDL6KiGNmL6Pqs2h1tt3Y1ly1C2HcTlpbO1UHSkfxqLqMha2s0VcHjKnoJvGJ9YsveSsADOZh/4IUFhXUX9W+6vE833i6IjXCg6+EpUXfbeJSRzeT+WnVU8DZd02iVPYgRWadelvY/zdSwA+Y1nPSSJLTbntz50QimGk/x3RIrkZaVxtxCR8tgoPQdiRfP310OvFnKOVAzkca2i/Bdu/B8cQdjLIA2hc+wyam5boxGK4saJYA7qGQx7aki6cocRTKo687vWbwxKOXd1ZOJLeG5mR39PWd3VAcsTMDx73nt47xPBEleVqeG9hCcq9laVp5oFkHoPcNOnAVEHj5EqAEORWnyO39zS8jzNB556MNHIACHh0/ckOSRjv7rTaiRyDnddw== jonathan.kerr@digital.cabinet-office.gov.uk',
  }
}
