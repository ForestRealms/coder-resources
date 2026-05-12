# Eclipse Temurin | Coder Resources - Docker Template Images
This directory providing standardized Docker Images for **Coder workspace templates**.

## Overview
Pre-built, production-ready Eclipse Temurin JDK images optimized for Coder remote development environments. Built from official upstream images with consistent tooling and configuration.

## Key Details
- **Base Image**: Official Eclipse Temurin (Ubuntu Noble)
- **Supported JDK Versions**: 8, 11, 17, 21, 25, 26
- **Default Tag**: `latest` → JDK 25
- **Builder**: Docker Buildx Bake (static matrix configuration)
- **Registry**: Customizable via the `REGISTRY` environment variable (default: `registry.example.com`)

## Features
- Lightweight, production-grade JDK environment
- Optional Ubuntu APT source switch to PKU mirror (China)
- Pre-installed essential tools: `curl`, `gzip`, `procps`
- Standardized layout for Coder workspace templates
- Consistent tagging across all JDK versions
- Includes a `personalize` initialization script for post-workspace startup automation
- Configurable `JETBRAINS_DOWNLOAD_URL` build argument to download JetBrains Backend from a custom mirror

## Build Commands
```bash
# Default build (use official Ubuntu sources)
docker buildx bake

# Build with PKU APT mirror (for faster access in China Mainland)
CHANGE_SOURCE=true docker buildx bake

# Inspect build configuration (no build execution)
docker buildx bake --print
```

## Image Registry & Tags
All built images are stored in the internal registry:
`harbor.cluster.internal/coder-images/eclipse-temurin`

Available tags:
`8`, `11`, `17`, `21`, `25`, `26`, `latest`

## Project Purpose
Part of the **Coder Resources** ecosystem:
- Serves as a base image for Coder workspace templates
- Provides unified JDK environments for development teams
- Maintains security, consistency, and compatibility across workspaces