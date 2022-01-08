
# The `mambaforge` Container Image

[![contributor-covenant]](https://github.com/energy-quants/.github/blob/main/CODE_OF_CONDUCT.md)
[![github-license]](https://github.com/energy-quants/mambaforge/blob/main/LICENSE)
[![github-release]](https://github.com/energy-quants/mambaforge/releases/latest)

<br>

This repository builds a container image including the
[`mambaforge`](https://github.com/conda-forge/miniforge)
Python distribution.

The image can be pulled with the below commands:
```
podman login --username $USER --password $GHCR_TOKEN ghcr.io
podman pull ghcr.io/energy-quants/mambaforge/mambaforge:latest
```



<!-- badges -->
[contributor-covenant]: <https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg> "Contributor Covenant"
[github-license]: <https://img.shields.io/github/license/energy-quants/mambaforge.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhWlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TxSoVBzuIOGSonSyIijpKFYtgobQVWnUweekfNGlIUlwcBdeCgz%2BLVQcXZ10dXAVB8AfE0clJ0UVKvC8ptIjxwuN9nHfP4b37AKFRYarZNQ6ommWk4jExm1sVe17hQwC9iGBGYqaeSC9m4Flf99RNdRflWd59f1a/kjcZ4BOJ55huWMQbxNObls55nzjESpJCfE48ZtAFiR%2B5Lrv8xrnosMAzQ0YmNU8cIhaLHSx3MCsZKvEUcVhRNcoXsi4rnLc4q5Uaa92TvzCY11bSXKc1gjiWkEASImTUUEYFFqK0a6SYSNF5zMM/7PiT5JLJVQYjxwKqUCE5fvA/%2BD1bszA54SYFY0D3i21/jAI9u0Czbtvfx7bdPAH8z8CV1vZXG8DsJ%2Bn1thY%2BAga2gYvrtibvAZc7wNCTLhmSI/lpCYUC8H5G35QDBm%2BBvjV3bq1znD4AGZrV8g1wcAhEipS97vHuQOfc/u1pze8HpBlyuykBzIwAAAAGYktHRAD/AP8A/6C9p5MAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfmAQkCMDi4YW4GAAACcUlEQVRYw%2B2Wz2oUQRCHv5oZ40EJiE8QNoJ6ctkaCGYeQIxIBM3Ji4aAlwgm3kIOgSAeNGAeIBdJXiEK4slDBmeCrIoRwgQCHvUSwXVFy8sEJnHX%2BbMaPaSgobvp/vrX1dXdJVS0OI4HzewJgIhcaDQam1U4TlUBZnYNqAG1tM5BCzjaqX5gAv6UScHdOlEUXReRKeAscKTL0G/AWzNbUNVlEfnRs4AoigIRWTAzv9TORF6a2ZSqvigkIIqie8A00PeXvd42swe%2B78/sj4HJnMW/APOtVqtfVcXM5jJHNKeq0mq1%2BoH5dGw36xORyV%2BC0MwWgXaHCR9FZMlxnDOqOhsEwU43chAEO6o6C5wWkSXgUycPiMjibsPbrfi%2BP2Nms3EcvwcG0%2B6tJElOjY2NfS/jY1XdBsbNbCKPt%2Bcarq%2Bvj2YGAwzUarXLVQ%2B7CG//OzDd4QpO9xBwuTwn87YPmdn5tPk1LQDDcRwPVfgrCvGyHribucPLZrbSoxcK8RyAMAwHzGw0M/kRsABY2r4SRVGt6MpleA6A67p3ADdVu9poNJq%2B778xs6fpBBe4XVRAGZ7TbDZPADcy7nqYYWXr42EYnsxbvCzPabfbt4Djaefrer3%2BPPM2PANepc1jrutO5L6zJXkecDMzfzuO4/ra2tomgOd5g8AH4NyuauB%2BjoZSPC9zPQBGgBHP87rBWwVCoBTPAa4CYZHgBoqkXqV4jqpuJEkybGYXReQx8A74nO52C1gBLiVJMqyqGwX%2BgVI8DyD9HFbT0rOV4f3znPBQQJGktGquuCf368UDk1RLVPfkfpUF/CZXzPVANvc7tP/WfgKSP0KE8r07SgAAAABJRU5ErkJggg%3D%3D> "License"
[github-release]: <https://img.shields.io/github/release/energy-quants/mambaforge.svg?logo=github> "Latest Release"
<!-- badges -->

