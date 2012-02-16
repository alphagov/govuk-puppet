from SampleGangliaLogster import SampleGangliaLogster

class NginxGangliaLogster(SampleGangliaLogster):

    def __init__(self):
        super(NginxGangliaLogster, self).__init__()

    def prefix(self):
        return "nginx_"
