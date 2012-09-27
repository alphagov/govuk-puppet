<?php


function graph_haphttpsessions_report ( &$rrdtool_graph ) {


// pull in a number of global variables, many set in conf.php (such as colors
// and $rrd_dir), but other from elsewhere, such as get_context.php

    global $context,
           $rate_total_color,
           $scur_total_color,
           $http_frontend,
           $hostname,
           $range,
           $rrd_dir,
           $size,
           $strip_domainname;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $title = 'Haproxy HTTP F Session rate vs Current Sessions Report';
    $http_frontend = "http_FRONTEND";
    $rate_total_color = "0000ff";
    $scur_total_color = "eeeeee";
    if ($context != 'host') {
       //  This will be turned into: "Clustername $TITLE last $timerange",
       //  so keep it short
       $rrdtool_graph['title']  = $title;
    } else {
       $rrdtool_graph['title']  = "$hostname $title last $range";
    }
    $rrdtool_graph['vertical-label'] = 'Sessions,Sessions/sec';
    // Fudge to account for number of lines in the chart legend
    $rrdtool_graph['height']        += ($size == 'medium') ? 28 : 0;
    //$rrdtool_graph['upper-limit']    = '100';
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['extras']         = '--rigid';

    /*
     * Here we actually build the chart series.  This is moderately complicated
     * to show off what you can do.  For a simpler example, look at
     * network_report.php
     */
    if($context != "host" ) {

        $series = "DEF:'scur_total'='${rrd_dir}/${http_frontend}_scur.rrd':'sum':AVERAGE "
              ."DEF:'rate_total'='${rrd_dir}/${http_frontend}_rate.rrd':'sum':AVERAGE "
              ."AREA:'scur_total'#$scur_total_color:'Current Sessions' "
              ."LINE2:'rate_total'#$rate_total_color:'Session Rate' ";

    } else {

        // Context is not "host"
        $series ="DEF:'scur_total'='${rrd_dir}/http_FRONTEND_scur.rrd':'sum':AVERAGE "
              ."DEF:'rate_total'='${rrd_dir}/http_FRONTEND_rate.rrd':'sum':AVERAGE "
              ."AREA:'scur_total'#$scur_total_color:'Current Sessions' "
              ."LINE2:'rate_total'#$rate_total_color:'Session Rate' ";
    }

    // We have everything now, so add it to the array, and go on our way.
    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;
}

?>
