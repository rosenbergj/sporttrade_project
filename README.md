# Terraform Wordpress deployment

## Before deploying

Copy the file `credentials.tfvars.example` to `credentials.tfvars`, and replace the credentials in the file with your AWS credentials.

## Usage

To deploy terraform:

```bash
make init
make plan
make apply
```

To destroy deployment:

```bash
make destroy
```

## Future development

* Custom AMI built with packer, including DB connection info
* HTTPS/TLS
* Store TF state remotely
* Logging from AWS resources
* Consider switching to Aurora
