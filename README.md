# Cloud-Ready Ops

**Trabajo Final Integrador (TFI)**

## Objetivo General

Diseñar, aprovisionar, configurar y documentar una arquitectura web de tres capas (Red, Cómputo y Base de Datos) en la nube pública (Google Cloud Platform), simulando la entrega técnica a un cliente corporativo.

---

## Arquitectura

![Diagrama de Arquitectura](Diseño%20Arquitectónico.drawio.png)

La arquitectura consta de tres capas desplegadas en la región `southamerica-east1`:

- **Red (VPC):** `cloud-ready-ops-vpc` — CIDR `10.0.0.0/16`
- **Cómputo:** servidor web en la subred pública
- **Base de datos:** servidor MySQL en la subred privada, sin acceso directo desde Internet

---

## Laboratorio 1 (Semana 6): Diseño y Redes

**Objetivo:** trazar el mapa de la infraestructura y sentar las bases de conectividad.

- Diagrama de arquitectura diseñado en draw.io.
- VPC creada: `cloud-ready-ops-vpc` (`10.0.0.0/16`).
- Subredes:
  - `subred-publica`: `10.0.1.0/24`
  - `subred-privada`: `10.0.2.0/24`
- Reglas de firewall:
  - `permitir-http-ssh`: TCP 22 y 80 desde `0.0.0.0/0`
  - `permitir-mysql-interno`: TCP 3306 desde `10.0.1.0/24` (solo tráfico interno de la subred pública)

---

## Laboratorio 2 (Semana 7): Cómputo y Servidor Web

**Objetivo:** levantar servidores y desplegar la aplicación frontal.

- Instancia `servidor-web` creada (e2-micro, Ubuntu 26.04 LTS, zona `southamerica-east1-a`).
  - IP interna: `10.0.1.2`
  - IP pública (de prueba): `34.39.212.185`
- Conexión por SSH desde el navegador de GCP.
- Instalación y configuración de Nginx:

```bash
sudo apt update && sudo apt install nginx
cd /var/www/html
sudo nano index.html
```

- Página `index.html` propia publicada, reemplazando la página default de Nginx.
- Verificado el acceso público por HTTP en `http://34.39.212.185`.

---

## Laboratorio 3 (Semana 8): Base de Datos y Versionado

**Objetivo:** asegurar los datos e implementar prácticas de versión DevOps en GitHub.

### Base de datos

- Instancia `servidor-db` creada (e2-micro, Ubuntu 26.04 LTS, zona `southamerica-east1-a`), en la **subred privada**, sin IP externa.
  - IP interna: `10.0.2.2`
- Acceso SSH resuelto mediante Identity-Aware Proxy (IAP): regla `permitir-ssh-iap` (TCP 22 desde `35.235.240.0/20`).
- Salida a Internet para la subred privada (necesaria para `apt install`) mediante:
  - Cloud Router: `router-cloud-ready-ops`
  - Cloud NAT: `nat-cloud-ready-ops`
- MySQL 8.4.10 instalado en `servidor-db`.
- Base de datos `helpdesk_db` creada, con la tabla `Empleados`:

```sql
CREATE TABLE Empleados (id INT PRIMARY KEY, nombre VARCHAR(50));
INSERT INTO Empleados (id, nombre) VALUES (1, 'Administrador');
```

- El firewall de la base de datos solo acepta conexiones al puerto 3306 provenientes de la subred pública (donde vive el servidor web).

### Versionado

- Repositorio público creado en GitHub: [cloud-ready-ops](https://github.com/CristianGonzalez3/cloud-ready-ops).
- Archivos versionados:
  - Diagrama de arquitectura (`Diseño Arquitectónico.drawio.png`)
  - Script SQL de la base de datos (`helpdesk_db.sql`)
  - Código de la aplicación web (`index.html`)
  - Este archivo de documentación (`README.md`)

---

## Laboratorio 4 (Semana 9): Defensa Oral y Evaluación

**Objetivo:** validación técnica y defensa del proyecto simulando un entorno corporativo.

- Simulaciones de fallos y revisión de logs del sistema para diagnóstico:

```bash
tail -f /var/log/nginx/error.log
```

- Defensa técnica del proyecto compartiendo pantalla: repositorio de GitHub, diagrama de arquitectura y consola de GCP funcionando en vivo.

---

## Resumen de accesos de prueba

| Recurso | Detalle |
|---|---|
| Servidor Web (HTTP) | `http://34.39.212.185` |
| VPC | `cloud-ready-ops-vpc` (`10.0.0.0/16`) |
| Subred pública | `10.0.1.0/24` |
| Subred privada | `10.0.2.0/24` |
| Base de datos | MySQL 8.4.10 — `helpdesk_db` (subred privada, sin acceso externo) |
