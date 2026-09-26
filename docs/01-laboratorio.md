# 01 — Laboratorio

## Información académica

| Campo | Información |
|---|---|
| Estudiante | Fred Sneyder Castillo Apolinar |
| Matrícula | 2025-2175 |
| Materia | Seguridad de Redes |
| Docente | Jonatan Rondon |
| Entorno | GNS3 + FortiGate-VM64-KVM |

## Propósito

Implementar un laboratorio de seguridad de redes donde FortiGate actúe como punto central de control entre usuarios, un servidor web, un servidor de base de datos y la salida a Internet.

## Objetivos

1. Separar usuarios y servidores mediante subredes y VLAN.
2. Aplicar políticas de firewall para controlar las comunicaciones.
3. Proporcionar salida a Internet mediante una ruta por defecto y NAT.
4. Permitir únicamente la comunicación requerida entre WEB y DB.
5. Bloquear descargas de archivos ejecutables mediante File Filter.
6. Detectar y bloquear un SYN flood mediante una política DoS.
7. Aplicar controles básicos de seguridad en el switch.
8. Verificar cada control mediante pruebas reproducibles y evidencia visual.

## Alcance de la implementación

La práctica se construyó en GNS3 con un FortiGate, un switch Cisco IOSvL2, un cliente VPCS y tres contenedores Docker utilizados para simular los endpoints y servidores del escenario.

![Vista general del laboratorio](../images/topology/gns3-topology.png)

## Componentes

- **FortiGate-VM64-KVM v7.0.9 build0444**
- **Cisco IOSvL2 15.2**
- **PC1 (VPCS)**
- **Browser-PC** — Debian + Firefox ESR
- **WEB-SERVER-LAB** — Ubuntu 22.04 + Apache + PHP + HTTPS
- **DB-SERVER-LAB** — Ubuntu 22.04 + MariaDB

## Nota sobre la configuración del FortiGate

La configuración operativa y de seguridad del FortiGate se realizó mediante la **GUI**. La CLI se utilizó únicamente durante el arranque inicial para asignar IP a las interfaces y habilitar el acceso necesario a la GUI, además de emplearse para diagnóstico y verificación cuando fue necesario. Estas acciones no sustituyen la configuración de las políticas y perfiles realizada en la interfaz gráfica.
