# Architecture

## Components

### Windows Endpoint — SANKET-PC
- Wazuh agent
- Windows Security Event Log
- Controlled test account `wazuhlab`

### Ubuntu Wazuh Server
- Wazuh Manager
- Filebeat
- Wazuh Indexer
- Wazuh Dashboard

## Data Flow

```text
Windows Security Event Log
        ↓
Wazuh Agent
        ↓ TCP 1514
Wazuh Manager
        ↓
alerts.json
        ↓
Filebeat
        ↓ TLS/9200
Wazuh Indexer
        ↓
Wazuh Dashboard / Threat Hunting
```

## Detection Logic

1. Windows generates Event ID `4625`.
2. Wazuh built-in rule `60122` detects each authentication failure.
3. Custom rule `100101` correlates five failures for the same username within 60 seconds.
4. Wazuh generates a Level 12 alert mapped to MITRE ATT&CK `T1110`.
