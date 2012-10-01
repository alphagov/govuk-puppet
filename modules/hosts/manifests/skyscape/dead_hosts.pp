class hosts::skyscape::dead_hosts ($platform = $::govuk_platform){
  host {'calendars.cluster.router.production':  ensure=> "absent", ip=> '10.2.1.1'}
  host {'calendars.router.production'        :  ensure=> "absent", ip=> '10.2.1.1'}
}