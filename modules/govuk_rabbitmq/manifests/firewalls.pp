class govuk_rabbitmq::firewalls {
  @ufw::allow { 'allow-amqp-from-all': port => 5672 }

  @ufw::allow { 'allow-epmd-from-all': port => 4369 }
  @ufw::allow { 'allow-clustering-communication-port-from-all': port => 25672 }

  @ufw::allow { 'allow-rabbitmq-9100-cluster-from-all': port => 9100 }
  @ufw::allow { 'allow-rabbitmq-9101-cluster-from-all': port => 9101 }
  @ufw::allow { 'allow-rabbitmq-9102-cluster-from-all': port => 9102 }
  @ufw::allow { 'allow-rabbitmq-9103-cluster-from-all': port => 9103 }
  @ufw::allow { 'allow-rabbitmq-9104-cluster-from-all': port => 9104 }
  @ufw::allow { 'allow-rabbitmq-9105-cluster-from-all': port => 9105 }
}
