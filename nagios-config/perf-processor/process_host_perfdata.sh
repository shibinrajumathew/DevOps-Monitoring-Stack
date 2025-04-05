#!/bin/bash
OUTFILE="/var/lib/node_exporter/host_metrics.prom"
NAGIOS_HOST_PERFDATA="/opt/nagios/var/host-perfdata"

if [ -f "$NAGIOS_HOST_PERFDATA" ]; then
    awk -F'\t' '{
        split($4, metrics, ";");
        gsub(/.*=/, "", metrics[1]);
        print "nagios_host_rta_seconds{host=\""$3"\",hoststate=\""$5"\"} " metrics[1]/1000;
        print "nagios_host_pl{host=\""$3"\",hoststate=\""$5"\"} " metrics[5];
    }' "$NAGIOS_HOST_PERFDATA" > "$OUTFILE"
fi
