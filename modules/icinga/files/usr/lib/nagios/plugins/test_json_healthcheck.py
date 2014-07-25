import unittest

from check_json_healthcheck import url_from_arguments, HealthCheckInfo

class TestURLParsing(unittest.TestCase):

    def test_parses_port_and_path(self):
        self.assertEqual(url_from_arguments([8000, "/foo"]),
                         "http://localhost:8000/foo")

    def test_fails_on_non_numeric_port(self):
        self.assertRaises(ValueError,
                          lambda: url_from_arguments(["foo", "/"]))

    def test_fails_on_backwards_arguments(self):
        self.assertRaises(StandardError,
                          lambda: url_from_arguments(["/", 8000]))

    def test_fails_on_single_argument(self):
        self.assertRaises(IndexError, lambda: url_from_arguments([8000]))


class TestHealthCheckInfo(unittest.TestCase):

    def test_reports_overall_status_ok(self):
        hc = HealthCheckInfo({"status": "ok"})
        self.assertEqual(hc.overall_status, "ok")

    def test_reports_overall_status_critical(self):
        hc = HealthCheckInfo({"status": "critical"})
        self.assertEqual(hc.overall_status, "critical")

    def test_raises_error_without_overall_status(self):
        self.assertRaises(ValueError, lambda: HealthCheckInfo({}))

    def test_reports_ok_status_code(self):
        hc = HealthCheckInfo({"status": "ok"})
        self.assertEqual(hc.overall_status_code, 0)

    def test_reports_critical_status_code(self):
        hc = HealthCheckInfo({"status": "critical"})
        self.assertEqual(hc.overall_status_code, 2)

    def test_fails_on_unknown_status_code(self):
        hc = HealthCheckInfo({"status": "devops"})
        self.assertRaises(ValueError, lambda: hc.overall_status_code)

    def test_returns_no_checks(self):
        hc = HealthCheckInfo({"status": "ok"})
        self.assertEqual(hc.check_statuses, [])

    def test_returns_check_status(self):
        hc = HealthCheckInfo(
            {"status": "ok", "checks": {"foo": {"status": "ok"}}}
        )
        self.assertEqual(hc.check_statuses, [("foo", "ok")])


if __name__ == "__main__":
    unittest.main()
