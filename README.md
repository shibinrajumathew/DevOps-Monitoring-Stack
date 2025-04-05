DevOps Monitoring Stack: Nagios, Prometheus, and Grafana with Docker


#To run ansible
ansible-playbook ansible_monitoring_setup.yml
To test nagios config
# docker exec -it nagios nagios -v /opt/nagios/etc/nagios.cfg

To test ping inside nagios docker
# docker exec -it nagios /usr/lib/nagios/plugins/check_ping -H vveeo.com -w 100.0,20% -c 500.0,60%

Default nagios username and pass, To Do change after testing
nagiosadmin / nagios

docker exec -it nagios bash
ls -l /opt/nagios/var/host-perfdata
ls -l /opt/nagios/var/status.dat
ls -l /opt/nagios/var/service-perfdata