/** @scratch /configuration/config.js/1
 * == Configuration
 * config.js is where you will find the core Grafana configuration. This file contains parameter that
 * must be set before Grafana is run for the first time.
 */

/**
 * Use graphite from same domain.
 * grafana.example.com -> graphite.example.com
 */
function graphiteUrl_same_domain() {
  pathArray = window.location.hostname.split('.');
  if (pathArray[0] != 'grafana') {
    document.write("ERROR: Expected first component of 'window.location.hostname' to be 'grafana'");
    return;
  }
  pathArray[0] = 'graphite';
  return pathArray.join('.');
}

define(['settings'],
function (Settings) {
  

  return new Settings({

    /**
     * elasticsearch url:
     * For Basic authentication use: http://username:password@domain.com:9200
     *
     * dcarley: Broken because we don't have an openly accessible ES cluster.
     */
    elasticsearch: "http://localhost:9200",

    /**
     * graphite-web url:
     * For Basic authentication use: http://username:password@domain.com
     * Basic authentication requires special HTTP headers to be configured
     * in nginx or apache for cross origin domain sharing to work (CORS).
     * Check install documentation on github
     */
    graphiteUrl: "https://"+graphiteUrl_same_domain(),

    /**
     * Multiple graphite servers? Comment out graphiteUrl and replace with
     *
     *  datasources: {
     *    data_center_us: { type: 'graphite',  url: 'http://<graphite_url>',  default: true },
     *    data_center_eu: { type: 'graphite',  url: 'http://<graphite_url>' }
     *  }
     */

    default_route: '/dashboard/file/origin_health.json',

    /**
     * If your graphite server has another timezone than you & users browsers specify the offset here
     * Example: "-0500" (for UTC - 5 hours)
     */
    timezoneOffset: null,

    grafana_index: "grafana-dash",

    panel_names: [
      'text',
      'graphite'
    ]
  });
});
