# Hostbill cPanel DNS Cluster Plugin ---- NOT WORKING

## Overview
This plugin integrates Hostbill as a DNS Cluster backend for cPanel, allowing cPanel servers to manage DNS records through Hostbill's API. It provides a seamless way to synchronize DNS zones, add/remove records, and handle DNS management across multiple servers.

## Features
- Automatically synchronize DNS zones between cPanel and Hostbill.
- Supports adding and removing DNS zones.
- Retrieves existing DNS records from Hostbill.
- Provides a configuration interface inside WHM.
- Stores API credentials securely in the cPanel cluster configuration.
- Enables logging and debugging options for troubleshooting.

## Installation
### 1. Copy the Plugin Files
Place the following files in their respective directories:
```sh
cp Hostbill.pm /usr/local/cpanel/Cpanel/NameServer/Remote/
mkdir -p /usr/local/cpanel/Cpanel/NameServer/Remote/Hostbill/
cp DNSSync.pm /usr/local/cpanel/Cpanel/NameServer/Remote/Hostbill/
```

### 2. Restart DNS Services
Run the following command to restart the cPanel DNS services:
```sh
/scripts/restartsrv_dnsadmin
```

## Configuration
1. **Navigate to WHM** → *Clusters* → *DNS Cluster*.
2. Click on **"Configure Cluster"**.
3. Select **Hostbill** from the available modules.
4. Enter the following details:
   - **API URL**: `https://portal.centralcloud.com/admin/api`
   - **API ID**: `550c53d50958f3a8b421`
   - **API Key**: `b93e22bd2eeebab3f198`
   - **DNS App ID**: `1`
   - **Debug Mode**: `0` (Set to `1` for troubleshooting)
5. Click **Save Configuration**.
6. The plugin will automatically query Hostbill for available DNS zones.

## Example API Requests
### **Check Available DNS Zones**
```sh
curl "https://portal.centralcloud.com/admin/api.php?api_id=550c53d50958f3a8b421&api_key=b93e22bd2eeebab3f198&call=getDNSZones"
```

### **Add a DNS Zone**
```sh
curl -X POST -H "Content-Type: application/json" \
-d '{"call": "addDNSZone", "api_id": "550c53d50958f3a8b421", "api_key": "b93e22bd2eeebab3f198", "dnsapp": "1", "name": "example.com"}' \
"https://portal.centralcloud.com/admin/api.php"
```

### **Remove a DNS Zone**
```sh
curl -X POST -H "Content-Type: application/json" \
-d '{"call": "deleteDNSZone", "api_id": "550c53d50958f3a8b421", "api_key": "b93e22bd2eeebab3f198", "dnsapp": "1", "name": "example.com"}' \
"https://portal.centralcloud.com/admin/api.php"
```

## Debugging
### Enable Debugging
To enable debugging, edit the configuration file located at:
```sh
/var/cpanel/cluster/root/config/hostbill
```
Set `debug=1` and restart DNS services:
```sh
/scripts/restartsrv_dnsadmin
```

### Log Location
Errors and debug messages can be found in:
```sh
/usr/local/cpanel/logs/error_log
```

## Uninstallation
To remove the plugin, run:
```sh
rm -rf /usr/local/cpanel/Cpanel/NameServer/Remote/Hostbill/
rm /usr/local/cpanel/Cpanel/NameServer/Remote/Hostbill.pm
rm /var/cpanel/cluster/root/config/hostbill
/scripts/restartsrv_dnsadmin
```

## Support
For further assistance, contact the system administrator or refer to the Hostbill API documentation at:
[https://api2.hostbillapp.com](https://api2.hostbillapp.com)

---
This plugin ensures a seamless connection between cPanel and Hostbill, providing an automated and reliable DNS cluster solution.

