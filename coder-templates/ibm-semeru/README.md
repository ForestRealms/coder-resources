# Java (IBM Semeru) Template

A Coder workspace template providing a high-performance Java development environment powered by **IBM Semeru Runtimes (OpenJ9)**.

## Overview

This template provides an optimized Java environment leveraging the OpenJ9 JVM, designed for efficient memory management and rapid startup—ideal for development workspaces running within constrained container environments.

## What's Inside

* **IBM Semeru Runtime** – High-performance OpenJ9 JVM.
* **JDK Versions** – Supports **8, 11, 17, 21, 25, 26**.
* **Dev Tools** – Pre-installed essential tools (`curl`, `git`, `procps`, etc.) for seamless development.
* **JetBrains IntelliJ IDEA** – Pre-configured for immediate remote development.
* **Persistent Storage** – Your workspace home directory is preserved across restarts.

## Persistent Data

Your files in the home directory (`/root`) are stored on a persistent Docker volume. They will survive workspace stops and starts, but will be deleted when the workspace is permanently destroyed.

## Accessing IntelliJ IDEA

This template includes support for JetBrains IntelliJ IDEA. To launch it:

1. Ensure you have the [JetBrains Toolbox](https://coder.com/docs/user-guides/workspace-access/jetbrains/toolbox) installed on your local machine.
2. In the Coder dashboard, click the **JetBrains** icon to start the IDE.

Your project folder is located at `/root/project` inside the workspace.

## Workspace Lifecycle

* **Start** – The development container is initialized with your chosen JDK version.
* **Stop** – The container is stopped, but your source code and configurations are retained.
* **Delete** – The container and its associated volume are permanently removed.

## Need Help?

If you encounter any issues or have questions about this template, please contact your platform administrator.