from SampleGangliaLogster import SampleGangliaLogster

class JettyGangliaLogster(SampleGangliaLogster):

    def __init__(self):
        super(JettyGangliaLogster, self).__init__()

    def prefix(self):
        return "jetty_"
