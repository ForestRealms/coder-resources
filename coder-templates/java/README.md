# Universal Java Development Template

A Coder workspace template providing a flexible Java development environment with **multiple JDK distributions**, **optional database (MySQL/MariaDB)**, and **optional Redis cache** – all managed as sidecar containers on the same Docker network.

## Overview

This template allows developers to quickly spin up a standardized Java workspace tailored to their project needs. Choose your preferred JDK (Eclipse Temurin or IBM Semeru), optionally attach a MySQL or MariaDB database, and optionally include a Redis instance – all pre‑configured and ready for local development via JetBrains Gateway or web terminal.

## What's Inside

* **Multiple JDK Distributions** – Eclipse Temurin (HotSpot) and IBM Semeru (OpenJ9) in versions **8, 11, 17, 21, 25, 26**.
* **Database Sidecar** – Choose from MySQL 9.7, 8.4 or MariaDB 12.3, 11.8, 10.11, or select **No Database**.
* **Redis Sidecar** – Redis 8.8, 8.6, 8.4, 8.2, 7.4, 7.2, 6.2, or **No Redis**.
* **Dev Tools** – Essential tools (`curl`, `git`, `procps`, etc.) are included in the base images.
* **JetBrains IntelliJ IDEA** – Pre‑configured for immediate remote development via JetBrains Gateway.
* **File Browser** – Manage files through a web interface (accessible from the dashboard).
* **Persistent Storage** – Your workspace home directory, database data, and Redis data are each stored on separate persistent Docker volumes.

## Persistent Data

| Volume | Content | Behavior |
|--------|---------|----------|
| `home_volume` | Your workspace home directory (`/root`) | Survives workspace stops and starts; deleted only when workspace is permanently destroyed. |
| `database_data` | MySQL/MariaDB data directory (`/var/lib/mysql`) | Persists across restarts; deleted only when workspace is destroyed or when you switch from a database version to “No Database”. |
| `redis_data` | Redis data directory (`/data`) | Same persistence model as database_data. |

> **Note:** When you choose “No Database” or “No Redis”, the corresponding container and volume are **not created**. Switching from a database version to “No Database” will **delete the existing data volume** – proceed with caution.

## Accessing IntelliJ IDEA

This template includes support for JetBrains IntelliJ IDEA. To launch it:

1. Ensure you have the https://coder.com/docs/user-guides/workspace-access/jetbrains/toolbox installed on your local machine.
2. In the Coder dashboard, click the **JetBrains** icon to start the IDE.

## Connecting to Database / Redis

Inside the workspace, the database and Redis hosts are automatically injected as environment variables:

- `DATABASE_HOST` – hostname of the database container (e.g., `coder-owner-workspace-database`)
- `REDIS_HOST` – hostname of the Redis container

Use these in your application configuration. For example, in Spring Boot:

```properties
spring.datasource.url=jdbc:mysql://${DATABASE_HOST}:3306/${DATABASE_NAME}?useSSL=false
spring.datasource.username=root
spring.datasource.password=YOUR_DATABASE_PASSWORD
spring.redis.host=${REDIS_HOST}
```

> **Note:** The database container listens on port 3306, Redis on 6379. No ports are exposed to the host – all communication stays within the Docker network.

## Workspace Lifecycle

* **Start** – The development container is created with your chosen JDK. If you selected a database or Redis, those sidecar containers are also started. Persistent volumes are attached.
* **Stop** – All containers (workspace, database, Redis) are **destroyed**. Persistent volumes remain intact, preserving your code and data.
* **Update** – You can change JDK version, database version, or Redis version while the workspace is running. Sidecar containers may be recreated if the image changes.
* **Delete** – The workspace and all associated containers, networks, and volumes are **permanently removed**. This action cannot be undone.

## Parameters

| Parameter | Description | Options                                                |
|-----------|-------------|--------------------------------------------------------|
| JDK version | Java distribution and version | Eclipse Temurin 8-26, IBM Semeru 8-26                  |
| Database version | Database engine and version | MySQL 9.7, 8.4; MariaDB 12.3, 11.8, 10.11; No Database |
| Database Name | Name of the initial database | Free text (default: `database`)                        |
| Database root password | Root password for the database | Free text (**DO NOT** leave blank)                     |
| Redis version | Redis version | 8.8, 8.6, 8.4, 8.2, 7.4, 7.2, 6.2; No Redis            |

## Need Help?

If you encounter any issues or have questions about this template, please contact your platform administrator.