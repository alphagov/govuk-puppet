# == Class: govuk::node::s_docker_base
#
# Base class for docker instances
#
class govuk::node::s_docker_base (
  $apt_mirror_hostname = undef,
){

  include ::govuk::node::s_base
  include ::govuk_docker

  if $apt_mirror_hostname {
    apt::source { 'etcdctl':
      location     => "http://${apt_mirror_hostname}/etcdctl",
      release      => 'stable',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  }

  @ufw::allow {
    'swarm-cluster-management-communications':
      from => 'any',
      port => 2377;
    'swarm-communication-among-nodes-tcp':
      from  => 'any',
      proto => 'tcp',
      port  => 7946;
    'swarm-communication-among-nodes-udp':
      from  => 'any',
      proto => 'udp',
      port  => 7946;
    'swarm-overlay-network-traffic':
      from  => 'any',
      proto => 'udp',
      port  => 4789;
  }

}
