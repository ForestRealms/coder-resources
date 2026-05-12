# Java Template

A Coder workspace template providing a complete Spring Boot development environment with Eclipse Temurin JDK.

## What's Inside

- **Main development container** – Eclipse Temurin JDK (version selectable) with common development tools.
- **JetBrains IntelliJ IDEA** – Pre-configured for immediate use.
- **Persistent storage** – Your home directory, MySQL data, and Redis data are preserved across workspace restarts.

All containers run inside a private Docker network and can communicate using container hostnames.

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