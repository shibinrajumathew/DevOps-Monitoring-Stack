#!/bin/bash
OUTFILE="/var/lib/node_exporter/service_metrics.prom"
NAGIOS_SERVICE_PERFDATA="/opt/nagios/var/service-perfdata"

if [ -f "$NAGIOS_SERVICE_PERFDATA" ]; then
    awk -F'\t' '{
        # Extract fields from the template
        hostname = $3;
        sub(/^HOSTNAME::/, "", hostname);
        service = $4;
        sub(/^SERVICEDESC::/, "", service);
        servicstate = $9;
        sub(/^SERVICESTATE::/, "", servicstate);

        perfdata = "$5";
        sub(/^SERVICEPERFDATA::/, "", perfdata);
        
        
        # Process performance data
        if (service == "HTTP") {
            # Extract HOSTPERFDATA and break into fields
            perfdata = $10;
            sub(/^HOSTPERFDATA::/, "", perfdata);

            # Split on space, because perfdata contains both ";" and space-separated metrics
            n = split(perfdata, metrics, " ");

            # Extract RTA
            split(metrics[1], rta_part, "=");
            rta = rta_part[2];
            sub(/ms$/, "", rta);
            rta_sec = rta / 1000;
            
            print "nagios_http_response_seconds{host=\""hostname"\"} " rta_sec;
        }
        else if (service == "PING") {
            # Extract HOSTPERFDATA and break into fields
            perfdata = $10;
            sub(/^HOSTPERFDATA::/, "", perfdata);

            # Split on space, because perfdata contains both ";" and space-separated metrics
            n = split(perfdata, metrics, " ");

            # Extract RTA
            split(metrics[1], rta_part, "=");
            rta = rta_part[2];
            sub(/ms$/, "", rta);
            rta_sec = rta / 1000;
            
            print "nagios_ping_response_seconds{host=\""hostname"\"} " rta_sec;
        }else {
            value = (servicstate == "OK") ? 1 : 0;
            print "nagios_http_ssl_response{host=\""hostname"\", servicstate=\""servicstate"\"} " value;
        }
    }' "$NAGIOS_SERVICE_PERFDATA" > "$OUTFILE"
fi