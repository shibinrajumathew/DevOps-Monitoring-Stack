#!/bin/bash
OUTFILE="/var/lib/node_exporter/service_metrics.prom"
NAGIOS_SERVICE_PERFDATA="/opt/nagios/var/service-perfdata"

if [ -f "$NAGIOS_SERVICE_PERFDATA" ]; then
    awk -F'\t' '{
        split($5, metrics, ";");
        if ($3 == "HTTP") {
            gsub(/.*=/, "", metrics[1]);
            print "nagios_http_response_seconds{host=\""$2"\",hoststate=\""$6"\"} " metrics[1]/1000;
        }
        if ($3 == "PING") {
            gsub(/.*=/, "", metrics[1]);
            print "nagios_ping_rta_seconds{host=\""$2"\",hoststate=\""$6"\"} " metrics[1]/1000;
        }
    }' "$NAGIOS_SERVICE_PERFDATA" > "$OUTFILE"
fi
