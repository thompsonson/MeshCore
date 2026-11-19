# Pinned build environment for MeshCore firmware.
# Base image pinned by digest (python:3.13-slim-bookworm, multi-arch), PlatformIO pinned by version.
FROM python@sha256:a5a7017efc5969e00ae2b91c8eb0631049a569652aa4ffc4501769049ae45c72

ARG PLATFORMIO_VERSION=6.2.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && pip install --no-cache-dir "platformio==${PLATFORMIO_VERSION}"

# Packages, platforms and toolchains live on a mounted volume so they persist between builds.
ENV PLATFORMIO_CORE_DIR=/pio \
    HOME=/tmp \
    PLATFORMIO_DISABLE_PROGRESSBAR=true

WORKDIR /src
