# Java + MySQL + Redis Development Template

A Coder workspace template providing a complete Spring Boot development environment with Eclipse Temurin JDK, MySQL, and Redis.

## What's Inside

- **Main development container** – Eclipse Temurin JDK (version selectable) with common development tools.
- **MySQL** – A dedicated MySQL container (version selectable).
- **Redis** – A dedicated Redis container (version selectable).
- **JetBrains IntelliJ IDEA** – Pre-configured for immediate use.
- **Persistent storage** – Your home directory, MySQL data, and Redis data are preserved across workspace restarts.

All containers run inside a private Docker network and can communicate using container hostnames.

## Creating a Workspace

When you create a new workspace from this template, you will be asked to configure the following options:

### MySQL Settings
- **MySQL version** – Choose between MySQL 9.7.0 and 8.4.9.
- **MySQL Database** – The name of the default database to create. (Required)
- **MySQL root password** – The password for the MySQL `root` user. (Required)

These values cannot be changed after the workspace is created.

### Redis Settings
- **Redis version** – Choose from Redis 8.6.2, 8.4.2, 8.2.5, 8.0.6, or 7.4.8.

Redis version cannot be changed after the workspace is created.

## Connecting to MySQL

Your Spring Boot application can connect to the MySQL container using the hostname and port displayed in the workspace metadata panel.

Typical JDBC URL format:
```
jdbc:mysql://<mysql-hostname>:3306/<database-name>
```
The hostname is shown in the workspace dashboard as "Database Hostname".  
Use the database name and password you provided during workspace creation.

## Connecting to Redis

Similarly, Spring Boot can connect to Redis using the hostname shown as "Redis Hostname" on the dashboard.

Example `application.properties`:
```properties
spring.data.redis.host=<redis-hostname>
spring.data.redis.port=6379
```

No authentication is required by default.

## Accessing IntelliJ IDEA

This template includes JetBrains IntelliJ IDEA Ultimate. To launch it:

1. Make sure you have the [JetBrains Toolbox](https://coder.com/docs/user-guides/workspace-access/jetbrains/toolbox) installed on your local machine.
2. In the Coder dashboard, click the JetBrains icon to start the IDE.

Your project folder is located at `/root/project` inside the workspace.

## Persistent Data

Your files in the home directory (`/root`), MySQL data, and Redis data are stored on persistent Docker volumes. They will survive workspace stops and starts, but will be deleted when the workspace is permanently destroyed.

## Workspace Lifecycle

- **Start** – All three containers (main, MySQL, Redis) are started automatically.
- **Stop** – Containers are stopped but data is retained.
- **Delete** – Containers and their associated volumes are permanently removed.

## Need Help?

If you encounter any issues or have questions about this template, please contact your platform administrator.