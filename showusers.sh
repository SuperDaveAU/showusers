#!/bin/bash

# Define the network card here.
NETWORK_CARD=wlx7cdd9099c197

# Find the connected users mac addresses.
iw dev $NETWORK_CARD station dump | grep Station | awk '{print $2}' > /tmp/connected.txt

# Clear the header text.
> /tmp/header.txt

# Clear the userlist.
> /tmp/userlist.txt

# Output the header
echo '###########################################################'>> /tmp/header.txt
echo '##                  Connected Devices                    ##' >> /tmp/header.txt
echo '###########################################################' >> /tmp/header.txt
echo '' >> /tmp/header.txt

# From the list on connected MAC addresses we have, find them in the dnsmasq leases. 
# This will indicate who is ACTUALLY connected in real time and give us their device name also. 
for a in `cat /tmp/connected.txt`; do cat /var/lib/misc/dnsmasq.leases | grep $a | awk '{print $4," ",$3," ",$5}' >> /tmp/userlist.txt; done

# Output the sanitized list. 
cat /tmp/header.txt
cat /tmp/userlist.txt | sort -n | column -t

# Exit the program indicating that it ran successfully.
exit 0
