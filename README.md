# xSystems LDAP Service

Docker configurable LDAP service.

## Use the Image

Before using the image, set the following environment variables:

| Environment Variable  | Default Value                   | Description                                                                         | Required  |
| :-------------------- | :------------------------------ | :---------------------------------------------------------------------------------- | :-------: |
| LDAP_SCHEMAS          |                                 | Space separated list of schemas to enable e.g.: cosine.schema inetorgperson.schema  |           |
| LDAP_SUFFIX           | dc=my-domain,dc=com             | The top entry in a LDAP Directory Information Tree (DIT).                           |           |
| LDAP_ROOTDN           | cn=Manager,dc=my-domain,dc=com  | The Distinguished Name (DN) of a superuser for the DIT.                             |           |
| LDAP_ROOTPW           | secret                          | The password of the superuser.                                                      |           |
| LDAP_MEMBEROF_ENABLED | false                           | Enable the "memberof overlay".                                                      |           |
| LDAP_TLS_ENABLED      | false                           | Enable and enforce StartTLS.                                                        |           |
| LDAP_TLS_PATH         | /                               | Path to files required by StartTLS i.e. chain.pem, cert.pem, and privkey.pem.       |           |

**NOTE:** *When `LDAP_TLS_ENABLED` is set to `true`, then make sure the following files are available under `LDAP_TLS_PATH`:*

| File        | Description                                                           |
| :---------- | :-------------------------------------------------------------------- |
| chain.pem   | The Certificate Authority's (CA) root and intermediate certificates.  |
| cert.pem    | The server's certificate.                                             |
| privkey.pem | The server's private key.                                             |


## Build the Image

Run the [build.sh](build.sh) script.


## Release the Image

1. Make sure you are allowed to push to the `xsystems` repository on Docker Hub e.g. by doing: `docker login`
2. Set the `COMMIT` environment variable to the Git commit hash of the commit that needs to be released.
3. Set the `VERSION` environment variable to the version that needs to be released.
4. Run the [release.sh](release.sh) script.
