<?php


function graph_haphrsperrorcodes_report ( &$rrdtool_graph ) {


// pull in a number of global variables, many set in conf.php (such as colors
// and $rrd_dir), but other from elsewhere, such as get_context.php

    global $context,
           $hrsp_1xx_color,
           $hrsp_4xx_color,
           $hrsp_5xx_color,
           $hrsp_other_color,
//           $rsp_total_color,
           $http_frontend,
           $hostname,
           $range,
           $rrd_dir,
           $size,
           $strip_domainname;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $title = 'Haproxy HTTP F ERROR (1xx,4xx,5xx,other) Response Codes Report';
    $http_frontend = "http_FRONTEND";
    $hrsp_1xx_color = "FF00FF";
    $hrsp_4xx_color = "FF9900";
    $hrsp_5xx_color = "FF0000";
    $hrsp_other_color = "C0C0C0";
    if ($context != 'host') {
       //  This will be turned into: "Clustername $TITLE last $timerange",
       //  so keep it short
       $rrdtool_graph['title']  = $title;
    } else {
       $rrdtool_graph['title']  = "$hostname $title last $range";
    }
    $rrdtool_graph['vertical-label'] = 'Percent Requests';
    // Fudge to account for number of lines in the chart legend
    $rrdtool_graph['height']        += ($size == 'medium') ? 28 : 0;
//    $rrdtool_graph['upper-limit']    = '100';
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['extras']         = '--rigid';

    $series = "DEF:'hrsp_1xx'='${rrd_dir}/${http_frontend}_hrsp_1xx.rrd':'sum':AVERAGE "
              ."DEF:'hrsp_2xx'='${rrd_dir}/${http_frontend}_hrsp_2xx.rrd':'sum':AVERAGE "
              ."DEF:'hrsp_3xx'='${rrd_dir}/${http_frontend}_hrsp_3xx.rrd':'sum':AVERAGE "
              ."DEF:'hrsp_4xx'='${rrd_dir}/${http_frontend}_hrsp_4xx.rrd':'sum':AVERAGE "
              ."DEF:'hrsp_5xx'='${rrd_dir}/${http_frontend}_hrsp_5xx.rrd':'sum':AVERAGE "
              ."DEF:'hrsp_other'='${rrd_dir}/${http_frontend}_hrsp_other.rrd':'sum':AVERAGE "
              ."CDEF:'total_requests'=hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,+,+,+,+,+ "
              ."CDEF:'percent_1xx'=hrsp_1xx,total_requests,/,100,* "
              ."CDEF:'percent_4xx'=hrsp_4xx,total_requests,/,100,* "
              ."CDEF:'percent_5xx'=hrsp_5xx,total_requests,/,100,* "
              ."CDEF:'percent_other'=hrsp_other,total_requests,/,100,* "
              ."AREA:'percent_4xx'#$hrsp_4xx_color:'hrsp 4xx' "
              ."STACK:'percent_5xx'#$hrsp_5xx_color:'hrsp 5xx' "
              ."STACK:'percent_1xx'#$hrsp_1xx_color:'hrsp 1xx' "
              ."STACK:'percent_other'#$hrsp_other_color:'hrsp other' ";

    // We have everything now, so add it to the array, and go on our way.
    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;
}

?>
