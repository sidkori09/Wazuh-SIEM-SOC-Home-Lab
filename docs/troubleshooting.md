# Troubleshooting Notes

## Disk/LVM allocation
The Ubuntu VM initially did not use the full virtual disk, which caused a `No space left on device` installation failure. Extending the root logical volume resolved it.

## Staged Wazuh installation
The all-in-one installer failed during a final API verification stage. The environment was rebuilt using staged/manual component installation and independent verification.

## Dashboard certificate permissions
The dashboard service initially could not read `dashboard-key.pem`. Correct ownership/permissions fixed startup.

## Bridged networking and DHCP
The Wazuh VM received different IPs on different networks. This affected the Windows agent manager address, Indexer binding, Filebeat destination, Dashboard `opensearch.hosts`, and TLS validation.

## Indexer binding failure
The Indexer attempted to bind to an old IP and failed with `BindTransportException`. Updating `opensearch.yml` to the current server IP restored service.

## Filebeat TLS mismatch
Filebeat reached port 9200 but failed TLS because the certificate was issued for another address. Restoring a certificate-matching endpoint fixed forwarding.

## Dashboard-to-Indexer connection
The Dashboard still referenced an outdated Indexer IP, resulting in "server is not ready yet" and HTTP 500 errors. Updating `opensearch.hosts` fixed connectivity.

## Dashboard authentication after password change
The `kibanaserver` credential had to be synchronized with the OpenSearch Dashboards keystore after password changes.

## Lessons Learned
- Troubleshoot the SIEM pipeline layer-by-layer.
- Separate network reachability, TLS, authentication, and application health.
- Use stable addressing for SIEM infrastructure where possible.
- Never publish passwords, private keys, or tokens.
