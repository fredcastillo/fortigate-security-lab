# 01 — Laboratory

## Academic information

| Campo | Información |
|---|---|
| Student | Fred Sneyder Castillo Apolinar |
| Student ID | 2025-2175 |
| Course | Network Security |
| Instructor | Jonatan Rondon |
| Environment | GNS3 + FortiGate-VM64-KVM |

## Purpose

Implement a network security laboratory where FortiGate acts as the central control point between users, a web server, a database server and Internet access.

## Objectives

1. Separar usuarios y servidores mediante subredes y VLAN.
2. Aplicar políticas de firewall para controlar las comunicaciones.
3. Proporcionar salida a Internet mediante una ruta por defecto y NAT.
4. Permitir únicamente la comunicación requerida entre WEB y DB.
5. Bloquear descargas de archivos ejecutables mediante File Filter.
6. Detectar y bloquear un SYN flood mediante una política DoS.
7. Aplicar controles básicos de seguridad en el switch.
8. Verificar cada control mediante pruebas reproducibles y evidencia visual.

## Implementation scope

The laboratory was built in GNS3 with a FortiGate, a Cisco IOSvL2 switch, a VPCS client and three Docker containers used to simulate the endpoints and servers in the scenario.

![Laboratory overview](../images/topology/gns3-topology.png)

## Components

- **FortiGate-VM64-KVM v7.0.9 build0444**
- **Cisco IOSvL2 15.2**
- **PC1 (VPCS)**
- **Browser-PC** — Debian + Firefox ESR
- **WEB-SERVER-LAB** — Ubuntu 22.04 + Apache + PHP + HTTPS
- **DB-SERVER-LAB** — Ubuntu 22.04 + MariaDB

## FortiGate configuration note

The operational and security configuration of FortiGate was performed through the **GUI**. The CLI was used only during initial bootstrap to assign interface IP addresses and enable the access required to reach the GUI, and later for diagnostic and verification commands when needed. These actions did not replace the policy and security-profile configuration performed in the GUI.
