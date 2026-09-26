# 02 — Topology and architecture

## 2.1 Main topology

![GNS3 topology](../images/topology/gns3-topology.png)

![Logical diagram](../images/topology/topology.svg)

The topology separates the Users, WEB and DB segments through dedicated FortiGate interfaces. This ensures that WEB → DB traffic is processed by a real firewall policy instead of being switched directly inside the same Layer-2 domain.

## 2.2 Addressing

| Device | Interface | Address | Prefix | Gateway | Function |
|---|---|---:|---:|---:|---|
| FortiGate | port1 | DHCP | — | DHCP | WAN / Internet |
| FortiGate | port2 | 10.21.75.1 | /25 | — | Users |
| FortiGate | port3 | 10.21.75.129 | /28 | — | WEB |
| FortiGate | port4 | 10.21.75.145 | /28 | — | DB |
| PC1 | eth0 | 10.21.75.10 | /25 | 10.21.75.1 | DHCP client |
| Browser-PC | eth0 | 10.21.75.110 | /25 | 10.21.75.1 | Browser client |
| WEB-SERVER-LAB | eth0 | 10.21.75.130 | /28 | 10.21.75.129 | Apache + PHP + HTTPS |
| DB-SERVER-LAB | eth0 | 10.21.75.146 | /28 | 10.21.75.145 | MariaDB |

## 2.3 User VLAN

The Cisco IOSvL2 switch uses only **VLAN 10 — USERS** for the user segment.

![VLAN 10](../images/network/vlan10.png)

Documented ports:

- `Gi0/0` — uplink to FortiGate `port2`.
- `Gi0/1` — PC1.
- `Gi0/2` — Browser-PC.

Unused ports were disabled as part of basic switch hardening.

## 2.4 Laboratory containers

### Browser-PC

Debian Bookworm Slim Docker container with `firefox-esr`. It is used for browser-based tests and keeps a deliberate static IP (`10.21.75.110/25`) for log traceability.

### WEB-SERVER-LAB

Ubuntu 22.04 Docker container with Apache, PHP and `php-mysqli`. HTTPS uses a self-signed certificate generated during image build.

### DB-SERVER-LAB

Ubuntu 22.04 Docker container with MariaDB. The `labdb` database contains the lab `users` table and the `webuser` account is restricted to the WEB Server source address.

![Browser-PC](../images/containers/browser-pc.png)

![WEB-SERVER-LAB](../images/containers/web-server.png)

![DB-SERVER-LAB](../images/containers/db-server.png)

## 2.5 Traffic flow

![Traffic flow](../images/topology/traffic-flow.svg)

The main relationships are:

- Users → Internet: allowed through outbound policy and NAT.
- Users → WEB: HTTPS traffic controlled by `Usuarios_a_WEB`.
- Users → DB: denied by `Usuarios_a_DB_BLOQUEADO`.
- WEB → DB: allowed only by `WEB_a_DB_solo_3306` using MySQL/TCP 3306.

## 2.6 Security design

The WEB Server and DB Server do not share a Layer-2 segment. Each server is connected to a dedicated physical FortiGate interface, ensuring that traffic between them is subject to firewall inspection and policy enforcement.
