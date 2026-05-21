# IBM Semeru Runtimes | Coder Resources - Docker Template Images

This directory provides standardized Docker Images for **Coder workspace templates**, powered by **IBM Semeru Runtimes (OpenJ9)**.

## Overview

Pre-built, production-ready IBM Semeru (OpenJ9) JDK images optimized for Coder remote development environments. Built from official IBM Semeru upstream images to provide high-performance Java execution with consistent tooling.

## Key Details

* **Base Image**: Official IBM Semeru Runtimes (Ubuntu-based)
* **Supported JDK Versions**: 8, 11, 17, 21, 25, 26 (OpenJ9 variants)
* **Default Tag**: `latest` → JDK 25
* **Builder**: Docker Buildx Bake (static matrix configuration)
* **Registry**: Customizable via the `REGISTRY` environment variable (default: `harbor.cluster.internal`)

## Features

* Optimized for memory-efficient and high-throughput workloads (OpenJ9)
* Optional Ubuntu APT source switch to PKU mirror (China)
* Pre-installed essential tools: `curl`, `gzip`, `procps`
* Standardized layout for Coder workspace templates
* Consistent tagging across all JDK versions
* Includes a `personalize` initialization script for post-workspace startup automation
* Configurable `JETBRAINS_DOWNLOAD_URL` build argument to download JetBrains Backend from a custom mirror

## Build Commands

```bash
# Default build (use official Ubuntu sources)
docker buildx bake

# Build with PKU APT mirror (for faster access in China Mainland)
CHANGE_SOURCE=true docker buildx bake

# Inspect build configuration
docker buildx bake --print

```

## Image Registry & Tags

All built images are stored in the internal registry:
`harbor.cluster.internal/coder-images/semeru-runtime`

Available tags:
`8`, `11`, `17`, `21`, `25`, `26`, `latest`

## Project Purpose

Part of the **Coder Resources** ecosystem:

* Serves as a high-performance OpenJ9 base for Coder workspace templates
* Provides enterprise-grade Java runtime environments
* Maintains consistency, security, and compatibility for memory-constrained development workspaces