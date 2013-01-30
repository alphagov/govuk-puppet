#!/usr/bin/env python

import sys
import os.path
import datetime
import optparse

DESC="Nagios check: WARN if a file or directory has not been modified " +\
    "in the last N days."

def main(argv):
    parser = optparse.OptionParser(description=DESC)

    parser.add_option('-p', '--path', type='string', help="Path to check")
    parser.add_option('-d', '--days', type='int', help="Last modified threshold in days")
    opts, args = parser.parse_args()

    if not opts.path or not opts.days:
        parser.print_help()
        return 1

    if not os.path.exists(opts.path):
        print "WARNING: Path %r does not exist" % opts.path
        return 1

    today = datetime.datetime.today()
    mtime = datetime.datetime.fromtimestamp(
      os.path.getmtime(opts.path))
    diff = today - mtime

    if diff.days > opts.days:
        print "WARNING: Path %r has not been modified in the last %s days" \
            % (opts.path, opts.days)
        return 1
    else:
        print "OK: Path %r has been modified in the last %s days" \
            % (opts.path, opts.days)
        return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
