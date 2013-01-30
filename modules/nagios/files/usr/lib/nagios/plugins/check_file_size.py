#!/usr/bin/env python

import sys
import os.path
import datetime
import optparse

DESC="Nagios check: WARN if a file is smaller than a minimum number of bytes."

def main(argv):
    parser = optparse.OptionParser(description=DESC)

    parser.add_option('-p', '--path', type='string', help="Path to check")
    parser.add_option('-s', '--size', type='string', help="Minimum file size. Supports B, K, M and G suffixes (default B)")
    opts, args = parser.parse_args()

    if not opts.path or not opts.size:
        parser.print_help()
        return 1

    if not os.path.exists(opts.path):
        print "WARNING: Path <%r> does not exist" % opts.path
        return 1

    import re

    def raise_(e):
        """lambdas cannot contain statements, so this is an expression which can be used to raise an exception."""
        raise e

    rules = (
        (
            '^\d+B$',
            lambda size: int(re.sub('B', '', size))
        ),
        (
            '^\d+K$',
            lambda size: int(re.sub('K', '', size)) * 1024
        ),
        (
            '^\d+M$',
            lambda size: int(re.sub('M', '', size)) * 1024 * 1024
        ),
        (
            '^\d+G$',
            lambda size: int(re.sub('G', '', size)) * 1024 * 1024 * 1024
        ),
        (
            '^\d+$',
            lambda size: int(size)
        ),
        (
            '.*',
            lambda size: raise_(Exception("Unknown size value <%s>" % size))
        ),
    )

    def parseSize(size):
        for reRule, multiplierRule in rules:
            if re.search(reRule, size):
                return multiplierRule(size)

    minimum_size_in_bytes = parseSize(opts.size)

    file_size = os.stat(opts.path).st_size

    if file_size < minimum_size_in_bytes:
        print "WARNING: Path <%r> (%dB) is less than %dB" \
            % (opts.path, file_size, minimum_size_in_bytes)
        return 1
    else:
        print "OK: Path <%r> (%dB) is larger than or equal to %dB" \
            % (opts.path, file_size, minimum_size_in_bytes)
        return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
