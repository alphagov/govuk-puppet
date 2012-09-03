#!/bin/bash
cd /tmp
rm -r www.gov.uk
#Right now just copies only one file, for testing
/usr/bin/wget -v -mE -A index.html https://www.gov.uk
mv www.gov.uk/* /usr/share/www/www.gov.uk