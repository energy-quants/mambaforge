
# The `mambaforge` Container Image

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://github.com/energy-quants/.github/blob/main/CODE_OF_CONDUCT.md)

<br>

This repository builds a container image including the
[`mambaforge`](https://github.com/conda-forge/miniforge)
Python distribution.

The image can be pulled with the below commands:
```
podman login --username $USER --password $GHCR_TOKEN ghcr.io
podman pull ghcr.io/energy-quants/mambaforge/mambaforge:latest
```
