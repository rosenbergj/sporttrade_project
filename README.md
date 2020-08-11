# Terraform Wordpress deployment

## Before deploying

Copy the file `credentials.tfvars.example` to `credentials.tfvars`, and replace the credentials in the file with your AWS credentials.

## Usage

To deploy Wordpress with Terraform:

```bash
make init
make plan
make apply
```

Following deployment, note the section at the end of the CLI output that looks similar to the following:

```
Outputs:

wordpress_dns_name = wordpress-alb-123456789.us-east-1.elb.amazonaws.com
```

That URL is the one at which you can reach the Wordpress deployment.

To destroy deployment:

```bash
make destroy
```

## Oops...

So it turns out that [this particular Wordpress AMI](https://aws.amazon.com/marketplace/pp/B00NN8Y43U), a publicly available one from Bitnami, is not a good example for this demonstration, because it hosts the database locally (rather than connecting to an external RDS database), which means:
1. The MySQL RDS in this deploy is not used
1. The two instances of Wordpress spun up by the auto-scaling group are independent and are subject to deletion by scaling actions and policies

Nonetheless, I hope that this repo otherwise demonstrates the requested skill with repeatable deployments. The next step I would take, were this intended to go to production, would be to build a better AMI that runs Wordpress in the desired way.

## Future development

For improvements in the deployment process:
* Custom AMI built with Packer, one better suited to auto-scaling, including connection to external DB
* Store TF state remotely rather than locally

For improvements in the security and usability of the deployed resources:
* Change DB credentials from dummy/default values
* HTTPS/TLS
* Utilize Route53 to have a prettier URL
* Logging from AWS resources to CloudWatch or similar
* Consider switching to Aurora
