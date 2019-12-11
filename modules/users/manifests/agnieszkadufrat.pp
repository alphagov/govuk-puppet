# Creates the agnieszkadufrat user
class users::agnieszkadufrat{ govuk_user { 'agnieszkadufrat':
    ensure   => absent,
    fullname => 'Agnieszka Dufrat',
    email    => 'agnieszka.dufrat@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCi5ucbHujuy0HEj5CR2L7LggI5ma25XlSZRpSWj2xxTQtc1kQga81MC2uR32mOQ3EZlHqUThoanCMkjocvhMQAJ/YnNljULwiWrlLXMdHA/mu7ekY8hwI5Ci6ISZYEDqrYijKrYaGcbmWtdspAXFeobYHuSfvvQLGLa3zC2MIQ6xn3I8/9YS7fhmUbVpgJNJJCLBl69KKbUwiqTwkTh7cwL7kd+XaY6TdjMbFhcqSsNjJl/TWqvPFYNwISBJPQht2S9PpOEXofc2bOb61DHH9TV1JsL6jdt33kLYIPk4NTBOakT6igimdlARPWrf8rZMhqWcOLQDEVZdNIU2v+EDw45AhPkPYV+3YTekY2ht1ywZHq7uCzidOiU2buFACvU9sT4HU5BryxXzry6hT3hFvYH1GH3opKpXYEIWE1eM8PLl/l0MRv/flq2/Lc6zEBFvNrZ4XJZyaieg7Sil0O1y9leEkPOc+QvehJvGXOGCfbnkz7VcOVoZhMpYVCbnXedQV2A0SbRhz8MdOW/C7QDifj1X0KFE/iFPMRe8wq/b/Ezh9JPH1N0CESjguT4dLtSnRBnGoNgtvcuQiHP3lo7+bevGBAbJdTSvw8TkhwhtyJ38YtPKmwAB6T58TeolKhB6I2fg6MoRpuAz8qkk4oJK01AIYc5qdCWeF5WrY3s4u//Q== agnieszka.dufrat@digital.cabinet-office.gov.uk',
  }
}
