# 03 — Configuration and security

> This section summarizes the configuration implemented and verified in the laboratory. Linked screenshots are rendered automatically by GitHub when the file with the indicated name exists in the corresponding folder.

## 3.1 FortiGate interfaces

Initial IP assignment was performed through CLI to enable GUI access. From that point onward, firewall policies and security profiles were configured through the GUI.

![Interfaces](../images/fortigate/interfaces.png)

Configuration:

- `port1`: DHCP for WAN.
- `port2`: `10.21.75.1/25` for Users.
- `port3`: `10.21.75.129/28` for WEB.
- `port4`: `10.21.75.145/28` for DB.

## 3.2 DHCP — VLAN 10

GUI path: **Network → Interfaces → port2 → DHCP Server**.

Documented range: `10.21.75.10`–`10.21.75.100`, mask `255.255.255.128`, gateway equal to the interface.

![DHCP Server](../images/fortigate/dhcp-port2.png)

PC1 later confirmed `10.21.75.10/25` with gateway `10.21.75.1`.

![PC1 DHCP](../images/containers/pc1-dhcp.png)

## 3.3 Default route

GUI path: **Network → Static Routes → Create New**.

- Destination: `0.0.0.0/0.0.0.0`
- Interface: `port1`
- Gateway: value configured in the WAN environment

![Default route](../images/fortigate/default-route.png)

## 3.4 NAT and Internet access

The `Usuarios_a_Internet` policy allows the user segment to access `port1` with NAT enabled.

![Users to Internet policy](../images/fortigate/policy-users-internet.png)

Validation was performed from Browser-PC using IP connectivity and external browsing after correcting the container DNS setting.

## 3.5 Users → WEB policy

GUI path: **Policy & Objects → Firewall Policy → `Usuarios_a_WEB`**.

The policy controls access from the user segment to `WEB-SERVER-LAB`.

![Users to WEB policy](../images/fortigate/policy-users-web.png)

## 3.6 Users → DB policy

GUI path: **Policy & Objects → Firewall Policy → `Usuarios_a_DB_BLOQUEADO`**.

The policy uses **DENY** to prevent users from reaching the DB Server MySQL service.

![Users to DB deny policy](../images/fortigate/policy-users-db-deny.png)

## 3.7 WEB → DB limited to TCP/3306

GUI path: **Policy & Objects → Firewall Policy → `WEB_a_DB_solo_3306`**.

The policy allows the WEB Server to reach the DB Server only through the MySQL/TCP 3306 service.

![WEB to DB 3306](../images/fortigate/policy-web-db-3306.png)

## 3.8 File Filter — `.exe` blocking

GUI path: **Security Profiles → File Filter → `Bloquear_EXE`**.

The profile was attached to the relevant web traffic policies. The final test used a real Windows executable (`procexp.exe`) so that file classification was based on actual content and signature, not only the filename extension.

![File Filter profile](../images/fortigate/file-filter-exe.png)

![File Filter test log](../images/tests/exe-block.png)

## 3.9 Rate limiting / DoS protection

GUI path: **Policy & Objects → IPv4 DoS Policy → `DoS_Anti_SYNFlood`**.

Documented control:

- `tcp_syn_flood`: enabled.
- Logging: enabled.
- Action: `Block`.
- Threshold: `20`.

![DoS policy](../images/fortigate/dos-syn-flood-policy.png)

The test generated SYN traffic from the laboratory and the security log showed detections and sessions being cleared by the control.

![DoS detection log](../images/tests/dos-syn-flood-log.png)

## 3.10 Switch — VLAN and basic security

VLAN 10 `USERS` was created and assigned to `Gi0/0`–`Gi0/2`. Basic controls were also applied to access ports: port security, BPDU Guard, `nonegotiate`, and shutdown of unused ports.

![VLAN 10](../images/network/vlan10.png)

![Switch security](../images/network/switch-security.png)

![Switch port status](../images/network/switch-ports.png)

## 3.11 Technical files

Docker image build scripts are stored under `files/scripts/` and exported configuration files are stored under `files/configs/`.

> **Pending:** final FortiGate configuration export. It will be added after verifying that it does not contain secrets or sensitive keys.
