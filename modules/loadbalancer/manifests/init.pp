class loadbalancer {
  include nginx
  include haproxy
  include loadbalancer::config

  Class['haproxy'] -> Class['loadbalancer::config']
  Class['nginx'] -> Class['loadbalancer::config']
}