from SampleGangliaLogster import SampleGangliaLogster

class RedirectorGangliaLogster(SampleGangliaLogster):

    def __init__(self):
        super(NginxGangliaLogster, self).__init__()
        self.http_301 = 0
        self.http_404 = 0
        self.http_410 = 0

    def prefix(self):
        return "redirector_"

    def parse_line(self, line):
        '''This function should digest the contents of one line at a time, updating
        object's state variables. Takes a single argument, the line to be parsed.'''

        try:
            # Apply regular expression to each line and extract interesting bits.
            regMatch = self.reg.match(line)

            if regMatch:
                linebits = regMatch.groupdict()
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

            else:
                raise LogsterParsingException, "regmatch failed to match"

        except Exception, e:
            raise LogsterParsingException, "regmatch or contents failed with %s" % e

    def get_state(self, duration):
        '''Run any necessary calculations on the data collected from the logs
        and return a list of metric objects.'''
        self.duration = duration

        # Return a list of metrics objects
        return [
            GangliaMetricObject("%shttp_1xx" % self.prefix(), (self.http_1xx / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_2xx" % self.prefix(), (self.http_2xx / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_3xx" % self.prefix(), (self.http_3xx / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_301" % self.prefix(), (self.http_301 / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_4xx" % self.prefix(), (self.http_4xx / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_404" % self.prefix(), (self.http_404 / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_410" % self.prefix(), (self.http_410 / self.duration), units="Responses per sec"),
            GangliaMetricObject("%shttp_5xx" % self.prefix(), (self.http_5xx / self.duration), units="Responses per sec"),
        ]
