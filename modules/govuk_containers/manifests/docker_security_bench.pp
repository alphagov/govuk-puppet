# == Class: govuk_containers::docker_security_bench
#
#  Add a cronjob to periodically run the docker_security_bench container and send its
#  results to the central cron information store.
#
#  This should be a non-persistent container.
#
class govuk_containers::docker_security_bench {

  $cron_command = "/usr/bin/docker run -it --net host --pid host --cap-add audit_control \
         -v /var/lib:/var/lib \
         -v /var/run/docker.sock:/var/run/docker.sock \
         -v /usr/lib/systemd:/usr/lib/systemd \
         -v /etc:/etc \
         --label docker_bench_security     docker/docker-bench-security"

  cron::crondotdee { 'docker_security_bench':
    command => $cron_command,
    hour    => 6,
    minute  => 45,
    weekday => 0,
  }

}
