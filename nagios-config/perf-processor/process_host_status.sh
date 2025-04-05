#!/bin/bash
OUTFILE="/var/lib/node_exporter/host_status.prom"
NAGIOS_STATUS_DAT="/opt/nagios/var/status.dat"

if [ -f "$NAGIOS_STATUS_DAT" ]; then
    awk 'BEGIN {host_name=""; state="";}
    {
        if ($1 == "hoststatus") {
            host_name=""; state="";
        }
        if ($1 == "host_name=") {
            host_name=$2;
        }
        if ($1 == "current_state=") {
            state=$2;
        }
        if (host_name != "" && state != "") {
            print "nagios_host_up{host=\""host_name"\"} " (state == "0" ? 1 : 0);
            host_name=""; state="";
        }
    }' "$NAGIOS_STATUS_DAT" > "$OUTFILE"
fi
