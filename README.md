# The `mambaforge` Container Image


This repository builds a container image including the
[`mambaforge`](https://github.com/conda-forge/miniforge)
Python distribution.

The image can be pulled with the below commands:
```
podman login --username $USER --password $GHCR_TOKEN ghcr.io
podman pull ghcr.io/energy-quants/mambaforge/mambaforge:latest
```
