from SampleGangliaLogster import SampleGangliaLogster

class ApacheGangliaLogster(SampleGangliaLogster):

    def __init__(self):
        super(ApacheGangliaLogster, self).__init__()

    def prefix(self):
        return "apache_"
