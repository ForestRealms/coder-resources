# Coder Resources
> **Unofficial Community-Driven Resources**  
> This repository is **not affiliated with the official Coder team**. It contains self-customized Docker images and self-hosted available Coder workspace templates for internal enterprise deployment and public reference.

This repository serves as a centralized collection of custom **Docker images** and **Coder templates (Terraform)** designed to provision consistent and reproducible **Cloud Development Environments (CDEs)**.

## Repository Structure

- `coder-images/`: Contains Dockerfiles organized by runtime (e.g., JVM, Node, Python).
- `coder-templates/`: Terraform-based templates categorized by stack complexity (from standalone runtimes to multi-service clusters with DBs).

For a full list of available environments, please explore the subdirectories directly.

## Key Features

- **Parallelized Builds**: Leverages `docker buildx bake` for efficient multi-target image generation.
- **Parameterized Registry**: Easily override the `REGISTRY` variable for deployment across different environments (Internal Harbor vs. Cloud).
- **Versioned Tags**: Explicit version tagging for all runtimes, with `:latest` pointing to the latest stable release.
- **Coder Native Compatibility**: All images support the official Coder `personalize` module for automated workspace initialization.
- **Architecture as Code**: Consistent resource management (CPU, RAM, Storage) via Coder's Terraform provider.

## Usage

After cloning the repository, follow the steps below:

### 1. Build and Push Images

Navigate to the desired image directory and build the container:

```bash
# Build & push images with Bake
docker buildx bake --push

# Custom registry / domestic source
REGISTRY=your-registry.example.com CHANGE_SOURCE=true docker buildx bake --push
```

Supported global build variables:
- `REGISTRY`: Custom container registry address
- `CHANGE_SOURCE`: Toggle domestic APT mirror acceleration (default: `false`)
- `JETBRAINS_DOWNLOAD_URL`: Custom mirror for JetBrains backend offline deployment

### 2. Deploy Templates to Coder

Ensure the [Coder CLI](https://coder.com/docs/install/cli) is authenticated, then push your template:

```bash
coder templates push
```

## Documentation & Reference
- Official Coder Docs: [coder.com/docs](https://coder.com/docs)
- All custom images strictly follow official Coder workspace specification

## Need Help?
Open an Issue for template requests, feature suggestions or bug reports.