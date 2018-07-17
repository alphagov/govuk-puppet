#!/usr/bin/env python3

import http.server
import os
import syslog
import subprocess
import random
import re
import sys
import time
import json
import shutil

REGION = 'eu-west-1'
IMAGE_IDS = {
    'trusty': 'ami-64b3361d'
}
ACCOUNT_ID = '111111111111'
PRIVATE_NET_IFACE = 'eth1'


class DynamicInstanceIdentity:
    def __init__(self):
        self.availability_zone = self.get_availability_zone()
        self.instance_id = self.generate_instance_id()
        self.private_ip = self.get_private_ip()
        self.image_id = self.get_image_id()
        self.launch_time = self.get_launch_time()

    def document(self):
        return {
            "availabilityZone": self.availability_zone,
            "devpayProductCodes": None,
            "marketplaceProductCodes": None,
            "version": "2017-09-30",
            "instanceId": self.instance_id,
            "billingProducts": None,
            "instanceType": "t2.micro",
            "privateIp": self.private_ip,
            "accountId": ACCOUNT_ID,
            "architecture": "x86_64",
            "kernelId": None,
            "ramdiskId": None,
            "imageId": self.image_id,
            "pendingTime": self.launch_time
        }

    def get_availability_zone(self):
        return "{0}a".format(REGION)

    def generate_instance_id(self):
        return "i-{0:x}".format(random.getrandbits(16 * 4))

    def get_image_id(self):
        distro = subprocess.check_output(['lsb_release', '-cs']).decode('utf-8').rstrip()
        return IMAGE_IDS[distro]

    def get_private_ip(self):
        try:
            ip_addr = subprocess.check_output(['ip', 'addr', 'show', 'dev', PRIVATE_NET_IFACE])
        except subprocess.CalledProcessError as e:
            syslog.syslog(syslog.LOG_ERR, "Couldn't determine IP address of {0}: {1}".format(PRIVATE_NET_IFACE, e.stderr))

        match = re.search('inet ([\d\.]+)', ip_addr.decode('utf-8'))
        return match.group(1)

    def get_launch_time(self):
        return time.strftime(
            "%Y%m%dT%H:%M:%SZ",
            time.localtime(
                time.time() - time.monotonic()
            )
        )


class MetadataServiceHandler(http.server.BaseHTTPRequestHandler):
    dii = DynamicInstanceIdentity()

    def do_GET(self):
        if self.path == '/latest/dynamic/instance-identity/document':
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(
                bytes(
                    json.dumps(
                        MetadataServiceHandler.dii.document(),
                        indent=2
                    ),
                    'utf-8'
                )
            )
            return

        self.send_response(404)
        self.end_headers()
        return


def daemonize():
    try:
        pid = os.fork()
        if pid > 0:
            sys.exit()
    except OSError as e:
        sys.exit("Fork #1 failed: {0} ({1})".format(e.errno, e.strerror))

    os.chdir("/")
    os.setsid()
    os.umask(0)

    try:
        pid = os.fork()
        if pid > 0:
            sys.exit()
    except OSError as e:
        sys.exit("Fork #2 failed: {0} ({1})".format(e.errno, e.strerror))


def persist():
    shutil.copy(__file__, '/usr/local/bin/mock-ec2-metadata-service.py')
    with open('/etc/init/mock-ec2-metadata.conf', 'w') as upstart:
        upstart.write(str.join("\n", [
            'description "Mock EC2 Metadata"',
            'start on runlevel [2345]',
            'stop on runlevel [!2345]',
            'exec /usr/local/bin/mock-ec2-metadata-service.py',
        ]))
        upstart.write("\n")
        upstart.close()

def assume_169254_address():
    try:
        loopback_config = subprocess.check_output(['ip', 'addr', 'show', 'dev', 'lo']).decode('utf-8')
        if re.search('169.254.169.254', loopback_config) is None:
            subprocess.check_call(['ip', 'addr', 'add', '169.254.169.254/32', 'dev', 'lo'])
    except subprocess.CalledProcessError as e:
        sys.exit(
            "Couldn't assume 169.254.169.254/32 address: Command `{0}` returned {1} ({2})".format(
                e.cmd, e.returncode, e.stderr
            )
        )


if __name__ == '__main__':
    if os.getuid() != 0:
        sys.exit("Must be run as root")

    assume_169254_address()

    try:
        httpd = http.server.HTTPServer(
            ('169.254.169.254', 80),
            MetadataServiceHandler
        )
    except OSError as e:
        if e.errno == 98:
            print("169.254.169.254:80 already bound - mock EC2 metadata service already running?", file=sys.stderr)
            sys.exit()
        else:
            sys.exit("Couldn't bind HTTP service to 169.254.169.254:80: {0} ({1})".format(
                e.errno, e.strerror
            ))

    if os.getenv('FG_ONLY') is None:
        daemonize()
        persist()

    print("Mock EC2 metadata service ready", file=sys.stderr)
    httpd.serve_forever()
