### An extended version of SampleLogster for Apache and Nginx access logs
### which reports more granular HTTP code metrics and response times.
###
###
###  Copyright 2011, Etsy, Inc.
###
###  This file is part of Logster.
###
###  Logster is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  Logster is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with Logster. If not, see <http://www.gnu.org/licenses/>.
###

import time
import re

from logster.logster_helper import MetricObject, LogsterParser
from logster.logster_helper import LogsterParsingException

class ExtendedSampleLogster(LogsterParser):

    def __init__(self, option_string=None):
        '''Initialize any data structures or variables needed for keeping track
        of the tasty bits we find in the log we are parsing.'''
        self.http_1xx = 0
        self.http_2xx = 0
        self.http_301 = 0
        self.http_3xx = 0
        self.http_404 = 0
        self.http_410 = 0
        self.http_4xx = 0
        self.http_5xx = 0
        self.http_500 = 0
        self.http_502 = 0
        self.http_503 = 0
        self.http_504 = 0

        self.line_count = 0
        self.request_time = 0.0
        self.upstream_response_time = 0.0
        
        # Regular expression for matching lines we are interested in, and capturing
        # fields from the line (in this case, http_status_code, request_time and upstream_response_time).
        self.reg = re.compile('.*HTTP/1.\d\" (?P<http_status_code>\d{3})(?: \d+ "[^"]*" "[^"]*" (?P<request_time>[\d\.]+) (?P<upstream_response_time>[\d\.]+))?')


    def parse_line(self, line):
        '''This function should digest the contents of one line at a time, updating
        object's state variables. Takes a single argument, the line to be parsed.'''

        try:
            # Apply regular expression to each line and extract interesting bits.
            regMatch = self.reg.match(line)

            if regMatch:
                linebits = regMatch.groupdict()

                if linebits['request_time'] is not None:
                    self.line_count += 1
                    self.request_time += float(linebits['request_time'])
                    self.upstream_response_time += float(linebits['upstream_response_time'])

                status = int(linebits['http_status_code'])

                if (status < 200):
                    self.http_1xx += 1
                elif (status < 300):
                    self.http_2xx += 1
                elif (status < 400):
                    self.http_3xx += 1
                    if (status == 301):
                        self.http_301 += 1
                elif (status < 500):
                    self.http_4xx += 1
                    if (status == 404):
                        self.http_404 += 1
                    if (status == 410):
                        self.http_410 += 1
                else:
                    self.http_5xx += 1
                    if (status == 500):
                        self.http_500 += 1
                    if (status == 502):
                        self.http_502 += 1
                    if (status == 503):
                        self.http_503 += 1
                    if (status == 504):
                        self.http_504 += 1

            else:
                raise LogsterParsingException, "regmatch failed to match"

        except Exception, e:
            raise LogsterParsingException, "regmatch or contents failed with %s" % e


    def get_state(self, duration):
        '''Run any necessary calculations on the data collected from the logs
        and return a list of metric objects.'''
        self.duration = duration

        # Return a list of metrics objects
        metrics = [
            MetricObject("http_1xx", (self.http_1xx / self.duration), units="Responses per sec"),
            MetricObject("http_2xx", (self.http_2xx / self.duration), units="Responses per sec"),
            MetricObject("http_3xx", (self.http_3xx / self.duration), units="Responses per sec"),
            MetricObject("http_301", (self.http_301 / self.duration), units="Responses per sec"),
            MetricObject("http_4xx", (self.http_4xx / self.duration), units="Responses per sec"),
            MetricObject("http_404", (self.http_404 / self.duration), units="Responses per sec"),
            MetricObject("http_410", (self.http_410 / self.duration), units="Responses per sec"),
            MetricObject("http_5xx", (self.http_5xx / self.duration), units="Responses per sec"),
            MetricObject("http_500", (self.http_500 / self.duration), units="Responses per sec"),
            MetricObject("http_502", (self.http_502 / self.duration), units="Responses per sec"),
            MetricObject("http_503", (self.http_503 / self.duration), units="Responses per sec"),
            MetricObject("http_504", (self.http_504 / self.duration), units="Responses per sec"),
        ]

        if self.line_count > 0:
            metrics += [
                MetricObject("time_request",  (self.request_time / self.line_count),           units="Average request time"),
                MetricObject("time_upstream", (self.upstream_response_time / self.line_count), units="Average upstream response time"),
            ]

        return metrics
