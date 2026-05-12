# Python | Coder Resources - Docker Template Images
This directory providing standardized Docker Images for **Coder workspace templates**.

## Overview
Pre-built, production-ready Python images optimized for Coder remote development environments. Built from official upstream images with consistent tooling and configuration.

## Key Details
- **Base Image**: Official Python (Debian Trixie)
- **Supported Python Versions**: 3.13, 3.14
- **Default Tag**: `latest` → Python 3.14
- **Builder**: Docker Buildx Bake (static matrix configuration)
- **Registry**: Customizable via the `REGISTRY` environment variable (default: `harbor.cluster.internal`)

## Features
- Lightweight, production-grade Python environment
- Optional Ubuntu APT source switch to PKU mirror (China)
- Pre-installed essential tools: `curl`, `gzip`, `procps`
- Standardized layout for Coder workspace templates
- Consistent tagging across all Python versions
- Includes a `personalize` initialization script for post-workspace startup automation
- Configurable `JETBRAINS_DOWNLOAD_URL` build argument to download JetBrains Backend from a custom mirror

## Build Commands
```bash
# Default build (use official APT sources)
docker buildx bake

# Build with PKU APT mirror (for faster access in China Mainland)
CHANGE_SOURCE=true docker buildx bake

# Inspect build configuration (no build execution)
docker buildx bake --print
```

## Image Registry & Tags
All built images are stored in the internal registry:
`harbor.cluster.internal/coder-images/python`

Available tags:
`3.13`, `3.14`, `latest`

## Project Purpose
Part of the **Coder Resources** ecosystem:
- Serves as a base image for Coder workspace templates
- Provides unified Python environments for development teams
- Maintains security, consistency, and compatibility across workspaces