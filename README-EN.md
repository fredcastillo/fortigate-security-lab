<h1 align="center">P01 — FortiGate Security Lab</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Lab-GNS3-7d5fff?style=for-the-badge" alt="GNS3"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Firewall-FortiGate-e11d48?style=for-the-badge" alt="FortiGate"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Network-VLAN%20Segmentation-1f6feb?style=for-the-badge" alt="VLAN"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Controls-NAT%20%7C%20ACL%20%7C%20DoS-FF6F00?style=for-the-badge" alt="Controls"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Filtering-.exe%20File%20Block-9C27B0?style=for-the-badge" alt="File Filter"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Status-Documented%20Lab-brightgreen?style=for-the-badge" alt="Status"></a>
</p>

> **Network Security · GNS3 · FortiGate** |
> **Student:** Fred Sneyder Castillo Apolinar | **Student ID:** 2025-2175 | **Instructor:** Jonatan Rondon  |

---

## 🎥 Demonstration Video

**[▶ Watch demonstration video](VIDEO_URL)**

---

## 🎯 Laboratory Purpose

This laboratory implements a **Network Security** infrastructure in GNS3 using FortiGate as the central control point between a user segment, a web server and a database server.

The goal is to demonstrate functional security controls, including:

- network segmentation through VLAN 10 and separate subnets;
- access-control policies between users and servers;
- Internet access through NAT;
- WEB Server access to the database restricted to TCP/3306;
- filtering of `.exe` file downloads;
- SYN flood protection through a DoS/rate-limiting policy;
- basic switch hardening;
- DHCP for the user segment.

---

## 🏗️ Topology

![Main topology](images/topology/gns3-topology.png)

The architecture uses a **FortiGate-VM64-KVM** as the enforcement point between three main domains:

| Segment | Component | Network | Purpose |
|---|---|---|---|
| Users | VLAN 10 / Switch | `10.21.75.0/25` | Laboratory clients |
| WEB | WEB-SERVER-LAB | `10.21.75.128/28` | Apache + PHP + HTTPS |
| DB | DB-SERVER-LAB | `10.21.75.144/28` | MariaDB |
| WAN | FortiGate port1 | DHCP | Internet access |

### Components

- **FortiGate-VM64-KVM v7.0.9 build0444** — firewall and policy enforcement point.
- **Cisco IOSvL2 15.2** — access switch and VLAN 10.
- **PC1 (VPCS)** — client used to verify DHCP.
- **Browser-PC** — Docker container with Debian and Firefox ESR used for browser-based testing.
- **WEB-SERVER-LAB** — Docker container with Ubuntu 22.04, Apache, PHP and HTTPS.
- **DB-SERVER-LAB** — Docker container with Ubuntu 22.04 and MariaDB.

The last three components are **containers used to simulate the endpoints and servers required by the assignment inside GNS3**.

---

## 🔐 Security Flow

![Traffic flow](images/topology/traffic-flow.svg)

The design forces inter-segment traffic through FortiGate. The WEB Server and DB Server use separate FortiGate physical ports, preventing direct Layer-2 communication that could bypass firewall policy enforcement.

---

## ✅ Implemented and Demonstrated Controls

| Control | Main evidence |
|---|---|
| Default route | `images/fortigate/default-route.png` |
| NAT | `images/fortigate/policy-users-internet.png` |
| Users → WEB | `images/fortigate/policy-users-web.png` |
| Users → DB blocked | `images/tests/users-db-deny.png` |
| WEB → DB limited to 3306 | `images/fortigate/policy-web-db-3306.png` |
| `.exe` File Filter | `images/tests/exe-block.png` |
| Rate limiting / SYN flood | `images/tests/dos-syn-flood-log.png` |
| VLAN 10 | `images/network/vlan10.png` |
| Basic switch security | `images/network/switch-security.png` |
| DHCP | `images/fortigate/dhcp-port2.png` + `images/containers/pc1-dhcp.png` |

---

## 📚 Documentation

| Document | Contents |
|---|---|
| [01 — Laboratory](docs/01-laboratorio-EN.md) | Purpose, objectives, scope and infrastructure. |
| [02 — Topology and architecture](docs/02-topologia-y-arquitectura-EN.md) | Topology, addressing, VLAN, interfaces and traffic flow. |
| [03 — Configuration and security](docs/03-configuracion-y-seguridad-EN.md) | Main FortiGate, switch and service configuration. |
| [04 — Testing and compliance](docs/04-pruebas-y-cumplimiento-EN.md) | Functional tests, results and evidence. |

---

## ⚙️ Technical Files

### Configurations

```text
files/configs/
├── fortigate/
└── switch/
```

### Scripts

```text
files/scripts/
├── build-web-server.sh
├── build-db-server.sh
└── build-browser-gns3vnc.sh
```

---

## 🖼️ Evidence and diagrams

All screenshots are grouped by purpose:

```text
images/
├── topology/
├── fortigate/
├── network/
├── containers/
└── tests/
```
---

## 👨‍💻 Author

**Fred Castillo**  
*Information Security Technologist Student*  
*Aspiring Red Team | Offensive Security*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
