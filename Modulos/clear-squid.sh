#!/bin/bash
wget -O /usr/bin/squidclear https://www.dropbox.com/s/j7wwaoa950dpys6/squidclear.sh && chmod +x /usr/bin/squidclear

cd
echo "2 0 * * * root /usr/bin/squidclear" >> /etc/crontab
