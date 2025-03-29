#!/bin/bash
OUTFILE="/var/lib/node_exporter/nagios_metrics.prom"

while true; do
    # Process host metrics
    if [ -f "/opt/nagios/var/host-perfdata" ]; then
        awk -F'\t' '{
            split($4, metrics, ";");
            gsub(/.*=/, "", metrics[1]);
            print "nagios_host_rta_seconds{host=\""$3"\"}", metrics[1]/1000;
            print "nagios_host_pl{host=\""$3"\"}", metrics[5]
        }' /opt/nagios/var/host-perfdata > $OUTFILE
    fi
    
    # Process service metrics
    if [ -f "/opt/nagios/var/service-perfdata" ]; then
        awk -F'\t' '{
            split($5, metrics, ";");
            if ($3 == "HTTP") {
                gsub(/.*=/, "", metrics[1]);
                print "nagios_http_response_seconds{host=\""$2"\"}", metrics[1]/1000 >> $OUTFILE
            }
            if ($3 == "PING") {
                gsub(/.*=/, "", metrics[1]);
                print "nagios_ping_rta_seconds{host=\""$2"\"}", metrics[1]/1000 >> $OUTFILE
            }
        }' /opt/nagios/var/service-perfdata >> $OUTFILE
    fi
    sleep 15
done