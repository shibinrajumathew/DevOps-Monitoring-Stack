#!/bin/bash
OUTFILE="/var/lib/node_exporter/host_metrics.prom"
NAGIOS_HOST_PERFDATA="/opt/nagios/var/host-perfdata"

if [ -f "$NAGIOS_HOST_PERFDATA" ]; then
    awk -F'\t' '{
        hostname = $3;
        sub(/^HOSTNAME::/, "", hostname);
        hoststate = $4;
        sub(/^HOSTSTATE::/, "", hoststate);
        latency = $8;
        sub(/^HOSTLATENCY::/, "", latency);

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

        # Extract PL
        split(metrics[2], pl_part, "=");
        pl = pl_part[2];
        sub(/%$/, "", pl);

        # Output
        value = (hoststate == "UP") ? 1 : 0;
        print "nagios_host_state{host=\""hostname"\",hoststate=\""hoststate"\"} " value;
        print "nagios_host_latency_seconds{host=\""hostname"\"} " latency;
        print "nagios_host_rta_seconds{host=\"" hostname "\"} " rta_sec;
        print "nagios_host_pl_percent{host=\"" hostname "\"} " pl;
    }' "$NAGIOS_HOST_PERFDATA" > "$OUTFILE"
fi
