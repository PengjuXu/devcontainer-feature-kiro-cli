
This adds kiro-cli (and symbolic link "kiro") to PATH in your devcontainer.


# Add feature to your devcontainer.json
Example
```
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/pengjuxu/devcontainer-feature-kiro-cli/kiro-cli:latest": {}
  }
}
```
