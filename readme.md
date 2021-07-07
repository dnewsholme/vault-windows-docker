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

### Management

#### Certs
##### Expiration
If the cert expires, generate a new one by running `.\generate-selfsignedcert.ps1` again.

##### Import into windows trusted root store
Convert the cert to a der encoded .cer file for importing onto a windows host for trusted connection to the vault web address.

```powershell
push-location .\config
& openssl x509 -outform der -in vault.pem -out vault.cer
pop-location
```
Copy the vault.cer to the windows host and import into the trusted root store.
`Note: The following should be run as an administrator from windows powershell not pwsh`

```powershell
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$cert.import(".\config\vault.cer") 
$store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
$store.open("MaxAllowed") 
$store.add($cert) 
$store.close()
```