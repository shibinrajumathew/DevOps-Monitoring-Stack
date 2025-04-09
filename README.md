# DevOps Monitoring Stack: Nagios, Prometheus, and Grafana with Docker

This repository sets up a **DevOps Monitoring Stack** consisting of **Nagios**, **Prometheus**, and **Grafana** using **Docker** containers, and is designed for seamless monitoring and alerting of your infrastructure and applications.

## Stack Overview
> - **Nagios**: A monitoring tool that provides alerts and status reports for your systems, services, and network.
> - **Prometheus**: A powerful monitoring and alerting toolkit designed for cloud-native applications. It collects and stores time-series data, ideal for containerized environments.
> - **Grafana**: A data visualization platform that integrates with Prometheus to create dashboards and alerts based on your metrics data.

## Setup Instructions

### Prerequisites:
- Docker installed on the host machine.
- Ansible (for setting up and automating the environment).

### 1. **Run the Ansible Playbook**
This playbook will set up the necessary environment and configurations for the monitoring stack. To run the playbook, execute the following command:

```bash
ansible-playbook ansible_monitoring_setup.yml
```
### 2. Test Nagios Configuration
To verify the Nagios configuration, use the following command inside the Nagios Docker container:

```bash
 docker exec -it nagios nagios -v /opt/nagios/etc/nagios.cfg
```
This will check the Nagios configuration for any errors or issues.


### 3. Test Ping Inside Nagios Docker Container
You can test the Nagios plugin for ping by running the following command inside the Nagios container:

```bash
docker exec -it nagios /usr/lib/nagios/plugins/check_ping -H vveeo.com -w 100.0,20% -c 500.0,60%
```
This command checks the ping response from vveeo.com, with specified warning and critical thresholds for packet loss and response time.

### 4. Default Nagios Credentials
By default, the Nagios admin username and password are set to:


Username: nagiosadmin

Password: nagios

Note: Make sure to change these credentials after testing to secure your environment.

### Additional Information
Nagios is used for basic monitoring and alerting, including host, service, and network monitoring.

Prometheus scrapes time-series metrics data and stores them for querying, visualization, and alerting.

Grafana integrates with Prometheus to create customized, interactive dashboards that provide insight into system health and performance.

# ELK Stack - Local Development Setup 🚀

**A lightweight Elasticsearch + Kibana Docker environment for log analysis testing and future production prototyping.**

> 🔍 **Current Components**: Elasticsearch + Kibana  
> ⏳ **Coming Later**: Logstash (for log ingestion pipelines)  

## 🛠️ Purpose
- **Local testing** of log aggregation, filtering, and visualization.
- **Proof-of-Concept** for future production deployments.
- **Security Analysis** (detect patterns like brute-force attacks, port scans).

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- 4GB+ RAM allocated to Docker (Elasticsearch is hungry!)

### Elasticsearch	
http://localhost:9200

### Kibana	
http://localhost:5601


## 🛠️ Future Enhancements
 - Add Logstash for log preprocessing (WIP).
 - Enable Security (TLS, auth) for production-ready configs. 
 - Integrate Beats (Filebeat for system logs).
### Contributions
Feel free to fork the repository, create issues, and submit pull requests. Contributions to enhance the setup, add more monitoring configurations, or improve documentation are welcome!