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

### Base de datos

- Instancia `servidor-db` creada (e2-micro, Ubuntu 26.04 LTS, zona `southamerica-east1-a`), en la **subred privada**, sin IP externa.
  - IP interna: `10.0.2.2`
- Acceso SSH mediante Identity-Aware Proxy (IAP): regla `permitir-ssh-iap` (TCP 22 desde `35.235.240.0/20`).
- Salida a Internet para la subred privada mediante:
  - Cloud Router: `router-cloud-ready-ops`
  - Cloud NAT: `nat-cloud-ready-ops`
- MySQL 8.4.10 instalado en `servidor-db`.
- Base de datos `helpdesk_db` creada, con la tabla `Empleados` (ver `helpdesk_db.sql`):

```sql
CREATE TABLE Empleados (id INT PRIMARY KEY, nombre VARCHAR(50));
INSERT INTO Empleados (id, nombre) VALUES (1, 'Administrador');
```

- El firewall de la base de datos solo acepta conexiones al puerto 3306 provenientes de la subred pública.

### Versionado

- Repositorio público en GitHub: [cloud-ready-ops](https://github.com/CristianGonzalez3/cloud-ready-ops).
- Archivos versionados: diagrama de arquitectura, script SQL (`helpdesk_db.sql`), código de la app (`index.html`) y este `README.md`.

---

## Laboratorio 4 (Semana 9): Defensa Oral y Evaluación

- Simulaciones de fallos y revisión de logs del sistema:

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

<br>

---
---

<br>

# Cloud-Ready Ops (English)

**Final Integrative Project (TFI)**

## General Objective

Design, provision, configure and document a three-tier web architecture (Network, Compute and Database) on a public cloud (Google Cloud Platform), simulating a technical delivery to a corporate client.

---

## Architecture

![Architecture Diagram](Diseño%20Arquitectónico.drawio.png)

The architecture consists of three layers deployed in the `southamerica-east1` region:

- **Network (VPC):** `cloud-ready-ops-vpc` — CIDR `10.0.0.0/16`
- **Compute:** web server in the public subnet
- **Database:** MySQL server in the private subnet, with no direct access from the Internet

---

## Lab 1 (Week 6): Design and Networking

- Architecture diagram designed with draw.io.
- VPC created: `cloud-ready-ops-vpc` (`10.0.0.0/16`).
- Subnets:
  - `subred-publica`: `10.0.1.0/24`
  - `subred-privada`: `10.0.2.0/24`
- Firewall rules:
  - `permitir-http-ssh`: TCP 22 and 80 from `0.0.0.0/0`
  - `permitir-mysql-interno`: TCP 3306 from `10.0.1.0/24` (internal traffic from the public subnet only)

---

## Lab 2 (Week 7): Compute and Web Server

- Instance `servidor-web` created (e2-micro, Ubuntu 26.04 LTS, zone `southamerica-east1-a`).
  - Internal IP: `10.0.1.2`
  - Public IP (test): `34.39.212.185`
- Connected via SSH from the GCP browser console.
- Nginx installation and setup:

```bash
sudo apt update && sudo apt install nginx
cd /var/www/html
sudo nano index.html
```

- Custom `index.html` page published, replacing the default Nginx page.
- Public HTTP access verified at `http://34.39.212.185`.

---

## Lab 3 (Week 8): Database and Version Control

### Database

- Instance `servidor-db` created (e2-micro, Ubuntu 26.04 LTS, zone `southamerica-east1-a`), in the **private subnet**, with no external IP.
  - Internal IP: `10.0.2.2`
- SSH access via Identity-Aware Proxy (IAP): rule `permitir-ssh-iap` (TCP 22 from `35.235.240.0/20`).
- Internet egress for the private subnet via:
  - Cloud Router: `router-cloud-ready-ops`
  - Cloud NAT: `nat-cloud-ready-ops`
- MySQL 8.4.10 installed on `servidor-db`.
- Database `helpdesk_db` created, with the `Empleados` table (see `helpdesk_db.sql`):

```sql
CREATE TABLE Empleados (id INT PRIMARY KEY, nombre VARCHAR(50));
INSERT INTO Empleados (id, nombre) VALUES (1, 'Administrador');
```

- The database firewall only accepts connections on port 3306 coming from the public subnet.

### Version Control

- Public GitHub repository: [cloud-ready-ops](https://github.com/CristianGonzalez3/cloud-ready-ops).
- Versioned files: architecture diagram, SQL script (`helpdesk_db.sql`), app code (`index.html`) and this `README.md`.

---

## Lab 4 (Week 9): Oral Defense and Evaluation

- Simulated failures and system log review:

```bash
tail -f /var/log/nginx/error.log
```

- Technical project defense via screen share: GitHub repository, architecture diagram, and live GCP console.

---

## Test Access Summary

| Resource | Detail |
|---|---|
| Web Server (HTTP) | `http://34.39.212.185` |
| VPC | `cloud-ready-ops-vpc` (`10.0.0.0/16`) |
| Public subnet | `10.0.1.0/24` |
| Private subnet | `10.0.2.0/24` |
| Database | MySQL 8.4.10 — `helpdesk_db` (private subnet, no external access) |
