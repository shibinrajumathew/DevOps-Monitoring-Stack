#!/bin/bash
OUTFILE="/var/lib/node_exporter/service_metrics.prom"
NAGIOS_SERVICE_PERFDATA="/opt/nagios/var/service-perfdata"

if [ -f "$NAGIOS_SERVICE_PERFDATA" ]; then
    awk -F'\t' '{
        # Extract fields from the template
        hostname = "";
        service = "";
        perfdata = "";
        for (i=1; i<=NF; i++) {
            if ($i ~ /^HOSTNAME::/) split($i, h, "::");
            if ($i ~ /^SERVICEDESC::/) split($i, s, "::");
            if ($i ~ /^SERVICEPERFDATA::/) split($i, p, "::");
        }
        hostname = h[3];
        service = s[3];
        perfdata = p[3];
        
        # Process performance data
        if (service == "HTTP") {
            split(perfdata, metrics, ";");
            for (m in metrics) {
                if (metrics[m] ~ /=/) {
                    split(metrics[m], kv, "=");
                    if (kv[1] ~ /time/) {
                        print "nagios_http_response_seconds{host=\""hostname"\"} " kv[2]/1000;
                    }
                }
            }
        }
        else if (service == "PING") {
            split(perfdata, metrics, ";");
            for (m in metrics) {
                if (metrics[m] ~ /=/) {
                    split(metrics[m], kv, "=");
                    if (kv[1] ~ /rta/) {
                        print "nagios_ping_rta_seconds{host=\""hostname"\"} " kv[2]/1000;
                    }
                }
            }
        }
    }' "$NAGIOS_SERVICE_PERFDATA" > "$OUTFILE"
fi