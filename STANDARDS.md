## Standards

### Process Supervision

If you are starting a daemonized process, you should strive to create an Upstart script for it, so it benefits from supervision (restarting it when it dies). There is more [documentation](https://sites.google.com/a/digital.cabinet-office.gov.uk/wiki/projects-and-processes/projects-products/hosting-and-infrastructure-1/processsupervision) available on the Infrastructure Wiki.

### Nagios Checks

When creating a service, it is desirable to also check that it is functioning correctly. Our standard for monitoring is Nagios. You can see more details of how to monitor a service with Nagios in the [nagios puppet module](https://github.com/alphagov/puppet/blob/master/modules/nagios/manifests/client/checks.pp)