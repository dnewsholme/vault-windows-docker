# Vault

## About

Creates a docker image (Windows) for hashicorps [vault](https://www.vaultproject.io/).

### Setup

Build the docker image using the dockerfile.

```powershell
docker build --pull --rm -f "dockerfile" -t vault:latest "."
```

Once the image is built generate a self-signed cert for use in the container.

```powershell
.\generate-selfsignedcert.ps1
```

Then bring up the container with docker-compose.

```powershell
docker-compose up -d
```
Connect to vault on [https://localhost:8080](https://localhost:8080)