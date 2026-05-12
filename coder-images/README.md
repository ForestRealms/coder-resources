# Coder Resources | Universal Runtime Docker Images

## Overview

This is the unified monorepo for **Coder workspace runtime base images**. All language environments adopt a standardized, identical build workflow based on Docker Buildx Bake static matrix configuration.

The repository is designed for **massive extensibility**, supporting continuous addition of various development runtime environments with unified variables, build commands and workspace initialization specifications.

## Project Structure

Each subdirectory is an independent, standardized runtime image project, isolated and reusable:

- **Single runtime per folder**

- Unified `docker-bake.hcl` specification

- Unified Dockerfile template initialization logic

## Unified Global Variables

All sub-projects share the same configurable variables for consistent customization:

- **`CHANGE_SOURCE`**
Switch Ubuntu/Debian APT source to mirror for China mainland acceleration. Default: `false`

- **`REGISTRY`**
Private container registry address for image push. Default internal registry: `harbor.cluster.internal`

- **`JETBRAINS_DOWNLOAD_URL`**
Custom mirror URL for automatic JetBrains backend download during workspace startup. Defaults to internal mirror address\.

## Unified Usage (All Environments)

Enter any runtime subdirectory and use the unified build commands:

```Plain Text
# Default build (official upstream sources)
docker buildx bake

# Build with domestic mirror acceleration
CHANGE_SOURCE=true docker buildx bake

# Preview resolved build config without building
docker buildx bake --print
```

## Unified Image Features

All runtime images follow the same Coder workspace specification:

- Production-grade lightweight official runtime base
- Pre-installed basic system utilities: `curl`, `gzip`, `procps`
- Built-in `personalize` initialization script, **exclusively adapted for Coder personalize module**, automatically executed following workspace startup
- Support automatic JetBrains backend deployment via custom mirror
- Standard matrix multi-version build tagging strategy


## Purpose

Standardize all Coder remote development workspace base images, unify build logic and operational specifications, reduce repetitive work, and support rapid expansion of subsequent development environments\.
