# SOC Incident Report — LAB-WAZUH-001

## Summary

Wazuh generated a high-severity custom alert after detecting repeated Windows authentication failures against the same local account.

- **Incident ID:** LAB-WAZUH-001
- **Severity:** High
- **Custom Wazuh Rule:** 100101
- **Rule Level:** 12
- **Parent Rule:** 60122
- **Windows Event ID:** 4625
- **MITRE ATT&CK:** T1110 — Brute Force
- **Affected endpoint:** SANKET-PC
- **Target account:** wazuhlab
- **Status:** Closed — authorized simulation

## Detection Logic

The custom correlation rule triggers when Wazuh observes five events matching built-in authentication-failure rule `60122`, targeting the same Windows username, within 60 seconds.

## Evidence Observed

- `agent.name`: SANKET-PC
- Windows Event ID `4625`
- repeated failed logons
- target user `wazuhlab`
- authentication package `Negotiate`
- logon process `seclogo`
- logon type `2`
- source address `::1`
- process `C:\Windows\System32\svchost.exe`
- Wazuh custom rule ID `100101`
- Wazuh severity level `12`

## Investigation

The alert timeline showed multiple authentication-failure events immediately preceding the custom correlation alert. The same test account was targeted repeatedly within the configured 60-second window.

The activity was traced to an authorized local test in the home lab. No unauthorized access or compromise was identified.

## SOC Assessment

**Classification:** True Positive — Authorized Simulation

In production, this pattern could indicate password guessing, brute-force activity, an automated process using stale credentials, or unauthorized repeated attempts against a local/domain account.

## Recommended Production Response

1. Validate the source host/IP and targeted account.
2. Search for the same source across additional endpoints.
3. Check for successful logons after the failed attempts.
4. Review the target account for unusual activity or privilege changes.
5. Determine whether lockout or MFA controls were triggered.
6. Block or isolate the source if malicious activity is confirmed.
7. Reset credentials if compromise is suspected.
8. Escalate if lateral movement or successful authentication is observed.

## Final Disposition

The alert was caused by a controlled lab simulation. Detection logic worked as intended and the case was closed.
