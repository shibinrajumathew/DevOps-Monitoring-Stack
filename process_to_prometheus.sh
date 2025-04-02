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
    
    # Add Host UP/DOWN status to metrics from status.dat
    if [ -f "/opt/nagios/var/status.dat" ]; then
        awk '{
            if ($1 == "hoststatus") {
            # Extract the host name and current state from the hoststatus block
            host_name=""; state="";
            
            # Parse the host_name and current_state
            for (i = 1; i <= NF; i++) {
                if ($i == "host_name=") {
                    host_name=$(i+1);
                }
                if ($i == "current_state=") {
                    state=$(i+1);
                }
            }

            # Check current state: 0 means UP, 1 means DOWN
            if (state == "0") {
                print "nagios_host_up{host=\""host_name"\"} 1";  # UP status
            } else {
                print "nagios_host_up{host=\""host_name"\"} 0";  # DOWN status
            }
        }
    }' /opt/nagios/var/status.dat >> $OUTFILE
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