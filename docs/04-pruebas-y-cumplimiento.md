# 04 — Pruebas y cumplimiento

## 4.1 Matriz de validación

| Requisito demostrado | Implementación | Prueba | Resultado |
|---|---|---|---|
| Ruta por defecto | `0.0.0.0/0` vía `port1` | `ping 8.8.8.8` + navegación externa | ✅ Verificado |
| NAT | `Usuarios_a_Internet` con NAT habilitado | Tráfico desde Browser-PC hacia Internet | ✅ Verificado |
| Usuarios → WEB | `Usuarios_a_WEB` | Acceso al WEB Server desde Browser-PC | ✅ Verificado en la prueba funcional documentada |
| Usuarios → DB bloqueado | `Usuarios_a_DB_BLOQUEADO` | Intento hacia `10.21.75.146:3306` + Forward Traffic | ✅ Verificado |
| WEB → DB solo 3306 | `WEB_a_DB_solo_3306` | Conexión positiva a 3306 y pruebas negativas en 22, 80, 21, 23, 25, 53, 443, 3389, 3606 y 8080 | ✅ Verificado |
| File Filter `.exe` | `Bloquear_EXE` | Descarga de `procexp.exe` y observación del corte de sesión | ✅ Verificado |
| Rate limiting / DoS | `DoS_Anti_SYNFlood` | SYN flood con `hping3` + Security Events | ✅ Verificado |
| VLAN 10 | Switch `VLAN 10 / USERS` | `show vlan brief` | ✅ Verificado |
| Seguridad básica del switch | Port-security, BPDU Guard, nonegotiate y puertos sin uso en shutdown | `show running-config` + `show interfaces status` | ✅ Verificado |
| 2 servidores /28 | WEB y DB en `/28` | Servicios Apache/HTTPS y MariaDB operativos | ✅ Verificado |
| Usuarios /25 + DHCP | VLAN 10 + DHCP en `port2` | `ip dhcp` + `show ip all` en PC1 | ✅ Verificado |

## 4.2 Evidencias principales

### Usuarios → DB bloqueado

![Users to DB denied](../images/tests/users-db-deny.png)

El log de Forward Traffic identifica la política `Usuarios_a_DB_BLOQUEADO` y registra el tráfico como una violación de política.

### WEB → DB: 3306 permitido

![WEB to DB allowed](../images/tests/web-db-3306-allowed.png)

### WEB → DB: otros puertos bloqueados

![WEB to DB blocked ports](../images/tests/web-db-blocked-ports.png)

Los puertos adicionales documentados fueron: **22, 80, 21, 23, 25, 53, 443, 3389, 3606 y 8080**. El único puerto permitido dentro de la prueba fue **3306**.

### File Filter

![EXE block evidence](../images/tests/exe-block.png)

La prueba final utilizó un ejecutable Windows real y observó la interrupción de la transferencia por el control de File Filter en modo Flow-based.

### SYN flood

![DoS evidence](../images/tests/dos-syn-flood-log.png)

La evidencia de Security Events muestra detecciones `tcp_syn_flood` y acciones `clear_session` después de superar el umbral configurado.

## 4.3 Evidencia de DHCP

![PC1 DHCP](../images/containers/pc1-dhcp.png)

La dirección `10.21.75.10/25` y el gateway `10.21.75.1` confirman la asignación esperada dentro del segmento de usuarios.

## 4.4 Evidencia de la infraestructura

![Browser-PC](../images/containers/browser-pc.png)

![WEB-SERVER-LAB](../images/containers/web-server.png)

![DB-SERVER-LAB](../images/containers/db-server.png)

## 4.5 Evidencia del switch

![VLAN 10](../images/network/vlan10.png)

![Switch security](../images/network/switch-security.png)

![Switch ports](../images/network/switch-ports.png)
