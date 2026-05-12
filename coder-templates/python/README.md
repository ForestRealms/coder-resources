# Python Development Template

A standard Python development environment based on Debian 13, ready for data science, web development, or scripting.

## What's Inside

- **Python Development Environment** – Official Python images with a choice of versions, plus essential build tools.
- **JetBrains PyCharm** – Optionally installed at workspace creation. If enabled, PyCharm Professional is pre-configured and ready to use via JetBrains Gateway.

## Creating a Workspace

When you create a new workspace from this template, you will be asked to configure:

- **Python version** – Choose from the available Python releases (e.g., 3.12, 3.11).
- **Install JetBrains PyCharm** – Check the box if you want the PyCharm IDE. It is installed automatically on first start.

These settings are fixed after the workspace is created.

## Accessing PyCharm

If you enabled PyCharm, you can connect to it from your local machine using [JetBrains Gateway](https://www.jetbrains.com/remote-development/gateway/). In the Coder dashboard, click the JetBrains icon to launch the IDE.

## Persistent Storage

Your home directory (`/root`) is stored on a persistent volume. It survives workspace stops and starts, but is permanently removed when the workspace is deleted.

## Workspace Lifecycle

- **Start** – The Python container starts, and PyCharm (if selected) is installed on the first boot.
- **Stop** – The container stops, but your files and installed tools remain.
- **Delete** – The container and all associated data are permanently destroyed.

## Need Help?

If you have questions or encounter issues, please contact your platform administrator.