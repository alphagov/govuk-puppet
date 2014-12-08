# == Class: govuk::node::s_etcd
#
class govuk::node::s_etcd inherits govuk::node::s_base {
  include govuk_etcd

  ufw::allow { 'allow-etcd-client-from-all':
    port => 4001,
  }

  ufw::allow { 'allow-etcd-peer-from-all':
    port => 7001,
  }
}
