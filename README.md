# Android CI Container

This project provides a professional-grade, multi-architecture Docker image environment based on Eclipse Temurin JDK 17, specifically optimized for Android Continuous Integration (CI) workflows.

## Technical Overview

The primary objective of this container is to provide a consistent and performant build environment for both self-hosted runners and cloud-based CI services. By utilizing Docker Buildx, this image provides native support for both `amd64` and `arm64` architectures, eliminating emulation overhead on ARM-based infrastructure such as Oracle Cloud Ampere A1 instances or Apple Silicon environments.

## Component Specifications

The default image distribution (`:latest`) is provisioned with the following toolchain:

| Component     | Specification      |
| :------------ | :----------------- |
| Base JDK      | Eclipse Temurin 17 |
| Android API   | Level 36           |
| Build Tools   | 36.1.0             |
| Gradle        | 9.3.0              |
| Architectures | x86_64, ARM64      |

## Integration Guide

### Image Acquisition

To pull the pre-built image from GitHub Container Registry:

```bash
docker pull ghcr.io/tedliou/android-ci-container:latest
```

### GitHub Actions Configuration

Reference this image in your workflow definition to ensure build environment consistency:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/tedliou/android-ci-container:latest
    steps:
      - uses: actions/checkout@v4
      - name: Execution of Build Task
        run: ./gradlew assembleDebug

```

## Advanced Configuration and Versioning

The architecture of this project supports parameterized builds to accommodate various JDK and SDK requirements.

### Workflow Dispatch

Users can trigger manual builds via the GitHub Actions interface by providing the following inputs:

* `jdk_version`: Target JDK version (e.g., 17, 21).
* `android_api`: Target Android SDK API level (e.g., 34, 35).
* `build_tools`: Specific Android Build Tools version.

### Local Development and Build Procedures

The provided `Makefile` encapsulates the build logic for local testing and multi-architecture deployment:

```bash
# Execute local architecture build
make build

# Execute multi-architecture build and push to registry
make build-multi ANDROID_API=35 BUILD_TOOLS=35.0.0
```

## Contribution Policy

Technical contributions are welcome via Pull Requests. All PRs targeting the `main` branch will trigger an automated CI pipeline to verify build integrity across all supported architectures.

1. Ensure the Dockerfile is located within the `src/` directory (e.g., `src/jdk21.Dockerfile`).
2. Verify that the build logic remains compatible with the existing `Makefile` parameters.
3. Upon successful CI verification and administrative merge, the image will be automatically distributed to GHCR.

## License

This project is licensed under the MIT License.
